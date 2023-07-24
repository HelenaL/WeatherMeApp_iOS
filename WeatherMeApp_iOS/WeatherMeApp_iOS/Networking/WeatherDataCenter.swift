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
    
    func getWeatherForLocation(location: CLLocation, completion: @escaping (_ result: Result<Weather, Error>) -> Void) {

        Task {
            do {
                let weather = try await weatherService.weather(for: location)
                completion(.success(weather))
            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }

    }
    
    
    
}
