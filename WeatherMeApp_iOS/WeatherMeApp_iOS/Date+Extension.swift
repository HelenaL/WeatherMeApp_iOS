//
//  DateFormatter.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 8/15/23.
//

import Foundation

extension Date {
    public static func utcToLocal(date: Date?, timezone: String, with format: String) -> String? {
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let ndate = date {
            dateFormatter.timeZone = TimeZone(abbreviation: timezone)
            dateFormatter.dateFormat = format//"h:mm a, EE, MMM d"//"h:mm a"
        
            return dateFormatter.string(from: ndate)
        }
        return nil
    }
    
}


