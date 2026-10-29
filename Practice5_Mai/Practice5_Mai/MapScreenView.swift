//
//  MapScreenView.swift
//  Practice5_Mai
//
//  Created by MAY 08 on 29/10/26.
//


import SwiftUI
import MapKit

struct MapScreenView: View {
    @ObservedObject var locationManager: LocationManager
    
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 10.8231, longitude: 106.6297),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Map")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Map(position: $cameraPosition) {
                UserAnnotation()
                
                // Hiển thị danh sách địa điểm từ LocationManager
                ForEach(locationManager.places) { place in
                    Marker(place.name, coordinate: place.coordinate)
                        .tint(.red)
                }
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
        }
    }
}