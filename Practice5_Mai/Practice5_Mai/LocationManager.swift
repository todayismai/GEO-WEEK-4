//
//  LocationManager.swift
//  Practice5_Mai
//
//  Created by MAY 08 on 29/10/26.
//


import Foundation
import CoreLocation
import Combine
import SwiftUI 

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentLocation: CLLocation? = nil
    @Published var isTracking: Bool = false
    @Published var errorMessage: String? = nil
    
    // Danh sách địa điểm đồng bộ toàn app (Task E - Step 5)
    @Published var places: [Place] = samplePlaces

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
            manager.startUpdatingLocation()
            isTracking = true
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            errorMessage = "Quyền vị trí chưa được cấp."
        }
    }
    
    func stopTracking() {
        manager.stopUpdatingLocation()
        isTracking = false
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.currentLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = "Lỗi GPS: \(error.localizedDescription)"
        }
    }
    
    // Thêm hoặc xóa địa điểm
    func addPlace(_ place: Place) {
        places.append(place)
    }
    
    func deletePlaces(at offsets: IndexSet) {
        places.remove(atOffsets: offsets)
    }
}
