//
//  OrbsTests.swift
//  OrbsTests
//
//  Created by Alexander Bollbach on 7/28/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

import XCTest
import UIKit
@testable import Orbs


class OrbsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testOrbPositionFromCGPoint1() {
        
        let point = CGPoint(x: 10, y: 20)
        
        let size = CGSize(width: 100, height: 100)
        
        let resultantOrbPosition = point.orbPosition(inSize: size)
        
        let expectatedOrbPosition = OrbPosition(x: 0.1, y: 0.2)
        
        print(resultantOrbPosition)
        
        XCTAssert(resultantOrbPosition == expectatedOrbPosition)
        
    }
    
    func testOrbPositionFromCGPoint2() {
        
        let point = CGPoint(x: 15, y: 3)
        
        let size = CGSize(width: 200, height: 300)
        
        let resultantOrbPosition = point.orbPosition(inSize: size)
        
        let expectatedOrbPosition = OrbPosition(x: 0.075, y: 0.01)
        
        print(resultantOrbPosition)
        
        XCTAssert(resultantOrbPosition == expectatedOrbPosition)
        
    }
    
    func testCGPointFromOrbPosition1() {
        
        let initialOrbPosition = OrbPosition(x: 0.5, y: 0.5)
        
        let inSize = CGSize(width: 100, height: 100)
        
        let resultantCGPoint = CGPoint(with: initialOrbPosition, inSize: inSize)
        
        let expectedCGPoint = CGPoint(x: 50, y: 50)
        
        XCTAssert(resultantCGPoint == expectedCGPoint)
    }
    
    func testCGPointFromOrbPosition2() {
        
        let initialOrbPosition = OrbPosition(x: 0.01, y: 0.95)
        
        let inSize = CGSize(width: 200, height: 1000)
        
        let resultantCGPoint = CGPoint(with: initialOrbPosition, inSize: inSize)
        
        let expectedCGPoint = CGPoint(x: 2, y: 950)
        
        XCTAssert(resultantCGPoint == expectedCGPoint)
    }
    
}
