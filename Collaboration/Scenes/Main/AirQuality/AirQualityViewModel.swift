//
//  AirQualityViewModel.swift
//  Collaboration
//
//  Created by Barbare Tepnadze on 17.05.24.
//

import BarbareDoesNetworking
import Foundation

class AirQualityViewModel {
    // MARK: - Variables

    var showError: ((String) -> Void)?
    var airQualityInfo: Info?
    var updateUI: (() -> Void)?
    var latitude: Double?
    var longitude: Double?
    private let networkService = NetworkService()
    private var isFetchCompleted = false

    // MARK: - Helper Functions

    func fetchCoordinates(city: String, completion: @escaping (Double, Double) -> Void) {
        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let API = "2cf8d24ae52349ef811a6ff1fdd4c3fe"
        let urlString = "https://api.opencagedata.com/geocode/v1/json?q=\(encodedCity)&key=\(API)"
        guard let url = URL(string: urlString) else {
            showError?("Invalid URL")
            return
        }

        networkService.fetch(url: url, parse: { data in
            try? JSONDecoder().decode(Coordinates.self, from: data)
        }) { (result: Result<Coordinates?, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case let .success(coordinates):
                    if let firstResult = coordinates?.results.first {
                        let latitude = firstResult.geometry.lat
                        let longitude = firstResult.geometry.lng
                        completion(latitude, longitude)
                    } else {
                        self.showError?("No coordinates found for the specified city")
                    }
                case let .failure(error):
                    print("Error fetching coordinates: \(error.localizedDescription)")
                    self.showError?("Error fetching coordinates: \(error.localizedDescription)")
                }
                self.isFetchCompleted = true
                if self.isFetchCompleted && self.airQualityInfo != nil {
                    self.updateUI?()
                }
            }
        }
    }

    func fetchAirQualityInfo(lat: Double, lon: Double) {
        let API = "98d98bf5-d9c8-4644-aefb-e52bf4733502"
        let urlString = "https://api.airvisual.com/v2/nearest_city?lat=\(lat)&lon=\(lon)&key=\(API)"
        guard let url = URL(string: urlString) else {
            showError?("Invalid URL")
            return
        }

        networkService.fetch(url: url, parse: { data in
            try? JSONDecoder().decode(Info.self, from: data)
        }) { (result: Result<Info?, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case let .success(info):
                    if let info = info {
                        self.airQualityInfo = info
                        self.updateUI?()
                    }
                case let .failure(error):
                    self.showError?("Error: \(error.localizedDescription)")
                }

                self.isFetchCompleted = true
                if self.isFetchCompleted && self.latitude != nil && self.longitude != nil {
                    self.updateUI?()
                }
            }
        }
    }
}
