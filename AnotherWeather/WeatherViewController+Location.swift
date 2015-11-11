//
//  WeatherViewController+Location.swift
//  AnotherWeather
//
//  Created by L3o on 11/11/15.
//  Copyright © 2015 l3ostudio. All rights reserved.
//

import Foundation
import CoreLocation


extension WeatherViewController: CLLocationManagerDelegate {
    

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.first {
            
            manager.stopUpdatingLocation()
            userLocation = location.coordinate
            
            //fetch forecast whether when location is known
            self.fetchForecastData(userLocation!)
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    
        self.locationAuthStatus = status
        if status != .AuthorizedAlways && status != .AuthorizedWhenInUse {
            manager.stopUpdatingLocation()
        }
        
    }
    
    func startGettingLocation() {
            self.locationManager.startUpdatingLocation()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func stopLocationManager() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
}