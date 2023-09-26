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
        tempLabel.text = String(format: "%.0f", hWeather.temperature.value) + "º"
        weatherImageView.image = UIImage(systemName: hWeather.symbolName)
        hourLabel.text = currentHourString(date: hWeather.date, timeZone: timeZone)
    }
    
    func currentHourString(date: Date, timeZone: String) -> String {
        let zn = TimeZone(abbreviation: timeZone)!
        let targetDate = date.convertToTimeZone(initTimeZone: TimeZone.current, timeZone: zn)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h a"
        dateFormatter.timeZone = zn

        return dateFormatter.string(from: targetDate)
    }
}
