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
    let weather: Weather
}

// MARK: - Pollution

struct Pollution: Codable {
    let ts: String
    let aqius: Int
    let mainus: String
    let aqicn: Int
    let maincn: String
}

// MARK: - Weather

struct Weather: Codable {
    let ts: String
    let tp, pr, hu: Int
    let ws: Double
    let wd: Int
    let ic: String
}

// MARK: - Location

struct Location: Codable {
    let type: String
    let coordinates: [Double]
}

struct Coordinates: Codable {
    let results: [Result1]
}

// MARK: - Result

struct Result1: Codable {
    let geometry: Geometry
}

// MARK: - Geometry

struct Geometry: Codable {
    let lat, lng: Double
}
