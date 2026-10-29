//
//  ContentView.swift
//  Practice2_Mai
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
            
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Image(systemName: "location.fill.viewfinder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.blue)
                    
                    Text("Smart Location")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                VStack(spacing: 16) {
                    if let location = locationManager.currentLocation {
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Location received")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.green)
                                Spacer()
                            }
                            
                            Divider()
                            
                            infoRow(title: "Latitude", value: String(format: "%.4f°", location.coordinate.latitude))
                            infoRow(title: "Longitude", value: String(format: "%.4f°", location.coordinate.longitude))
                            infoRow(title: "Accuracy", value: "± \(String(format: "%.1f", location.horizontalAccuracy)) m")
                            
                            let formatter = DateFormatter()
                            let _ = { formatter.dateStyle = .medium; formatter.timeStyle = .medium }()
                            infoRow(title: "Timestamp", value: formatter.string(from: location.timestamp))
                        }
                    } else if let errorMsg = locationManager.errorMessage {
                        VStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.orange)
                            Text("Unable to get your location")
                                .font(.headline)
                            Text(errorMsg)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical, 10)
                    } else if locationManager.isLoading {
                        VStack(spacing: 8) {
                            ProgressView()
                            Text("Requesting location...")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        }
                        .padding(.vertical, 15)
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "location.circle")
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                            Text("Tap the button to request location.")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        }
                        .padding(.vertical, 15)
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                
                Button(action: {
                    locationManager.requestCurrentLocation()
                }) {
                    Text("Get Current Location")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 24)
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
}

#Preview {
    ContentView()
}

