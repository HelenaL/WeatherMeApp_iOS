//
//  CitiesListTableViewCell.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 8/31/23.
//

import Foundation
import WeatherKit
import UIKit

class CitiesListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempValueLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var tempRangeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var lineImageView: UIView!
    
    func fillWeatherCell(with city: City, and weather: Weather) {
        lineImageView.layer.cornerRadius = 1.3
        cityNameLabel.text = city.name
        
        let convertedCurrentTemperature = UnitConverter.convertTemperature(temperature: weather.currentWeather.temperature)
        tempValueLabel.attributedText = String.tempFormattedString(value: convertedCurrentTemperature.value,
                                                                   unit: convertedCurrentTemperature.unit,
                                                                   bFontSize: 36,
                                                                   sFontSize: 26,
                                                                   weight: .semibold)

        if let alerts = weather.weatherAlerts, !alerts.isEmpty {
            if let alertText = alerts.first?.summary {
                conditionLabel.text = "\u{26A0} " + alertText
            }
        } else {
            conditionLabel.text = weather.currentWeather.condition.description
        }

        if let tZone = city.timeZone {
            timeLabel.text = Date.utcToLocal(date: weather.currentWeather.date, timezone: tZone, with: "h:mm a")
        }
        
        if let dayWeather = weather.dailyForecast.first {
            let convertedHighTemperature = UnitConverter.convertTemperature(temperature: dayWeather.highTemperature)
            let convertedLowTemperature = UnitConverter.convertTemperature(temperature: dayWeather.lowTemperature)
            
            tempRangeLabel.text = "H:" + String(format: "%.0f", convertedHighTemperature.value) + "º L:" + String(format: "%.0f", convertedLowTemperature.value) + "º"
        }

    }
    
}
