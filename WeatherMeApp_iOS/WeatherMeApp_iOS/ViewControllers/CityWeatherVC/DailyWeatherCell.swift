//
//  DailyWeatherCell.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 3/28/23.
//

import UIKit
import WeatherKit

class DailyWeatherCell: UICollectionViewCell {
    
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var nightTempLabel: UILabel!
    @IBOutlet weak var dayTempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    func cellConfigurate (dWeather: DayWeather, timeZone: String) {
        weatherImageView.image = UIImage(systemName: dWeather.symbolName)
        nightTempLabel.attributedText = String.tempFormattedString(value: dWeather.lowTemperature.value, unit: dWeather.lowTemperature.unit, bFontSize: 16, sFontSize: 10, weight: .light)
        dayTempLabel.attributedText = String.tempFormattedString(value:  dWeather.highTemperature.value, unit:  dWeather.highTemperature.unit, bFontSize: 22, sFontSize: 16, weight: .light)
        weekDayLabel.text = currentDayString(date: dWeather.date, timeZone: timeZone)
        
        //print("Date name \(currentDayString(timeInterval: dWeather.date.timeIntervalSince1970, timeZone: timeZone))")
    }
    
    func currentDayString(date: Date, timeZone: String) -> String {
        let zn = TimeZone(abbreviation: timeZone)!
        let targetDate = date.convertToTimeZone(initTimeZone: TimeZone.current, timeZone: zn)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        dateFormatter.timeZone = zn

        return dateFormatter.string(from: targetDate)
    }
    
}
