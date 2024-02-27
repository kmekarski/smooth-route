//
//  RaportsManager.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 17/11/2023.
//

import Foundation

final class ReportsManager {
    
    func getResultData(
        verticalAccelerationHistory: [Double],
        speedHistory: [Double],
        speedSensitivity: Double,
        instabilityThreshold: Double,
        instabilityImpact: Double) -> (result: Double, thresholdExceededCount: Int) {
        var thresholdExceededCount = 0
        guard verticalAccelerationHistory.count == speedHistory.count else {
            return (result: 0.0, thresholdExceededCount: 0)
        }
        
        let dataSize = verticalAccelerationHistory.count
        
        // Initialize variables to track wobbliness
        var wobblinessSum = 0.0
        // Analyze each data point
        for i in 0..<dataSize {
            let speedFactor = (speedSensitivity/33) * (speedHistory[i] - 60) + 2.5
            
            // Vertical acceleration of this single record
            let verticalAcceleration = verticalAccelerationHistory[i]
            
            // Check if the vertical acceleration exceeds the adjusted threshold
            if verticalAcceleration > instabilityThreshold {
                thresholdExceededCount += 1
                wobblinessSum += instabilityImpact * verticalAcceleration / speedFactor
            }
        }
        
        // Calculate total wobbliness score
        let result = max(10.0 - wobblinessSum, 0)
        return (result: result, thresholdExceededCount: thresholdExceededCount)
    }
    
    
    func getResult(
        verticalAccelerationHistory: [Double],
        speedHistory: [Double],
        speedSensitivity: Double,
        instabilityThreshold: Double,
        instabilityImpact: Double) -> Double {
            
        guard verticalAccelerationHistory.count == speedHistory.count else {
            return 0.0
        }
        
        let dataSize = verticalAccelerationHistory.count
        // Initialize variables to track instability
            var ovrInstability = 0.0
        // Analyze each element in history
        for i in 0..<dataSize {
            let speedFactor = speedSensitivity * speedHistory[i]
            
            // Vertical acceleration of this single record
            let verticalAcceleration = verticalAccelerationHistory[i]
            
            // Check if the vertical acceleration exceeds the threshold
            if verticalAcceleration > instabilityThreshold {
                ovrInstability += instabilityImpact * verticalAcceleration * speedFactor
            }
        }
        
        // Calculate total roud quality result
        let result = max(10.0 - ovrInstability, 0.0)
        return result
    }
    
    
    
}
