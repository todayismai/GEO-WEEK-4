//
//  ContentView.swift
//  Practice1_Mai
//
//  Created by MAY 08 on 29/10/26.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    
    // Hàm chuyển đổi rawValue sang chuỗi trạng thái dễ hiểu
    private var statusString: String {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            return "Not Determined"
        case .restricted:
            return "Restricted"
        case .denied:
            return "Denied"
        case .authorizedAlways:
            return "Authorized Always"
        case .authorizedWhenInUse:
            return "Authorized When In Use"
        @unknown default:
            return "Unknown"
        }
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header Icon & Title
                VStack(spacing: 12) {
                    Image(systemName: "location.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.blue)
                    
                    Text("Location Status Test")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                // Card hiển thị thông tin
                VStack(spacing: 16) {
                    HStack {
                        Text("Services Enabled")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(locationManager.servicesEnabled ? "Yes" : "No")
                            .fontWeight(.semibold)
                            .foregroundColor(locationManager.servicesEnabled ? .green : .red)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Authorization Status")
                            .foregroundColor(.secondary)
                        Text(statusString)
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                
                // Nút bấm yêu cầu quyền
                Button(action: {
                    locationManager.requestPermission()
                }) {
                    Text("Request Location Permission")
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
}

#Preview {
    ContentView()
}
