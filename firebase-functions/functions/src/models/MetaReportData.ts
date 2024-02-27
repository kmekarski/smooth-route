import {GeoPoint} from "firebase-admin/firestore";

export interface MetaReportData {
    coordinate: GeoPoint;
    id: string;
    ratingSum: number;
    reportsCount: number;
    rating: number;
  }
