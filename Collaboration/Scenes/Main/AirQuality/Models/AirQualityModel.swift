//
//  AirQualityModel.swift
//  Collaboration
//
//  Created by Luka  Kharatishvili on 17.05.24.
//

import Foundation

// MARK: - Info

struct Info: Codable {
    let status: String
    let data: DataClass
}

// MARK: - DataClass

struct DataClass: Codable {
    let city, state, country: String
    let location: Location
    let current: Current
}

// MARK: - Current

struct Current: Codable {
    let pollution: Pollution
}

// MARK: - Pollution

struct Pollution: Codable {
    let ts: String
    let aqius: Int
    let mainus: String
}

// MARK: - Location

struct Location: Codable {
    let type: String
    let coordinates: [Double]
}

struct Coordinates: Codable {
    let results: [ResultGeometry]
}

// MARK: - Result

struct ResultGeometry: Codable {
    let geometry: Geometry
}

// MARK: - Geometry

struct Geometry: Codable {
    let lat, lng: Double
}
