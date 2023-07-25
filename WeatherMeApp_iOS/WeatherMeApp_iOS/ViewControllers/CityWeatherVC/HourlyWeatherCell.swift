//
//  HourlyWeatherCell.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 3/28/23.
//

import UIKit
import WeatherKit

class HourlyWeatherCell: UICollectionViewCell {
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    func cellConfigurate (hWeather: HourWeather) {
        tempLabel.text = hWeather.temperature.formatted()
        hourLabel.text = currentHourString(timeInterval: hWeather.date.timeIntervalSince1970)
        weatherImageView.image = UIImage(systemName: hWeather.symbolName) 
        
        //hourLabel.text = hWeather.date.formatted(date: .omitted, time: .shortened)
        print("Date HOURLY \(hWeather.date.formatted(date: .omitted, time: .shortened))")
        print("----  \(currentHourString(timeInterval: hWeather.date.timeIntervalSince1970))")
        
    }
    
    func currentHourString(timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH a"
        dateFormatter.timeZone = TimeZone(identifier: "GMT+3")

        return dateFormatter.string(from: date)
    }
}
