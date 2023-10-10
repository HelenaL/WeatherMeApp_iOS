//
//  UnitConverter.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 10/9/23.
//

import Foundation

class UnitConverter {

    private static func getLocalTemperatureUnit() -> UnitTemperature {
        let allUnits: [UnitTemperature] = [.celsius, .fahrenheit, .kelvin]

        let baseUnit = allUnits[0]
        let formatter = MeasurementFormatter()
        formatter.locale = .current
        let measurement = Measurement(value: 0, unit: baseUnit)
        let string = formatter.string(from: measurement)
        
        for unit in allUnits where string.contains(unit.symbol) {
           // if string.contains(unit.symbol) {
            return unit
           // }
        }
        return baseUnit
    }
    
    private static func needToConvert(tempUnit: UnitTemperature) -> Bool {
        let localeTempUnit = getLocalTemperatureUnit()
        return localeTempUnit.symbol != tempUnit.symbol
    }
    
    static func convertTemperature(temperature: Measurement<UnitTemperature>) -> Measurement<UnitTemperature> {
        var newTemperature = temperature
        if needToConvert(tempUnit: temperature.unit) {
            let newTempUnit = getLocalTemperatureUnit()
            newTemperature = temperature.converted(to: newTempUnit)
        }
        return newTemperature
    }
}
