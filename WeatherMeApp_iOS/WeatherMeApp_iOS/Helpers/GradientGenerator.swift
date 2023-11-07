//
//  GradientGenerator.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 10/29/23.
//

import Foundation
import MeshKit
import UIKit

class GradientGenerator {
    
    /// Generate mesh gradient view with different colors based on temperature value.
    /// - Parameter temperatureValue: A numeric temperature value.
    /// - Parameter temperatureUnit: Temperature Unit.
    /// - Parameter size: Size  of view with gradient.
    /// - Returns: Gradient view.
    
    func generateMeshGradientView(for temperatureValue: Double, temperatureUnit: UnitTemperature, size: CGSize) -> MeshView {
        let temp = convertTempUnitToCelsius(value: temperatureValue, temperatureUnit: temperatureUnit)
        let meshView = MeshView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                
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
        
        return meshView
    }
    
    /// Convert temperature value to Celsius .
    /// - Parameter value: A numeric temperature value.
    /// - Parameter temperatureUnit: Temperature Unit.
    /// - Returns: A converted measurement.
    
    private func convertTempUnitToCelsius(value: Double, temperatureUnit: UnitTemperature) -> Double {
        switch temperatureUnit {
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
