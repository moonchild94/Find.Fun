//
//  LocationManager.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 29.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

import Foundation
import CoreLocation

internal protocol LocationManagerDelegate: NSObjectProtocol {
    func locationManager(_ manager: LocationManager, didUpdateCoordinates coordinates: [Coordinate])
}

internal class LocationManager: NSObject {
    private let locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        return locationManager
    }()
    
    weak var delegate: LocationManagerDelegate? {
        didSet {
            locationManager.delegate = delegate == nil ? nil : self
        }
    }
    
    var activityType: ActivityType {
        set {
            locationManager.activityType = newValue.convertToCLActivityType()
        }
        
        get {
            return locationManager.activityType.convertToActivityType()
        }
    }
    
    var distanceFilter: Double {
        set {
            locationManager.distanceFilter = newValue
        }
        
        get {
            return locationManager.distanceFilter
        }
    }
    
    var coordinate: Coordinate? {
        return locationManager.location?.coordinate.convertToCoordinate()
    }
    
    func status() -> LocationStatus {
        guard CLLocationManager.locationServicesEnabled() else { return .turnedOff }
        return CLLocationManager.authorizationStatus().convertToLocationStatus()
    }
    
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coordinates = locations.map { $0.coordinate.convertToCoordinate() }
        delegate?.locationManager(self, didUpdateCoordinates: coordinates)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

private extension CLLocationCoordinate2D {
    func convertToCoordinate() -> Coordinate {
        return Coordinate(latitude: latitude, longitude: longitude)
    }
}

private extension CLAuthorizationStatus {
    func convertToLocationStatus() -> LocationStatus {
        switch self {
        case .authorizedWhenInUse:
            return .authorizedWhenInUse
        case .denied:
            return .denied
        case .notDetermined:
            return .notDetermined
        case .restricted:
            return .restricted
        case .authorizedAlways:
            return .authorizedAlways
        @unknown default:
            // It seems it can't happen
            fatalError()
        }
    }
}

private extension ActivityType {
    func convertToCLActivityType() -> CLActivityType {
        switch self {
        case .automotiveNavigation:
            return .automotiveNavigation
        case .otherNavigation:
            return .otherNavigation
        case .other:
            return .other
        }
    }
}

private extension CLActivityType {
    func convertToActivityType() -> ActivityType {
        switch self {
        case .automotiveNavigation:
            return .automotiveNavigation
        case .otherNavigation:
            return .otherNavigation
        case .other:
            return .other
        default:
            // It can't happen
            fatalError("Unknown activity type!")
        }
    }
}
