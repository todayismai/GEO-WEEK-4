//
//  HomeView.swift
//  Practice5_Mai
//
//  Created by MAY 08 on 29/10/26.
//


import SwiftUI
import CoreLocation

struct HomeView: View {
    @ObservedObject var locationManager: LocationManager

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Smart Location Tracker")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Card hiển thị thông tin tọa độ
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "location.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    
                    if let loc = locationManager.currentLocation {
                        infoRow(title: "Latitude", value: String(format: "%.4f°", loc.coordinate.latitude))
                        infoRow(title: "Longitude", value: String(format: "%.4f°", loc.coordinate.longitude))
                        infoRow(title: "Accuracy", value: String(format: "%.1f m", loc.horizontalAccuracy))
                    } else {
                        Text("Đang chờ dữ liệu vị trí...")
                            .foregroundColor(.secondary)
                    }
                    
                    let statusText = locationManager.authorizationStatus == .authorizedWhenInUse ? "Authorized" : "Not Determined"
                    infoRow(title: "Permission", value: statusText)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                .padding(.horizontal)
                
                // Nút điều khiển Start / Stop Tracking
                VStack(spacing: 12) {
                    Button(action: {
                        locationManager.startTracking()
                    }) {
                        Label("Start Tracking", systemImage: "play.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        locationManager.stopTracking()
                    }) {
                        Label("Stop Tracking", systemImage: "stop.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    @ViewBuilder
    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        Divider()
    }
}