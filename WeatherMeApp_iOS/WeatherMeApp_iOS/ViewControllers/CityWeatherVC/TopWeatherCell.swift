//
//  TopWeatherCell.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 3/28/23.
//

import UIKit
import WeatherKit

protocol TopWeatherCellDelegate: AnyObject {
    func cancelAction ()
    func addNewCityToWeatherList()
}

class TopWeatherCell: UICollectionViewCell {
    
    var isTopButtonHidden: (cancel: Bool, add: Bool) = (cancel: true, add: true) {
        didSet {
            cancelButton.isHidden = isTopButtonHidden.cancel
            addButton.isHidden = isTopButtonHidden.add
            topConstraint.constant = isTopButtonHidden.cancel ? 0 : 64
        }
    }
    weak var delegate: TopWeatherCellDelegate?
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var lineImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.delegate?.cancelAction()
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        self.delegate?.addNewCityToWeatherList()
    }
    
    func cellConfigurate(weather: Weather, timezone: String, cityName: String) {
        lineImageView.layer.cornerRadius = 2
        
        dateLabel.text = Date.utcToLocal(date: weather.currentWeather.date, timezone: timezone, with: "h:mm a, EE, MMM d")
        cityNameLabel.text = cityName
        
        tempLabel.attributedText = String.tempFormattedString(value: weather.currentWeather.temperature.value, unit: weather.currentWeather.temperature.unit, bFontSize: 60, sFontSize: 25, weight: .semibold)
        
        if let alerts = weather.weatherAlerts {
            if let alertText = alerts.first?.summary {
                conditionLabel.text = "\u{26A0} " + alertText
            }
        } else {
            conditionLabel.text = weather.currentWeather.condition.description
        }
        
    }

}
