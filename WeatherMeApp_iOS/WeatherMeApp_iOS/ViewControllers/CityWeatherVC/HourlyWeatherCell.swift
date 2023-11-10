//
//  HourlyWeatherCell.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 3/28/23.
//

import UIKit
import WeatherKit

class HourlyWeatherCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    // MARK: - Cell config
    
    /// Fill a cell with the weather forecast that should be displayed.
    /// - Parameter hWeather: Hourly weather forecast.
    /// - Parameter timeZone: Time zone of a city.
    
    func cellConfigurate(hWeather: HourWeather, timeZone: String) {
        let convertedTemperature = UnitConverter.convertTemperature(temperature: hWeather.temperature)
        tempLabel.text = String(format: "%.0f", convertedTemperature.value) + "º"
        weatherImageView.image = UIImage(systemName: hWeather.symbolName)
        hourLabel.text = hWeather.date.currentHourString(timeZone: timeZone)
    }
}
