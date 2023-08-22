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
    ///TODO: gradient test
    //@IBOutlet weak var gradientView: WeatherGradientView!
    
    

    override func layoutSubviews() {
        super.layoutSubviews()
        mesh?.frame = self.bounds
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
        
        if let dayWeather = weather.dailyForecast.first {
            tempRangeLabel.text = "H:" + String(format: "%.0f", dayWeather.highTemperature.value) + "º L:" + String(format: "%.0f", dayWeather.lowTemperature.value) + "º"
        }
        
        feelsLikeLabel.text = "Feels like " + String(format: "%.0f", weather.currentWeather.apparentTemperature.value) + "º"
        
        if (mesh != nil) {
            return;
        }
        
        let meshView = MeshView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        
        mesh = meshView
        //view.addSubview(meshView)
        self.insertSubview(meshView, at: 0)
        
        let tangent: (u: Float, v: Float) = (0.5,0.5)
        meshView.create([
                        .init(point: (0, 0), location: (0, 0), color: UIColor(red: 1, green: 1, blue: 1, alpha: 1.000), tangent: tangent),
                        .init(point: (0, 1), location: (0, 1), color: UIColor(red: 1, green: 1, blue: 1, alpha: 1.000), tangent: tangent),
                        .init(point: (0, 2), location: (0, 2), color: UIColor(red: 1, green: 1, blue: 1, alpha: 1.000), tangent: tangent),
                        .init(point: (0, 3), location: (0, 3), color: UIColor(red: 1, green: 1, blue: 1, alpha: 1.000), tangent: tangent),

                            .init(point: (1, 0), location: (1.6, 0), color: UIColor(red: 1, green: 1, blue: 1, alpha: 1.000), tangent: tangent),
                        .init(point: (1, 1), location: (Float.random(in: 0.8...1.5), Float.random(in: 0.5...1.6)), color: UIColor(red: 0.541, green: 0.694, blue: 0.790, alpha: 1.000), tangent: tangent),
                        .init(point: (1, 2), location: (Float.random(in: 1.8...2.4), Float.random(in: 1.7...2)), color: UIColor(red: 0.541, green: 0.541, blue: 0.941, alpha: 1.000), tangent: tangent),
                        .init(point: (1, 3), location: (1.6, 3), color: UIColor(red: 1, green: 1, blue: 1, alpha: 1.000), tangent: tangent),
                        

                        
                        .init(point: (2, 0), location: (2.2, 0), color: UIColor(red: 1, green: 1, blue: 1, alpha: 1.000), tangent: tangent),
                        .init(point: (2, 1), location: (Float.random(in: 2.0...2.4), Float.random(in: 1.4...1.8)), color: UIColor(red: 0.933, green: 0.537, blue: 0.349, alpha: 1.000), tangent: tangent),
                        .init(point: (2, 2), location: (2.8, 2.5), color: UIColor(red: 0.406, green: 0.735, blue: 0.618, alpha: 1.000), tangent: tangent),
                        .init(point: (2, 3), location: (2.2, 3), color: UIColor(red: 1, green: 1, blue: 1, alpha: 1.000), tangent: tangent),
                        
                        .init(point: (3, 0), location: (3, 0), color: UIColor(red: 1, green: 1, blue: 1, alpha: 1.000), tangent: tangent),
                        .init(point: (3, 1), location: (3, 2), color: UIColor(red: 0.733, green: 0.637, blue: 0.349, alpha: 1.000), tangent: tangent),
                        .init(point: (3, 2), location: (3, 2.7), color: UIColor(red: 1, green: 1, blue: 1, alpha: 1.000), tangent: tangent),
                        .init(point: (3, 3), location: (3, 3), color: UIColor(red: 1, green: 1, blue: 1, alpha: 1.000), tangent: tangent),
                        
                    ], width: 4, height: 4)
       
    }

}
