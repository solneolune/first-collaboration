//
//  CityDataModel.swift
//  Collaboration
//
//  Created by Akaki Titberidze on 17.05.24.
//

import Foundation

struct CityDataModel: Codable {
    let results: [ResultWeatherModel]
}

struct ResultWeatherModel: Codable {
    let geometry: Geometry
}

struct WeatherGeometry: Codable {
    let lat: Double
    let lng: Double
}

