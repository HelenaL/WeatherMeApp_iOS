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
    static public func tempFormattedString(value: Double, unit: UnitTemperature, bFontSize: Double, sFontSize: Double) -> NSMutableAttributedString {
        var tempString: NSMutableAttributedString = NSMutableAttributedString()
        let tStr = String(format: "%.0f", value)
        let uStr: String  = unit.symbol
        
        let tAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: bFontSize)]
        let uAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: sFontSize)]
        tempString.append(NSAttributedString(string: tStr, attributes: tAttributes))
        tempString.append(NSAttributedString(string: uStr, attributes: uAttributes))
        

        return tempString
    }
    
//    static public func tempFormattedString(value: Double, unit: UnitTemperature) -> NSAttributedString {
//        var tStr: AttributedString = AttributedString(String(format: "%.0f", value))
//        tStr.font = .systemFont(ofSize: 36)
//
//        var uStr: AttributedString = AttributedString("unit")
//        uStr.font = .systemFont(ofSize: 26)
//        return tStr + uStr
//    }
}
