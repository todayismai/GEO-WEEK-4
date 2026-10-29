//
//  LocationManager.swift
//  Practice3_Mai
//
//  Created by MAY 08 on 29/10/26.
//


import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentLocation: CLLocation? = nil
    @Published var previousLocation: CLLocation? = nil
    @Published var isTracking: Bool = false
    @Published var errorMessage: String? = nil
    
    @Published var totalDistance: CLLocationDistance = 0
    @Published var lastDistance: CLLocationDistance = 0
    private let minDistanceThreshold: CLLocationDistance = 1
    @Published var lastUpdateTime: Date? = nil

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 10
        authorizationStatus = manager.authorizationStatus
    }
    
    func startTracking() {
        let status = manager.authorizationStatus
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            errorMessage = nil
            manager.startUpdatingLocation()
            isTracking = true
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            errorMessage = "Quyền truy cập vị trí bị từ chối."
        @unknown default:
            errorMessage = "Trạng thái quyền không xác định."
        }
    }
    
    func stopTracking() {
        manager.stopUpdatingLocation()
        isTracking = false
    }
    
    func resetDistance() {
        totalDistance = 0
        lastDistance = 0
        previousLocation = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            if isTracking {
                manager.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        
        guard isValidLocation(newLocation) else { return }
        
        if let previous = previousLocation {
            let distance = previous.distance(from: newLocation)
            if distance >= minDistanceThreshold {
                lastDistance = distance
                totalDistance += distance
                previousLocation = newLocation
            }
        } else {
            previousLocation = newLocation
        }
        
        DispatchQueue.main.async {
            self.currentLocation = newLocation
            self.lastUpdateTime = Date()
            self.errorMessage = nil
        }
    }
    
    private func isValidLocation(_ location: CLLocation) -> Bool {
        if location.horizontalAccuracy < 0 || location.horizontalAccuracy > 100 {
            return false
        }
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = "Lỗi GPS: \(error.localizedDescription)"
        }
    }
}
