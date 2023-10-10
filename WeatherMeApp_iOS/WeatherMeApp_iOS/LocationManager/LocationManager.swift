//
//  LocationManager.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 9/28/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    // MARK: - Properties

    private let locationManager = CLLocationManager()
    
    var locationStatus: CLAuthorizationStatus?
    var lastLocation: CLLocation?
    
    var onLocationChange: ((CLLocation?) -> Void)?
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startLocationManagerIfNeeded() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationStatus = status
        print(#function, statusString)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location
        print(#function, location)
        onLocationChange?(location)
    }
}
