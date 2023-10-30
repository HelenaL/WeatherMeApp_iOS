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
    
    func formattedPlacemarkTitle() -> String {
        return self.components(separatedBy: ",").first ?? self
    }
    
    // create string with temperature: large figures and small units
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
