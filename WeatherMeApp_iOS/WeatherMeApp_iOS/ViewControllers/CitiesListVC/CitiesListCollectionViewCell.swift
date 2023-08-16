//
//  CitiesListCollectionViewCell.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 4/12/22.
//

import UIKit
import WeatherKit

class CitiesListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempValueLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var tempRangeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func fillWeatherCell(with city:City, and weather: Weather) {
        cityNameLabel.text = city.name
        
        tempValueLabel.attributedText = String.tempFormattedString(value: weather.currentWeather.temperature.value, unit: weather.currentWeather.temperature.unit, bFontSize: 36, sFontSize: 26, weight: .semibold)
        
        if let alerts = weather.weatherAlerts {
            if let alertText = alerts.first?.summary {
                conditionLabel.text = "\u{26A0} " + alertText
            }
        } else {
            conditionLabel.text = weather.currentWeather.condition.description
        }

        if let tz = city.timeZone {
            timeLabel.text = Date.utcToLocal(date: weather.currentWeather.date, timezone: tz, with: "h:mm a")
        }
        
        if let dayWeather = weather.dailyForecast.first {
            tempRangeLabel.text = "H:" + String(format: "%.0f", dayWeather.highTemperature.value) + "º L:" + String(format: "%.0f", dayWeather.lowTemperature.value) + "º"
        }
//        tempRangeLabel.text = "H: " + (weather.dailyForecast.forecast.first?.highTemperature.formatted ?? "--") + "L: " + (weather.dailyForecast.forecast.first?.lowTemperature.formatted() ?? "--")
       // String(format: "%.0f", dayWeather.highTemperature.)
    }
}
