//
//  ContentView.swift
//  Practice4_Mai
//
//  Created by MAY 08 on 29/10/26.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var locationManager = LocationManager.shared
    
    // Quản lý vị trí hiển thị trên bản đồ (mặc định trung tâm TP.HCM)
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 10.8231, longitude: 106.6297),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    @State private var selectedPlace: Place? = nil
    @State private var distanceText: String = "--"

    var body: some View {
        ZStack(alignment: .bottom) {
            // Hiển thị bản đồ MapKit (Task D - Step 1, 2, 4, 5)
            Map(position: $cameraPosition, selection: $selectedPlace) {
                // Hiển thị vị trí hiện tại của user với chấm xanh (Task D - Step 2)
                UserAnnotation()
                
                // Hiển thị các marker địa điểm mẫu (Task D - Step 4)
                ForEach(samplePlaces) { place in
                    Marker(place.name, coordinate: place.coordinate)
                        .tint(.red)
                        .tag(place) // Gắn tag để bắt sự kiện chọn marker (Task D - Step 5)
                }
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .ignoresSafeArea()
            
            // Bảng thông tin chi tiết khi người dùng bấm chọn một Marker (Task D - Step 5 & Step 6)
            if let place = selectedPlace {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(place.name)
                                .font(.title3)
                                .fontWeight(.bold)
                            if let address = place.address {
                                Text(address)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                        Button(action: {
                            selectedPlace = nil
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Divider()
                    
                    // Hiển thị khoảng cách tính bằng đường chim bay từ vị trí hiện tại (Task D - Step 6)
                    HStack {
                        Image(systemName: "ruler")
                            .foregroundColor(.blue)
                        Text("Khoảng cách:")
                            .fontWeight(.medium)
                        Spacer()
                        Text(distanceText)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(radius: 10)
                .padding()
                .transition(.move(edge: .bottom))
            }
        }
        .onAppear {
            // Yêu cầu quyền và bắt đầu lấy vị trí khi mở app (Task D - Step 2)
            locationManager.requestAuthorization()
            locationManager.startUpdatingLocation()
        }
        // Khi người dùng bấm chọn marker trên bản đồ, tự động dịch chuyển camera và tính khoảng cách (Task D - Step 5 & 6)
        .onChange(of: selectedPlace) { newPlace in
            if let place = newPlace {
                // 1. Dịch chuyển camera tới địa điểm được chọn
                withAnimation {
                    cameraPosition = .region(
                        MKCoordinateRegion(
                            center: place.coordinate,
                            latitudinalMeters: 1000,
                            longitudinalMeters: 1000
                        )
                    )
                }
                
                // 2. Tính khoảng cách từ vị trí hiện tại đến địa điểm được chọn (Task D - Step 6)
                if let userLoc = locationManager.currentLocation {
                    let placeLoc = CLLocation(latitude: place.latitude, longitude: place.longitude)
                    let distanceInMeters = userLoc.distance(from: placeLoc)
                    
                    if distanceInMeters >= 1000 {
                        let distanceInKm = distanceInMeters / 1000.0
                        distanceText = String(format: "%.2f km", distanceInKm)
                    } else {
                        distanceText = String(format: "%.1f m", distanceInMeters)
                    }
                } else {
                    distanceText = "Chưa xác định được vị trí GPS hiện tại"
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
