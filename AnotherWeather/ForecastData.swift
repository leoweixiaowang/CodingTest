//
//  ForecastData.swift
//  AnotherWeather
//
//  Created by L3o on 11/11/15.
//  Copyright © 2015 l3ostudio. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

class ForecastData {
    let summary: String
    let icon: String
    let temperature: Double
    let apparentTemperature: Double
    let humidity: Double
    let windSpeed: Double
    let visibility: Double
    let pressure: Double
    
    init(raw: NSData){
        let json = JSON(data:raw)
        summary = json["currently"]["summary"].stringValue
        icon = json["currently"]["icon"].stringValue
        temperature = json["currently"]["temperature"].doubleValue
        apparentTemperature = json["currently"]["apparentTemperature"].doubleValue
        humidity = json["currently"]["humidity"].doubleValue
        windSpeed = json["currently"]["windSpeed"].doubleValue
        visibility = json["currently"]["visibility"].doubleValue
        pressure = json["currently"]["pressure"].doubleValue
    }
}

