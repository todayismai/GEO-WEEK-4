//
//  ContentView.swift
//  Practice3_Mai
//
//  Created by MAY 08 on 29/10/26.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header Title & Status Indicator
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(locationManager.isTracking ? Color.green : Color.gray)
                                .frame(width: 10, height: 10)
                            Text(locationManager.isTracking ? "Tracking Active" : "Not Tracking")
                                .font(.headline)
                                .foregroundColor(locationManager.isTracking ? .green : .secondary)
                        }
                        
                        Text("Smart Location Tracker")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding(.top, 10)
                    
                    // Card 1: Thông tin tọa độ chi tiết
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Location Information")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Divider()
                        
                        if let loc = locationManager.currentLocation {
                            VStack(spacing: 12) {
                                infoRow(title: "Latitude", value: String(format: "%.4f°", loc.coordinate.latitude))
                                infoRow(title: "Longitude", value: String(format: "%.4f°", loc.coordinate.longitude))
                                infoRow(title: "Accuracy", value: "± \(String(format: "%.1f", loc.horizontalAccuracy)) m")
                                
                                let timeString = locationManager.lastUpdateTime?.formatted(date: .omitted, time: .standard) ?? "-"
                                infoRow(title: "Last update", value: timeString)
                            }
                        } else {
                            Text("Chưa có dữ liệu vị trí. Bấm Start Tracking để bắt đầu.")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                                .padding(.vertical, 8)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
                    
                    // Card 2: Khoảng cách di chuyển
                    HStack(spacing: 16) {
                        distanceCard(
                            title: "Total Distance",
                            value: String(format: "%.1f m", locationManager.totalDistance),
                            icon: "route.fill",
                            color: .blue
                        )
                        
                        distanceCard(
                            title: "Last Movement",
                            value: String(format: "%.1f m", locationManager.lastDistance),
                            icon: "figure.walk",
                            color: .green
                        )
                    }
                    
                    // Nút điều khiển Start / Stop Tracking
                    VStack(spacing: 12) {
                        if locationManager.isTracking {
                            Button(action: {
                                locationManager.stopTracking()
                            }) {
                                Label("Stop Tracking", systemImage: "stop.fill")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .cornerRadius(12)
                            }
                        } else {
                            Button(action: {
                                locationManager.resetDistance()
                                locationManager.startTracking()
                            }) {
                                Label("Start Tracking", systemImage: "play.fill")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
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
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
    }
    
    @ViewBuilder
    private func distanceCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(value)
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
    }
}

#Preview {
    ContentView()
}
