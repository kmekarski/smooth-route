//
//  SmoothRoute_Tests.swift
//  SmoothRoute_Tests
//
//  Created by Klaudiusz Mękarski on 28/12/2023.
//

import XCTest
@testable import SmoothRoute


final class SmoothRoute_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_ResultCalculation_ShouldReturnZeroForEmptyHistory() throws {
        // Arrange
        let reportsManager = ReportsManager()
        let verticalAccelerationHistory: [Double] = []
        let speedHistory: [Double] = []
        let speedSensitivity = 1
        let instabilityThreshold = 0
        let instabilityImpact = 1
        
        // Act
        let result = reportsManager.getResult(
            verticalAccelerationHistory,
            speedHistory,
            speedSensitivity,
            instabilityThreshold,
            instabilityImpact)
        
        // Assert
        XCTAssertEqual(result, 0, "The result should be 0 for empty history")
    }
    
    func test_ResultCalculation_ShouldReturnZeroForMismatchedHistorySizes() throws {
        // Arrange
        let reportsManager = ReportsManager()
        let verticalAccelerationHistory: [Double] = [0, 0.2, 0.1]
        let speedHistory: [Double] = [10, 20]
        let speedSensitivity = 1
        let instabilityThreshold = 0
        let instabilityImpact = 1
        
        // Act
        let result = reportsManager.getResult(
            verticalAccelerationHistory,
            speedHistory,
            speedSensitivity,
            instabilityThreshold,
            instabilityImpact)
        
        // Assert
        XCTAssertEqual(result, 0, "The result should be 0 for mismatched history sizes")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
