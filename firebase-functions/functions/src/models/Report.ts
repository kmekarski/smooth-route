import {GeoPoint, Timestamp} from "firebase-admin/firestore";

export interface Report {
    coordinates: GeoPoint[];
    id: string;
    rating: number;
    timestamp: Timestamp;
  }
