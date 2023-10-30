//
//  TopWeatherCell.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 3/28/23.
//

import UIKit
import WeatherKit
import MeshKit

protocol TopWeatherCellDelegate: AnyObject {
    func cancelAction ()
    func addNewCityToWeatherList()
}

class TopWeatherCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var isTopButtonHidden: (cancel: Bool, add: Bool) = (cancel: true, add: true) {
        didSet {
            cancelButton.isHidden = isTopButtonHidden.cancel
            addButton.isHidden = isTopButtonHidden.add
            topConstraint.constant = isTopButtonHidden.cancel ? 0 : 64
        }
    }
    
    weak var delegate: TopWeatherCellDelegate?
    var mesh: MeshView?
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var tempRangeLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var lineImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    // MARK: - Button actions
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.delegate?.cancelAction()
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        self.delegate?.addNewCityToWeatherList()
    }

    // MARK: - Cell config
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mesh?.frame = self.bounds
    }
    
    func cellConfigurate(weather: Weather, timezone: String, cityName: String) {
        lineImageView.layer.cornerRadius = 2
        
        dateLabel.text = weather.currentWeather.date.utcToLocal(timezone: timezone, with: "h:mm a, EE, MMM d")
        cityNameLabel.text = cityName
        
        let convertedCurrentTemperature = UnitConverter.convertTemperature(temperature: weather.currentWeather.temperature)
        tempLabel.attributedText = String.temperatureFormattedString(value: convertedCurrentTemperature.value,
                                                              unit: convertedCurrentTemperature.unit,
                                                              bFontSize: 60,
                                                              sFontSize: 25,
                                                              weight: .semibold)
        
        if let alerts = weather.weatherAlerts, !alerts.isEmpty {
            if let alertText = alerts.first?.summary {
                conditionLabel.text = "\u{26A0} " + alertText
            }
        } else {
            conditionLabel.text = weather.currentWeather.condition.description
        }
        
        if let dayWeather = weather.dailyForecast.first {
            let convertedHighTemperature = UnitConverter.convertTemperature(temperature: dayWeather.highTemperature)
            let convertedLowTemperature = UnitConverter.convertTemperature(temperature: dayWeather.lowTemperature)
            
            tempRangeLabel.text = "H:" + String(format: "%.0f", convertedHighTemperature.value) + "º L:" + String(format: "%.0f", convertedLowTemperature.value) + "º"
        }
        
        let convertedFeelsLikeTemperature = UnitConverter.convertTemperature(temperature: weather.currentWeather.apparentTemperature)
        feelsLikeLabel.text = "Feels like " + String(format: "%.0f", convertedFeelsLikeTemperature.value) + "º"
        
        // generate mesh gradient only when mesh view doesn't exist
        guard mesh == nil else { return }
        
        mesh = GradientGenerator().generateGradientViewForTemp(value: weather.currentWeather.temperature.value, unit: weather.currentWeather.temperature.unit, size: self.bounds.size)
        self.insertSubview(mesh!, at: 0)
        
    }

}
