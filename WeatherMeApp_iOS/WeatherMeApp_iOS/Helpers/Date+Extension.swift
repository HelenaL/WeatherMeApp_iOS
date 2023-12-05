//
//  DateFormatter.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 8/15/23.
//

import Foundation

extension Date {
    
    /// To format date of forecast.
    /// - Parameter timeZone: Time zone for current location.
    /// - Parameter format: The date format string used by the receiver.
    /// - Returns: A string representation of a specified date.
    
    func utcToLocal(timeZone: String, with format: String) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeZone = TimeZone(abbreviation: timeZone)
        dateFormatter.dateFormat = format
    
        return dateFormatter.string(from: self)
    }
    
    /// To format date for daily forecast with format  "EE" (ex. Mon, Tue, ets.).
    /// - Parameter timeZone: Time zone for current location.
    /// - Returns: A string representation of a specified date.
    
    func currentDayString(timeZone: String) -> String {
        let tZone = TimeZone(abbreviation: timeZone)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        dateFormatter.timeZone = tZone

        return dateFormatter.string(from: self)
    }
    
    /// To format date for hourly forecast with format  "h a" (ex. 6 PM, 2 AM, ets.).
    /// - Parameter timeZone: Time zone for current location.
    /// - Returns: A string representation of a specified date.

    func currentHourString(timeZone: String) -> String {
        let tZone = TimeZone(abbreviation: timeZone)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h a"
        dateFormatter.timeZone = tZone

        return dateFormatter.string(from: self)
    }
    
    /// To format local time.
    /// - Parameter format: The date format string used by the receiver.
    /// - Returns: A string representation of a specified date.
   
    func formatLocalTime(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
}
