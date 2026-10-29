//
//  SavedPlacesView.swift
//  Practice5_Mai
//
//  Created by MAY 08 on 29/10/26.
//


import SwiftUI

struct SavedPlacesView: View {
    @ObservedObject var locationManager: LocationManager

    var body: some View {
        NavigationStack {
            List {
                ForEach(locationManager.places) { place in
                    NavigationLink(destination: PlaceDetailView(place: place)) {
                        HStack(spacing: 12) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.title2)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(place.name)
                                    .font(.headline)
                                Text("\(place.latitude.formatted()), \(place.longitude.formatted())")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: locationManager.deletePlaces)
            }
            .navigationTitle("Saved Places")
            .toolbar {
                EditButton()
            }
        }
    }
}

// Màn hình chi tiết địa điểm (Task E - Step 4)
struct PlaceDetailView: View {
    let place: Place
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.red)
            
            Text(place.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 12) {
                detailRow(title: "Latitude", value: String(format: "%.4f", place.latitude))
                detailRow(title: "Longitude", value: String(format: "%.4f", place.longitude))
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top)
        .navigationTitle("Place Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func detailRow(title: String, value: String) -> some View {
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