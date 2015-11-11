//
//  AnotherWeatherTests.swift
//  AnotherWeatherTests
//
//  Created by L3o on 11/11/15.
//  Copyright © 2015 l3ostudio. All rights reserved.
//

import XCTest
@testable import AnotherWeather

class AnotherWeatherTests: XCTestCase {
    var vc : WeatherViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        vc = storyboard.instantiateInitialViewController() as! WeatherViewController
        vc.loadView()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUI() {
        //XCTAssertTrue(true, "Passed")
    }
    
}
