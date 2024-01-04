//
//  AccelerometerManager.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 19/11/2023.
//

import Foundation
import CoreMotion

final class AccelerometerManager {
    let motion = CMMotionManager()

    var calibratedAcc: AccelerometerData?
    
    init() {}
    
    func initializeAccelerometer() {
        if self.motion.isAccelerometerAvailable {
            self.motion.accelerometerUpdateInterval = 0.1
            self.motion.startAccelerometerUpdates()
        }
    }
    
    func getAccelerometerData() -> AccelerometerData {
        if self.motion.isAccelerometerAvailable, let data = self.motion.accelerometerData {
            if let calibratedAcc = self.calibratedAcc {
                return self.adjustForOrientation(data.acceleration, referenceAcceleration: calibratedAcc)
            }
            else {
                calibrateAcc()
                return AccelerometerData(x: 0, y: 0, z: 0)
            }
        } else {
            return AccelerometerData(x: 0, y: 0, z: 0)
        }
    }
    
    func getVerticalAcceleration(accData: AccelerometerData) -> Double {
        if let calibratedAcc = self.calibratedAcc {
            return abs(accData.y * calibratedAcc.y + accData.z * calibratedAcc.z)
        } else {
            calibrateAcc()
            return 0
        }
    }
    
    func calibrateAcc() {
        if let data = self.motion.accelerometerData {
            self.calibratedAcc = AccelerometerData(x: data.acceleration.x, y: data.acceleration.y, z: data.acceleration.z)
        }
    }
    
    func adjustForOrientation(_ acceleration: CMAcceleration, referenceAcceleration: AccelerometerData) -> AccelerometerData {
        let referenceVector = (x: referenceAcceleration.x, y: referenceAcceleration.y, z: referenceAcceleration.z)
        let currentVector = (x: acceleration.x, y: acceleration.y, z: acceleration.z)
        
        let adjustedX = currentVector.x - referenceVector.x
        let adjustedY = currentVector.y - referenceVector.y
        let adjustedZ = currentVector.z - referenceVector.z
        
        return AccelerometerData(x: adjustedX, y: adjustedY, z: adjustedZ)
    }
}
