import {GeoPoint} from "firebase-admin/firestore";

export interface MetaReport {
    coordinate: GeoPoint;
    id: string;
    reportsCount: number;
    rating: number;
  }
