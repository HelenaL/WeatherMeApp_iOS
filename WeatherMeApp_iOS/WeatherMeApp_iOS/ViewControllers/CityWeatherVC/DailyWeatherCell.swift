//
//  DailyWeatherCell.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 3/28/23.
//

import UIKit
import WeatherKit

class DailyWeatherCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var nightTempLabel: UILabel!
    @IBOutlet weak var dayTempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var lineImageView: UIView!
    
    // MARK: - Cell config
    
    func cellConfigurate(dayWeather: DayWeather, timeZone: String) {
        lineImageView.layer.cornerRadius = 1.3
        weatherImageView.image = UIImage(systemName: dayWeather.symbolName)
        let convertedHighTemperature = UnitConverter.convertTemperature(temperature: dayWeather.highTemperature)
        let convertedLowTemperature = UnitConverter.convertTemperature(temperature: dayWeather.lowTemperature)
        nightTempLabel.attributedText = String.temperatureFormattedString(value: convertedLowTemperature.value, unit: convertedLowTemperature.unit, bFontSize: 16, sFontSize: 10, weight: .light)
        dayTempLabel.attributedText = String.temperatureFormattedString(value: convertedHighTemperature.value, unit: convertedHighTemperature.unit, bFontSize: 22, sFontSize: 16, weight: .light)
        weekDayLabel.text = dayWeather.date.currentDayString(timeZone: timeZone)
    }    
}
