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
    
    func cellConfigurate (hWeather: HourWeather, timeZone: String) {
        tempLabel.text = hWeather.temperature.formatted()
        hourLabel.text = currentHourString(date: hWeather.date, timeZone: timeZone)
        weatherImageView.image = UIImage(systemName: hWeather.symbolName)
        
       // print("----  \(currentHourString(date: hWeather.date, timeZone: timeZone)) ----- TZ \(timeZone)")
        
    }
    
    func currentHourString(date: Date, timeZone: String) -> String {
        let zn = TimeZone(abbreviation: timeZone)!
        let targetDate = date.convertToTimeZone(initTimeZone: TimeZone.current, timeZone: zn)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH a"
        dateFormatter.timeZone = zn

        return dateFormatter.string(from: targetDate)
    }
}

extension Date {
    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
         let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
         return addingTimeInterval(delta)
    }
}
