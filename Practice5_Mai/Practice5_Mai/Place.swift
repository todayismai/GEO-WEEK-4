//
//  Place.swift
//  Practice5_Mai
//
//  Created by MAY 08 on 29/10/26.
//


import Foundation
import CoreLocation

struct Place: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var latitude: Double
    var longitude: Double
    var address: String?
    
    init(id: UUID = UUID(), name: String, latitude: Double, longitude: Double, address: String? = nil) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
    }
}

extension Place {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

let samplePlaces: [Place] = [
    Place(name: "HCMUTE", latitude: 10.8506, longitude: 106.7719, address: "Ho Chi Minh City University of Technology and Education"),
    Place(name: "Ben Thanh Market", latitude: 10.7722, longitude: 106.6989, address: "District 1, Ho Chi Minh City"),
    Place(name: "Suoi Tien Park", latitude: 10.8931, longitude: 106.8091, address: "Thu Duc City, Ho Chi Minh City")
]