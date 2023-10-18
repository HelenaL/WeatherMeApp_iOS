//
//  CLLocation+Extension.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 10/10/23.
//

import Foundation
import MapKit

extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}
