//
//  ReviewAlgorithmTest.swift
//  ReviewAlgorithmTest
//
//  Created by Rintaro Kawagishi on 29/03/2020.
//  Copyright © 2020 Rintaro Kawagishi. All rights reserved.
//

import XCTest

class ReviewAlgorithmTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func reviewed(ease: Int, actualWaitTime: Double) -> Double {
//        let actualWaitTime = Date().timeIntervalSince(self.lastChecked)
        let actualWaitDays = actualWaitTime / (60*60*24)
//        lastChecked = Date()
        
        var nextWaitDays: Double
        switch ease {
        case 1:
            nextWaitDays = 10 - 10 * exp(-actualWaitDays/10.0)
            break
        case 2:
            nextWaitDays = 30 - 28 * exp(-actualWaitDays/28.0)
            break
        case 3:
            nextWaitDays = actualWaitDays * (1.1 + 3.9 * exp(-actualWaitDays/9.0)) + 2
            break
        case 4:
            nextWaitDays = actualWaitDays * (1.5 + 8.5 * exp(-actualWaitDays/10.0)) + 2
            break
        default:
            fatalError("The ease is out of the valid range")
        }
        
//        let nextWaitTime = nextWaitDays * (60*60*24)
//        self.waitTime = nextWaitTime
//        XCTAssert(<#T##expression: Bool##Bool#>)
        return nextWaitDays
    }
    
    func testAlgorithm() throws {
        let first = reviewed(ease: 1, actualWaitTime: 7.0*60*60*24)
        XCTAssert(first > 4.9 && first < 5.2)
        
        let second = reviewed(ease: 1, actualWaitTime: 25*60*60*24)
        XCTAssert(second > 9.0 && second < 9.5)
        
        let third = reviewed(ease: 2, actualWaitTime: 7.0*60*60*24)
        XCTAssert(third > 8.0 && third < 8.5)
        
        let fourth = reviewed(ease: 2, actualWaitTime: 25*60*60*24)
        XCTAssert(fourth > 18 && fourth < 19)
        
        
        let fifth = reviewed(ease: 3, actualWaitTime: 7.0*60*60*24)
        XCTAssert(fifth > 22 && fifth < 22.5)
        
        let sixth = reviewed(ease: 3, actualWaitTime: 25*60*60*24)
        XCTAssert(sixth > 35 && sixth < 36)
        
        let seven = reviewed(ease: 4, actualWaitTime: 7.0*60*60*24)
        XCTAssert(seven > 41.5 && seven < 42.5)
        let eigth = reviewed(ease: 4, actualWaitTime: 25*60*60*24)
        XCTAssert(eigth > 56.5 && eigth < 57)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
