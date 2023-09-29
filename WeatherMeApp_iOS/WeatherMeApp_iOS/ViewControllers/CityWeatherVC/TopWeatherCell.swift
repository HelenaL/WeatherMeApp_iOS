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
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.delegate?.cancelAction()
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        self.delegate?.addNewCityToWeatherList()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        mesh?.frame = self.bounds
    }
    
    func cellConfigurate(weather: Weather, timezone: String, cityName: String) {
        lineImageView.layer.cornerRadius = 2
        
        dateLabel.text = Date.utcToLocal(date: weather.currentWeather.date, timezone: timezone, with: "h:mm a, EE, MMM d")
        cityNameLabel.text = cityName
        
        tempLabel.attributedText = String.tempFormattedString(value: weather.currentWeather.temperature.value, 
                                                              unit: weather.currentWeather.temperature.unit,
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
            tempRangeLabel.text = "H:" + String(format: "%.0f", dayWeather.highTemperature.value) + "º L:" + String(format: "%.0f", dayWeather.lowTemperature.value) + "º"
        }
        
        feelsLikeLabel.text = "Feels like " + String(format: "%.0f", weather.currentWeather.apparentTemperature.value) + "º"
        
        addGradientViewForTemp(value: weather.currentWeather.temperature.value, unit: weather.currentWeather.temperature.unit)
    }
    
    func addGradientViewForTemp(value: Double, unit: UnitTemperature) {
        guard mesh == nil else { return }

        let temp = convertTempUnitToCelsius(value: value, unit: unit)
        let meshView = MeshView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        
        mesh = meshView
        self.insertSubview(meshView, at: 0)
        
        var color11: UIColor!
        var color12: UIColor!
        var color21: UIColor!
        var color22: UIColor!
        var color31: UIColor!
        
        switch temp {
        case ..<5:
            // cold weather gradient colors
            color11 = UIColor(red: (CGFloat(Float.random(in: 120...220))/255.0), green: (CGFloat(Float.random(in: 100...200))/255.0), blue: (CGFloat(Float.random(in: 180...250))/255.0), alpha: 1.000)
            color12 = UIColor(red: (CGFloat(Float.random(in: 30...110))/255.0), green: (CGFloat(Float.random(in: 170...250))/255.0), blue: (CGFloat(Float.random(in: 150...250))/255.0), alpha: 1.000)
            color21 = UIColor(red: (CGFloat(Float.random(in: 0...50))/255.0), green: (CGFloat(Float.random(in: 150...180))/255.0), blue: (CGFloat(Float.random(in: 200...250))/255.0), alpha: 1.000)
            color22 = UIColor(red: (CGFloat(Float.random(in: 0...110))/255.0), green: (CGFloat(Float.random(in: 100...200))/255.0), blue: (CGFloat(Float.random(in: 120...180))/255.0), alpha: 1.000)
            color31 = UIColor(red: (CGFloat(Float.random(in: 100...180))/255.0), green: (CGFloat(Float.random(in: 80...150))/255.0), blue: (CGFloat(Float.random(in: 200...250))/255.0), alpha: 1.000)
        case 5..<18:
            // mid weather gradient colors
            color11 = UIColor(red: (CGFloat(Float.random(in: 0...50))/255.0), green: (CGFloat(Float.random(in: 150...180))/255.0), blue: (CGFloat(Float.random(in: 200...250))/255.0), alpha: 1.000)
            color12 = UIColor(red: (CGFloat(Float.random(in: 120...180))/255.0), green: (CGFloat(Float.random(in: 210...255))/255.0), blue: (CGFloat(Float.random(in: 0...70))/255.0), alpha: 1.000)
            color21 = UIColor(red: (CGFloat(Float.random(in: 0...70))/255.0), green: (CGFloat(Float.random(in: 170...220))/255.0), blue: (CGFloat(Float.random(in: 120...180))/255.0), alpha: 1.000)
            color22 = UIColor(red: (CGFloat(Float.random(in: 30...110))/255.0), green: (CGFloat(Float.random(in: 170...250))/255.0), blue: (CGFloat(Float.random(in: 150...250))/255.0), alpha: 1.000)
            color31 = UIColor(red: (CGFloat(Float.random(in: 160...200))/255.0), green: (CGFloat(Float.random(in: 220...255))/255.0), blue: (CGFloat(Float.random(in: 100...150))/255.0), alpha: 1.000)
        case 18..<28:
            // warm weather gradient colors
            color11 = UIColor(red: (CGFloat(Float.random(in: 160...200))/255.0), green: (CGFloat(Float.random(in: 220...255))/255.0), blue: (CGFloat(Float.random(in: 100...150))/255.0), alpha: 1.000)
            color12 = UIColor(red: (CGFloat(Float.random(in: 230...255))/255.0), green: (CGFloat(Float.random(in: 230...255))/255.0), blue: (CGFloat(Float.random(in: 0...120))/255.0), alpha: 1.000)
            color21 = UIColor(red: (CGFloat(Float.random(in: 230...250))/255.0), green: (CGFloat(Float.random(in: 130...200))/255.0), blue: (CGFloat(Float.random(in: 0...80))/255.0), alpha: 1.000)
            color22 = UIColor(red: (CGFloat(Float.random(in: 200...250))/255.0), green: (CGFloat(Float.random(in: 80...150))/255.0), blue: (CGFloat(Float.random(in: 0...50))/255.0), alpha: 1.000)
            color31 = UIColor(red: (CGFloat(Float.random(in: 230...250))/255.0), green: (CGFloat(Float.random(in: 130...200))/255.0), blue: (CGFloat(Float.random(in: 0...80))/255.0), alpha: 1.000)
        case 28...:
            // hot weather gradient colors
            color11 = UIColor(red: (CGFloat(Float.random(in: 180...230))/255.0), green: (CGFloat(Float.random(in: 120...150))/255.0), blue: (CGFloat(Float.random(in: 0...50))/255.0), alpha: 1.000)
            color12 = UIColor(red: (CGFloat(Float.random(in: 220...255))/255.0), green: (CGFloat(Float.random(in: 0...50))/255.0), blue: (CGFloat(Float.random(in: 0...70))/255.0), alpha: 1.000)
            color21 = UIColor(red: (CGFloat(Float.random(in: 200...250))/255.0), green: (CGFloat(Float.random(in: 30...120))/255.0), blue: (CGFloat(Float.random(in: 100...180))/255.0), alpha: 1.000)
            color22 = UIColor(red: (CGFloat(Float.random(in: 200...250))/255.0), green: (CGFloat(Float.random(in: 80...150))/255.0), blue: (CGFloat(Float.random(in: 0...50))/255.0), alpha: 1.000)
            color31 = UIColor(red: (CGFloat(Float.random(in: 190...255))/255.0), green: (CGFloat(Float.random(in: 0...50))/255.0), blue: (CGFloat(Float.random(in: 100...150))/255.0), alpha: 1.000)
        default:
            color11 = UIColor(red: (CGFloat(Float.random(in: 180...230))/255.0), green: (CGFloat(Float.random(in: 120...150))/255.0), blue: (CGFloat(Float.random(in: 0...50))/255.0), alpha: 1.000)
            color12 = UIColor(red: (CGFloat(Float.random(in: 200...250))/255.0), green: (CGFloat(Float.random(in: 80...150))/255.0), blue: (CGFloat(Float.random(in: 0...50))/255.0), alpha: 1.000)
            color21 = UIColor(red: (CGFloat(Float.random(in: 200...250))/255.0), green: (CGFloat(Float.random(in: 30...120))/255.0), blue: (CGFloat(Float.random(in: 100...180))/255.0), alpha: 1.000)
            color22 = UIColor(red: (CGFloat(Float.random(in: 120...180))/255.0), green: (CGFloat(Float.random(in: 210...255))/255.0), blue: (CGFloat(Float.random(in: 0...70))/255.0), alpha: 1.000)
            color31 = UIColor(red: (CGFloat(Float.random(in: 190...255))/255.0), green: (CGFloat(Float.random(in: 0...50))/255.0), blue: (CGFloat(Float.random(in: 100...150))/255.0), alpha: 1.000)
        }
        
        let tangent: (u: Float, v: Float) = (0.5, 0.5)
        meshView.create([
                        .init(point: (0, 0), location: (0, 0), color: UIColor(red: 1, green: 1, blue: 1, alpha: 1.000), tangent: tangent),
                        .init(point: (0, 1), location: (0, 1), color: UIColor(red: 1, green: 1, blue: 1, alpha: 1.000), tangent: tangent),
                        .init(point: (0, 2), location: (0, 2), color: UIColor(red: 1, green: 1, blue: 1, alpha: 1.000), tangent: tangent),
                        .init(point: (0, 3), location: (0, 3), color: UIColor(red: 1, green: 1, blue: 1, alpha: 1.000), tangent: tangent),

                            .init(point: (1, 0), location: (1.6, 0), color: UIColor(red: 1, green: 1, blue: 1, alpha: 1.000), tangent: tangent),
                        .init(point: (1, 1), location: (Float.random(in: 0.8...1.5), Float.random(in: 0.5...1.6)), color: color11, tangent: tangent),
                        .init(point: (1, 2), location: (Float.random(in: 1.8...2.4), Float.random(in: 1.7...2)), color: color12, tangent: tangent),
                        .init(point: (1, 3), location: (1.6, 3), color: UIColor(red: 1, green: 1, blue: 1, alpha: 1.000), tangent: tangent),
                        
                        .init(point: (2, 0), location: (2.2, 0), color: UIColor(red: 1, green: 1, blue: 1, alpha: 1.000), tangent: tangent),
                        .init(point: (2, 1), location: (Float.random(in: 2.0...2.4), Float.random(in: 1.4...1.8)), color: color21, tangent: tangent),
                        .init(point: (2, 2), location: (2.8, 2.5), color: color22, tangent: tangent),
                        .init(point: (2, 3), location: (2.2, 3), color: UIColor(red: 1, green: 1, blue: 1, alpha: 1.000), tangent: tangent),
                        
                        .init(point: (3, 0), location: (3, 0), color: UIColor(red: 1, green: 1, blue: 1, alpha: 1.000), tangent: tangent),
                        .init(point: (3, 1), location: (3, 2), color: color31, tangent: tangent),
                        .init(point: (3, 2), location: (3, 2.7), color: UIColor(red: 1, green: 1, blue: 1, alpha: 1.000), tangent: tangent),
                        .init(point: (3, 3), location: (3, 3), color: UIColor(red: 1, green: 1, blue: 1, alpha: 1.000), tangent: tangent)
                        
                    ], width: 4, height: 4)
        
    }
    
    func convertTempUnitToCelsius(value: Double, unit: UnitTemperature) -> Double {
        switch unit {
        case .celsius:
            return value
        case .fahrenheit:
            return (value - 32.0) * 5.0 / 9.0
        case .kelvin:
            return value - 273.15
        default:
            return value
        }
    }

}
