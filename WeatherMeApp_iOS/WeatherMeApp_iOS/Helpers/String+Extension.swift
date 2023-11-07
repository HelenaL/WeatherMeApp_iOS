//
//  String+Extension.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 8/10/23.
//

import Foundation
import WeatherKit
import UIKit

extension String {
    
    /// To format placemark title.
    /// - Returns: Formatted string of shorten placemark title.
    
    func formattedPlacemarkTitle() -> String {
        return self.components(separatedBy: ",").first ?? self
    }
    
    /// To format string with temperature value when figures and unit symbol have different font size.
    /// - Parameter value: Numeric value of temperature.
    /// - Parameter unit: Unit for temperature.
    /// - Parameter bFontSize: Font size for temperature value.
    /// - Parameter sFontSize: Font size for.
    /// - Returns: Formatted string with temperature value ( figures and unit symbol have different font size).

    static public func temperatureFormattedString(value: Double, unit: UnitTemperature, bFontSize: Double, sFontSize: Double, weight: UIFont.Weight) -> NSAttributedString {
        let tempString: NSMutableAttributedString = NSMutableAttributedString()
        let tStr = String(format: "%.0f", value)
        let uStr: String  = unit.symbol
        
        let tAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: bFontSize, weight: weight)]
        let uAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: sFontSize, weight: weight)]
        tempString.append(NSAttributedString(string: tStr, attributes: tAttributes))
        tempString.append(NSAttributedString(string: uStr, attributes: uAttributes))

        return tempString
    }
    
}
