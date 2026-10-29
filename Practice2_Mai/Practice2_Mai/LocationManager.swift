//
//  LocationManager.swift
//  Practice2_Mai
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
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 10
        authorizationStatus = manager.authorizationStatus
    }
    
    func requestCurrentLocation() {
        let status = manager.authorizationStatus
        
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
     DispatchQueue.main.async {
                self.errorMessage = nil
                self.isLoading = true
            }
            manager.startUpdatingLocation()
            
        case .restricted, .denied:
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Quyền truy cập vị trí đã bị từ chối trong Cài đặt."
            }
            
        @unknown default:
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Trạng thái quyền không xác định."
            }
        }
    }
    
    // Xử lý ngay sau khi người dùng bấm "Allow" trên popup của điện thoại
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        DispatchQueue.main.async {
            self.authorizationStatus = status
        }
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            DispatchQueue.main.async {
                self.isLoading = true
                self.errorMessage = nil
            }
            manager.startUpdatingLocation()
        } else if status == .denied || status == .restricted {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Bạn đã từ chối quyền vị trí."
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.currentLocation = location
            self.isLoading = false
            self.errorMessage = nil
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMessage = "Lỗi GPS: \(error.localizedDescription)"
        }
    }
}
