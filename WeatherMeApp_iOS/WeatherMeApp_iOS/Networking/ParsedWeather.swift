import Foundation
import WeatherKit
import CoreLocation

class ParsedWeather {
    let currentWeather: CurrentWeather
    let hourlyForecast: Forecast<HourWeather>
    let dailyForecast: Forecast<DayWeather>
    let weatherAlerts: [WeatherAlert]?
    
    init(currentWeather: CurrentWeather, hourlyForecast: Forecast<HourWeather>, dailyForecast: Forecast<DayWeather>, weatherAlerts: [WeatherAlert]?) {
        self.currentWeather = currentWeather
        self.hourlyForecast = hourlyForecast
        self.weatherAlerts = weatherAlerts
        self.dailyForecast = dailyForecast
    }
    
}
