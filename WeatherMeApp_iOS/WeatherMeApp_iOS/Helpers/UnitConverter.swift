//
//  UnitConverter.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 10/9/23.
//

import Foundation

class UnitConverter {

    /// Return user's temperature unit.
    /// - Returns: User's Temperature Unit.
    
    private static func getLocalTemperatureUnit() -> UnitTemperature {
        let allUnits: [UnitTemperature] = [.celsius, .fahrenheit, .kelvin]

        let baseUnit = allUnits[0]
        let formatter = MeasurementFormatter()
        formatter.locale = .current
        let measurement = Measurement(value: 0, unit: baseUnit)
        let string = formatter.string(from: measurement)
        
        for unit in allUnits where string.contains(unit.symbol) {
            return unit
        }
        
        return baseUnit
    }
    
    /// Returns a Boolean value that indicates whether the receiver needs to convert temperature.
    /// - Parameter temperatureUnit: Temperature Unit.
    /// - Returns: true if the receiver need to convert temperature, otherwise false.
    
    private static func needToConvert(temperatureUnit: UnitTemperature) -> Bool {
        let localeTempUnit = getLocalTemperatureUnit()
        return localeTempUnit.symbol != temperatureUnit.symbol
    }
    
    /// Convert temperature value to the specified unit .
    /// - Parameter temperature: A numeric temperature value labeled with a unit of measure .
    /// - Returns: A converted measurement.
    
    static func convertTemperature(temperature: Measurement<UnitTemperature>) -> Measurement<UnitTemperature> {
        var newTemperature = temperature
        if needToConvert(temperatureUnit: temperature.unit) {
            let newTempUnit = getLocalTemperatureUnit()
            newTemperature = temperature.converted(to: newTempUnit)
        }
        
        return newTemperature
    }
    
}
