//
//  LocationWeatherModel.swift
//  Collaboration
//
//  Created by Akaki Titberidze on 17.05.24.
//

import Foundation

class LocationWeatherModel: Codable {
    let list: [List]
}

struct List: Codable {
    let dt: Double
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let visibility: Int
}


struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
}

struct Wind: Codable {
    let speed: Double
    let deg: Double
    let gust: Double
}

