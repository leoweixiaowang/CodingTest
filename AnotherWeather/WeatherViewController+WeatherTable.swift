//
//  WeatherViewController+WeatherTable.swift
//  AnotherWeather
//
//  Created by L3o on 11/11/15.
//  Copyright © 2015 l3ostudio. All rights reserved.
//

import Foundation
import UIKit

extension WeatherViewController:UITableViewDelegate, UITableViewDataSource {
    
    func setupWeatherTable() {
        self.weatherTableView.delegate = self
        self.weatherTableView.dataSource = self
        self.weatherTableView.allowsSelection = false
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.weatherTableView.addSubview(self.refreshControl)
        
        self.refreshControl.beginRefreshing()
        self.startGettingLocation()
        self.weatherTableView.setContentOffset(CGPointMake(0,-self.refreshControl.frame.size.height), animated: true)
    }
    
    func refresh() {
        self.startGettingLocation()
    }
    
    func reloadData() {
        //reload Table Data
        self.weatherTableView.reloadData()
        
        self.weatherTableView.setContentOffset(CGPointMake(0,0), animated: true)
        self.refreshControl.endRefreshing()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let reuseID = "WeatherMainRowCellIdentifier"
            
            var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseID)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: reuseID)
            }
            cell!.textLabel?.text = "The Weather now is " + self.forecastData!.summary
            cell!.textLabel?.textAlignment = .Center
            cell!.textLabel?.backgroundColor = UIColor.clearColor()
            return cell!
        } else {
            let reuseID = "WeatherDetailRowCellIdentifier"
            
            var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseID)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: reuseID)
            }
            switch indexPath.row {
            case 1:
                cell!.textLabel?.text = "Temperature: " + String(stringInterpolationSegment: self.forecastData!.temperature)
            case 2:
                cell!.textLabel?.text = "Apparent Temperature:" + String(stringInterpolationSegment: self.forecastData!.apparentTemperature)
            case 3:
                cell!.textLabel?.text = "Wind Speed: " + String(stringInterpolationSegment: self.forecastData!.windSpeed)
            case 4:
                cell!.textLabel?.text = "Visibility: " + String(stringInterpolationSegment: self.forecastData!.visibility)
            default:
                cell!.textLabel?.text = ""
            }
            cell!.textLabel?.backgroundColor = UIColor.clearColor()
            return cell!
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.forecastData != nil {
            self.weatherTableView.separatorStyle = .SingleLine
            self.configureBackgroundView(self.forecastData!.icon)
            return 5
        } else {
            //display a message when table is empty
            let msgLabel = UILabel(frame: CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height))
            msgLabel.text = "Locating You and Loading Weather data..."
            msgLabel.textColor = UIColor.blackColor()
            msgLabel.numberOfLines = 0
            msgLabel.textAlignment = .Center
            msgLabel.sizeToFit()
            self.weatherTableView.backgroundView = msgLabel
            self.weatherTableView.separatorStyle = .None
            
        }
        return 0
    }
    
    func configureBackgroundView(icon:String) {
        var backgroundImgName:String! = nil
        switch icon {
            case "clear-day","clear-night":
                backgroundImgName = "clear"
            case "cloudy","partly-cloudy-day","partly-cloudy-night","fog":
                backgroundImgName = "cloudy"
            case "rain","hail":
                backgroundImgName = "rain"
            case "snow","sleet":
                backgroundImgName = "snow"
            case "wind":
                backgroundImgName = "wind"
            case "thunderstorm","tornado":
                backgroundImgName = "thunderstorm"
            default:
                backgroundImgName = "clear"
        }
        
        self.weatherTableView.backgroundColor = UIColor.clearColor()
        
        let tempImageView = UIImageView(image: UIImage(named: backgroundImgName))
        tempImageView.sizeToFit()
        let blurEffect = UIBlurEffect(style: .Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRectMake(0,0,UIScreen.mainScreen().bounds.width,UIScreen.mainScreen().bounds.height+20)
        tempImageView.addSubview(blurEffectView)
        
        self.weatherTableView.backgroundView = tempImageView
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return tableView.frame.size.height
        }
        return 44
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
}