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
    
    func cellConfigurate (dWeather: DayWeather) {
        weatherImageView.image = UIImage(systemName: dWeather.symbolName)
        nightTempLabel.text = dWeather.lowTemperature.formatted()
        dayTempLabel.text = dWeather.highTemperature.formatted()
        weekDayLabel.text = currentDayString(timeInterval: dWeather.date.timeIntervalSince1970)
        
        print("Date name \(currentDayString(timeInterval: dWeather.date.timeIntervalSince1970))")
    }
    
    func currentDayString(timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        dateFormatter.timeZone = TimeZone(identifier: "GMT+3")

        return dateFormatter.string(from: date)
    }
}
