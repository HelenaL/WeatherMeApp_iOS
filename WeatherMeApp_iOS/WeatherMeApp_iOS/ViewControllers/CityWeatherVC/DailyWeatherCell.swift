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
//        let formatter = MeasurementFormatter()
//                formatter.unitStyle = .medium
//                formatter.numberFormatter.maximumFractionDigits = 0
        nightTempLabel.text = dWeather.lowTemperature.formatted(.measurement(width: .narrow))
        dayTempLabel.text = dWeather.highTemperature.formatted(.measurement(width: .wide))
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
