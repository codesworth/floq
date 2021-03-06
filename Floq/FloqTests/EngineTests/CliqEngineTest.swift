//
//  CliqEngineTest.swift
//  FloqTests
//
//  Created by Shadrach Mensah on 04/05/2019.
//  Copyright © 2019 Arun Nagarajan. All rights reserved.
//

import XCTest
@testable import Floq

class CliqEngineTest: XCTestCase {
    
    var engine:CliqEngine!

    override func setUp() {
        var engine = CliqEngine()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_getMyCliqsLimitTo20() {
        let myCliqs = engine
            //let expect = self.expectation(for: <#T##NSPredicate#>, evaluatedWith: <#T##Any?#>, handler: <#T##XCTNSPredicateExpectation.Handler?##XCTNSPredicateExpectation.Handler?##() -> Bool#>)
        
        engine.queryForMyCliqs()
        XCTWaiter.wait(for: [expect], timeout: 10)
        
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
