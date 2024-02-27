import {onRequest} from "firebase-functions/v1/https";
import {onSchedule} from "firebase-functions/v2/scheduler";
import {logger} from "firebase-functions/v1";
import {firestore as adminFirestore} from "firebase-admin";
import admin from "firebase-admin";
import {v4 as uuidv4} from "uuid";
import {GeoPoint, Timestamp} from "firebase-admin/firestore";
import {Report} from "./models/Report";
import {MetaReport} from "./models/MetaReport";
import {MetaReportData} from "./models/MetaReportData";
import {ReportLocationData} from "./models/ReportLocationData";
import {getDistance} from "./utils";

admin.initializeApp();

const db = adminFirestore();
const reportsRef = db.collection("reports");
const metaReportsRef = db.collection("metaReports");


// Create metareports every 6 hours
exports.createMetaReports = onSchedule("every 10 minutes", async () => {
  try {
    // Initialize arrays for reports and metareports data
    const reportsLocationsData: ReportLocationData[] = [];
    const newMetaReportsData: MetaReportData[] = [];

    // Fill newMetaReportsData array with data of existing metareports
    const metaReportsSnapshot = await metaReportsRef.get();
    generateNewMetaReportsData(metaReportsSnapshot, newMetaReportsData);

    // Fill reportsLocationsData array with locations held in reports
    // For each location find corresponding metareport
    const reportsSnapshot = await reportsRef.get();
    generateReportsLocationsData(
      reportsSnapshot,
      reportsLocationsData,
      newMetaReportsData);

    // For each metareport calculate average rating based on its reports
    calculateAverageRatings(reportsLocationsData, newMetaReportsData);

    // Update metareports colletion to database
    await sendNewMetaReportsToFirebase(newMetaReportsData);
  } catch (error) {
    logger.log("Error in createMetaReports function:", error);
  }
});

/**
 *
 * @param {MetaReportData[]} newMetaReportsData
 */
async function sendNewMetaReportsToFirebase(
  newMetaReportsData: MetaReportData[]) {
  for (const reportData of newMetaReportsData) {
    const {id, coordinate, rating, reportsCount} = reportData;
    const reportDocRef = db.collection("metaReports").doc(id);
    const reportDoc = await reportDocRef.get();
    if (reportDoc.exists) {
      await reportDocRef.update({coordinate, rating, reportsCount});
      logger.log("Document with id", id, "updated.");
    } else {
      await reportDocRef.set({id, coordinate, rating, reportsCount});
      logger.log("Document with id", id, "created.");
    }
  }
}

/**
 *
 * @param {ReportLocationData[]} reportsLocationsData
 * @param {MetaReportData[]} metaReportsData
 */
function calculateAverageRatings(
  reportsLocationsData: ReportLocationData[],
  metaReportsData: MetaReportData[]) {
  reportsLocationsData.forEach((data) => {
    const index = data.metaReportIndex;
    const rating = data.rating;
    metaReportsData[index].ratingSum += rating;
    metaReportsData[index].reportsCount += 1;
  });
  for (let index = 0; index < metaReportsData.length; index++) {
    const ratingSum = metaReportsData[index].ratingSum;
    const reportsCount = metaReportsData[index].reportsCount;
    if (reportsCount > 0) {
      metaReportsData[index].rating = ratingSum / reportsCount;
    } else {
      metaReportsData[index].rating = 0;
    }
  }
}

/**
 *
 * @param {adminFirestore.QuerySnapshot<adminFirestore.DocumentData>} snapshot
 * @param {MetaReportData[]} newMetaReportsData
 */
function generateNewMetaReportsData(
  snapshot: adminFirestore.QuerySnapshot<adminFirestore.DocumentData>,
  newMetaReportsData: MetaReportData[]) {
  snapshot.forEach((doc) => {
    const data = doc.data();
    const metaReport: MetaReport = {
      coordinate: data.coordinate,
      id: data.id,
      rating: data.rating,
      reportsCount: 0,
    };
    const metaReportData: MetaReportData = {
      coordinate: metaReport.coordinate,
      id: metaReport.id,
      ratingSum: 0,
      reportsCount: 0,
      rating: 0,
    };
    newMetaReportsData.push(metaReportData);
  });
}

/**
 *
 * @param {adminFirestore.QuerySnapshot<adminFirestore.DocumentData>} snapshot
 * @param {ReportLocationData[]} reportsLocationsData
 * @param {MetaReportData[]} metaReportsData
 */
function generateReportsLocationsData(
  snapshot: adminFirestore.QuerySnapshot<adminFirestore.DocumentData>,
  reportsLocationsData: ReportLocationData[],
  metaReportsData: MetaReportData[]) {
  snapshot.forEach((doc) => {
    const data = doc.data();
    const report: Report = {
      coordinates: data.coordinates,
      id: data.id,
      rating: data.rating,
      timestamp: data.timestamp,
    };
    const timestampInSeconds = report.timestamp.seconds;
    const nowInSeconds = Timestamp.now().seconds;
    const reportAgeInSeconds = nowInSeconds - timestampInSeconds;
    if (reportAgeInSeconds > 30*24*60*60) {
      // delete reports older than a month
      doc.ref.delete();
      return;
    }
    report.coordinates.forEach((location) => {
      const index = findMetaReportIndexForLocation(metaReportsData, location);
      if (index == -1) {
        metaReportsData.push({
          coordinate: location,
          id: uuidv4(),
          ratingSum: 0,
          reportsCount: 0,
          rating: 0,
        });
        const locationData: ReportLocationData = {
          metaReportIndex: metaReportsData.length - 1,
          rating: report.rating,
        };
        reportsLocationsData.push(locationData);
      } else {
        const locationData: ReportLocationData = {
          metaReportIndex: index,
          rating: report.rating,
        };
        reportsLocationsData.push(locationData);
      }
    });
  });
  logger.log("report count:", snapshot.docs.length);
  logger.log("viable reports locations count:", reportsLocationsData.length);
}

/**
 *
 * @param {MetaReportData[]} metaReportsData
 * @param {GeoPoint} location
 * @return {number} Index of corresponding metaReport. If equal to -1,
 * there is not corresponding metaReport.
 */
function findMetaReportIndexForLocation(
  metaReportsData: MetaReportData[],
  location: GeoPoint): number {
  if (metaReportsData.length == 0) {
    logger.log("metaReportsData is empty");
    return -1;
  }
  const firstLat = metaReportsData[0].coordinate.latitude;
  const firstLong = metaReportsData[0].coordinate.longitude;
  let closestMetareportIndex = 0;
  let closestDistance = getDistance(
    firstLat,
    firstLong,
    location.latitude,
    location.longitude);
  metaReportsData.forEach((metaReportData, index) => {
    const metaReportLat = metaReportData.coordinate.latitude;
    const metaReportLong = metaReportData.coordinate.longitude;
    const distance = getDistance(metaReportLat,
      metaReportLong,
      location.latitude,
      location.longitude);
    if (distance < closestDistance) {
      closestDistance = distance;
      closestMetareportIndex = index;
    }
  });
  if (closestDistance < 20) {
    return closestMetareportIndex;
  } else {
    return -1;
  }
}

/**
 *
 * @param {number} routeDistance
 * @param {number[]} latitudes
 * @param {number[]} longitudes
 * @return {Promise<{rating: number, coverage: number}>}
 */
async function calculateRouteData(
  routeDistance: number,
  latitudes: number[],
  longitudes: number[]): Promise<{rating: number, coverage: number}> {
  let routeRatingSum = 0;
  let locationsCoveredCount = 0;
  let distanceCovered = 0;
  let lastLat: number = latitudes[0];
  let lastLong: number = longitudes[0];

  // Get metareports from database
  const metaReports = await getMetareports();

  // For each route point find near metareport
  latitudes.forEach((lat, index) => {
    const long = longitudes[index];
    metaReports.forEach((metaReport) => {
      const reportLat = metaReport.coordinate.latitude;
      const reportLong = metaReport.coordinate.longitude;
      const distance = getDistance(reportLat, reportLong, lat, long);

      // If the distance between metareport and route's point < 50 metres
      if (distance < 50) {
        // Update the variabes
        routeRatingSum += metaReport.rating;
        locationsCoveredCount += 1;
        distanceCovered += getDistance(lastLat, lastLong, lat, long);
        return;
      }
    });

    // Set current route's point as last point
    lastLat = lat;
    lastLong = long;
  });

  // Calculate rating and coverage
  let rating = 0;
  let coverage = 0;
  if (locationsCoveredCount > 0) {
    rating = routeRatingSum / locationsCoveredCount;
    coverage = Math.min(1, distanceCovered / routeDistance);
  }

  return {
    rating,
    coverage,
  };
}

// Main function that manages the route data request
exports.getRouteData = onRequest(async (req, res) => {
  try {
    const body = req.body;
    const routeDistance: number = body.data.distance;
    const latitudes: number[] = body.data.latitudes;
    const longitudes: number[] = body.data.longitudes;

const routeData = calculateRouteData(routeDistance, latitudes, longitudes);

    // Send route data result
    const resultRoute = {
      data: routeData,
    };

    res.send(resultRoute);
  } catch (error) {
    logger.log("Error in function getRouteData:", error);
  }
});

/**
 *
 * @return {Promise<MetaReport>}
 */
async function getMetareports(): Promise<MetaReport[]> {
  return [];
}
