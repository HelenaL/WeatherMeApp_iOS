//
//  WeatherDataCenter.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 7/23/23.
//

import Foundation
import WeatherKit
import CoreLocation

class WeatherDataCenter {
    static let shared = WeatherDataCenter()
    let weatherService = WeatherService()
    var weather: Weather?
    
    func getWeatherForLocation(location: CLLocation, completion: @escaping (_ result: Result<ParsedWeather, Error>) -> Void) {
        
        Task {
            do {
                let hourlyStartDate = Date.now
                let hourlyEndDate = Date(timeIntervalSinceNow: 60*60*6)
                
                let weather2: (currentWeather: CurrentWeather,
                               hourlyForecast: Forecast<HourWeather>,
                               weatherAlerts: [WeatherAlert]?,
                               dailyForecast: Forecast<DayWeather>) = try await weatherService.weather(for: location, including: 
                                    .current,
                                .hourly(startDate: hourlyStartDate, endDate: hourlyEndDate),
                                .alerts, 
                                .daily)
                
               let parsed = ParsedWeather(currentWeather: weather2.currentWeather,
                                           hourlyForecast: weather2.hourlyForecast,
                                           dailyForecast: weather2.dailyForecast,
                                           weatherAlerts: weather2.weatherAlerts)
                DispatchQueue.main.async {
                    completion(.success(parsed))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
}
