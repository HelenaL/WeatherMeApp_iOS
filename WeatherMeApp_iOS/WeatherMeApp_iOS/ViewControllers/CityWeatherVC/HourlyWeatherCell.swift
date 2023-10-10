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
        let convertedTemperature = UnitConverter.convertTemperature(temperature: hWeather.temperature)
        tempLabel.text = String(format: "%.0f", convertedTemperature.value) + "º"
        weatherImageView.image = UIImage(systemName: hWeather.symbolName)
        hourLabel.text = currentHourString(date: hWeather.date, timeZone: timeZone)
    }
    
    func currentHourString(date: Date, timeZone: String) -> String {
        let tZone = TimeZone(abbreviation: timeZone)!
        let targetDate = date.convertToTimeZone(initTimeZone: TimeZone.current, timeZone: tZone)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h a"
        dateFormatter.timeZone = tZone

        return dateFormatter.string(from: targetDate)
    }
}
