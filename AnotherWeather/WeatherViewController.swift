//
//  WeatherViewController.swift
//  AnotherWeather
//
//  Created by L3o on 11/11/15.
//  Copyright © 2015 l3ostudio. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var backgroundImgView: UIImageView!
    @IBOutlet weak var weatherTableView:UITableView!
    
    let dataProvider = ForecastDataProvider()
    let locationManager = CLLocationManager()
    var userLocation : CLLocationCoordinate2D? = nil
    var forecastData: ForecastData? = nil
    var refreshControl:UIRefreshControl! = nil
    var locationAuthStatus:CLAuthorizationStatus? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLocationManager()
        self.setupWeatherTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchForecastData(coordinate: CLLocationCoordinate2D) {
        
        self.dataProvider.fetchForecastData(coordinate) {
            //completion block
            forecastData in
            
            self.forecastData = forecastData
            self.reloadData()
            //end block
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}

