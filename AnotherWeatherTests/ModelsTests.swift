//
//  ModelsTests.swift
//  AnotherWeather
//
//  Created by L3o on 11/11/15.
//  Copyright © 2015 l3ostudio. All rights reserved.
//

import XCTest
import CoreLocation
@testable import AnotherWeather

class ModelsTests: XCTestCase {

    var jsonString:String? = nil
    var jsonDic:[String:AnyObject]? = nil
    var location:CLLocationCoordinate2D? = nil
    override func setUp() {
        super.setUp()
        jsonString = "{\"latitude\":37.8267,\"longitude\":-122.423,\"timezone\":\"America/Los_Angeles\",\"offset\":-8,\"currently\":{\"time\":1447233997,\"summary\":\"Clear\",\"icon\":\"clear-night\",\"nearestStormDistance\":122,\"nearestStormBearing\":347,\"precipIntensity\":0,\"precipProbability\":0,\"temperature\":48.06,\"apparentTemperature\":48.06,\"dewPoint\":43.86,\"humidity\":0.85,\"windSpeed\":2.34,\"windBearing\":325,\"visibility\":5.48,\"cloudCover\":0,\"pressure\":1027.95,\"ozone\":296.16}}"
        location = CLLocationCoordinate2DMake(37.8267,-122.423)
        jsonDic = ["latitude":37.8267,"longitude":-122.423,"timezone":"America/Los_Angeles","offset":-8,"currently":["time":1447233997,"summary":"Clear","icon":"clear-night","nearestStormDistance":122,"nearestStormBearing":347,"precipIntensity":0,"precipProbability":0,"temperature":48.06,"apparentTemperature":48.06,"dewPoint":43.86,"humidity":0.85,"windSpeed":2.34,"windBearing":325,"visibility":5.48,"cloudCover":0,"pressure":1027.95,"ozone":296.16]];
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDataFetch() {
        let dataProvider = ForecastDataProvider()
        
        let expectation = expectationWithDescription("Call to Forecast")
        dataProvider.fetchForecastData(self.location!) {
            forecastData in
            
            XCTAssertNotNil(forecastData.temperature)
            XCTAssertNotNil(forecastData.apparentTemperature)
            XCTAssertNotNil(forecastData.summary)
            XCTAssertNotNil(forecastData.icon)
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10) {
            error in
            
            if let error = error {
                print("Error:\(error.localizedDescription)")
            }
        }
    }
    
    func testForecastData() {
        let raw = jsonString!.dataUsingEncoding(NSUTF8StringEncoding)
        let data = ForecastData(raw:raw!)
        
        XCTAssertEqual(data.summary,"Clear")
        XCTAssertEqual(data.icon,"clear-night")
        XCTAssertEqual(data.temperature, 48.06)
        XCTAssertEqual(data.apparentTemperature, 48.06)
    }
    
    func testURLConstructions() {
        let dataProvider = ForecastDataProvider()
        let url = dataProvider.constructQueryString(self.location!)
        XCTAssertEqual(url, "https://api.forecast.io/forecast/36d84d71ae770b55240c755a9c11aba1/37.8267,-122.423")
    }
    
    class MockSession:NSURLSession {
        var completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?
        
        static var mockResponse: (data: NSData?, urlResponse: NSURLResponse?, error: NSError?) = (data: nil, urlResponse: nil, error: nil)
        
        override class func sharedSession() -> NSURLSession {
            return MockSession()
        }
        
        override func dataTaskWithURL(url: NSURL, completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?) -> NSURLSessionDataTask {
            self.completionHandler = completionHandler
            return MockTask(response: MockSession.mockResponse, completionHandler: completionHandler)
        }
        
        class MockTask: NSURLSessionDataTask {
            typealias Response = (data: NSData?, urlResponse: NSURLResponse?, error: NSError?)
            var mockResponse: Response
            let completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?
            
            init(response: Response, completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?) {
                self.mockResponse = response
                self.completionHandler = completionHandler
            }
            override func resume() {
                completionHandler!(mockResponse.data, mockResponse.urlResponse, mockResponse.error)
            }
        }
    }
    
    func testDataFetchMock() {
        
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(jsonDic!, options: .PrettyPrinted)
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "https://api.forecast.io/forecast/36d84d71ae770b55240c755a9c11aba1/37.8267,-122.423")!, statusCode: 200, HTTPVersion: nil, headerFields: nil)
        
        MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
        let dataProvider = ForecastDataProvider()
            
        dataProvider.session = MockSession.sharedSession()
        let expectation = expectationWithDescription("Call to Mock")
        dataProvider.fetchForecastData(self.location!) {
            data in
            
            XCTAssertEqual(data.summary,"Clear")
            XCTAssertEqual(data.icon,"clear-night")
            XCTAssertEqual(data.temperature, 48.06)
            XCTAssertEqual(data.apparentTemperature, 48.06)
            
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(10) {
            error in
            
            if let error = error {
                print("Error:\(error.localizedDescription)")
            }
        }
        
    }

}
