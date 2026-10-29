//
//  LocationManager.swift
//  Practice1_Mai
//
//  Created by MAY 08 on 29/10/26.
//


import Foundation
import CoreLocation
import Combine
import SwiftUI

class LocationManager: NSObject, ObservableObject {
    private lazy var manager: CLLocationManager = {
        let m = CLLocationManager()
        m.delegate = self
        return m
    }()
    
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var servicesEnabled: Bool = false
    
    override init() {
        super.init()
        refreshStatus()
    }
    
    func requestPermission() {
        DispatchQueue.main.async {
            self.manager.requestWhenInUseAuthorization()
        }
    }
    
    func refreshStatus() {
        DispatchQueue.global().async {
            let services = CLLocationManager.locationServicesEnabled()
            let status = self.manager.authorizationStatus
            DispatchQueue.main.async {
                self.servicesEnabled = services
                self.authorizationStatus = status
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus
            self.servicesEnabled = CLLocationManager.locationServicesEnabled()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }
}
