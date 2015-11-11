//
//  ForecastDataProvider.swift
//  AnotherWeather
//
//  Created by L3o on 11/11/15.
//  Copyright © 2015 l3ostudio. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

class ForecastDataProvider {
    static let API_KEY = "36d84d71ae770b55240c755a9c11aba1"
    static let URL_BASE = "https://api.forecast.io/forecast/" + API_KEY + "/"
    
    var fetchTask: NSURLSessionDataTask? = nil
    var session: NSURLSession = NSURLSession.sharedSession()
    
    
    func constructQueryString(coodinate:CLLocationCoordinate2D) -> String {
        let queryString = ForecastDataProvider.URL_BASE + String(stringInterpolationSegment: coodinate.latitude) + "," + String(stringInterpolationSegment: coodinate.longitude)
        
        let encodedeURLString = queryString.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
        
        return encodedeURLString
    }
    
    func fetchForecastData(coodinate: CLLocationCoordinate2D,completion:(ForecastData->Void)) {
        
        let encodedeURLString = self.constructQueryString(coodinate)
        
        if fetchTask?.taskIdentifier > 0 && fetchTask?.state == .Running {
            fetchTask?.cancel()
        }
        
        //display loading state
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        //prepare to async call to forecast
        fetchTask = session.dataTaskWithURL(NSURL(string: encodedeURLString)!) {
            //block begin
            data,response, error in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            guard error == nil else {
                print(error)
                return
            }
            let forecastData = ForecastData(raw:data!)
            
            dispatch_async(dispatch_get_main_queue()) {
                completion(forecastData)
            }
            //block ends
        }
        fetchTask?.resume()
        
    }
    
    
}


