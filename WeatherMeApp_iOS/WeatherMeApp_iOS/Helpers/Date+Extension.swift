//
//  DateFormatter.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 8/15/23.
//

import Foundation

extension Date {
    func utcToLocal(timezone: String, with format: String) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeZone = TimeZone(abbreviation: timezone)
        dateFormatter.dateFormat = format
    
        return dateFormatter.string(from: self)
    }
    
    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
         let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
         return addingTimeInterval(delta)
    }
    
    func currentDayString(timeZone: String) -> String {
        let tZone = TimeZone(abbreviation: timeZone)!
        let targetDate = self.convertToTimeZone(initTimeZone: TimeZone.current, timeZone: tZone)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        dateFormatter.timeZone = tZone

        return dateFormatter.string(from: targetDate)
    }
    
    func currentHourString(timeZone: String) -> String {
        let tZone = TimeZone(abbreviation: timeZone)!
        let targetDate = self.convertToTimeZone(initTimeZone: TimeZone.current, timeZone: tZone)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h a"
        dateFormatter.timeZone = tZone

        return dateFormatter.string(from: targetDate)
    }
}
