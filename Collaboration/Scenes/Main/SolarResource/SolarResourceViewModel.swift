//
//  SolarResourceViewModel.swift
//  Collaboration
//
//  Created by Barbare Tepnadze on 17.05.24.
//

import Foundation
import BarbareDoesNetworking

struct SolarDataDisplay {
    let avgDniAnnual: Double
    let avgGhiAnnual: Double
    let avgTiltAnnual: Double
    let avgDniMonthly: [String: Double]
    let avgGhiMonthly: [String: Double]
    let avgTiltMonthly: [String: Double]
}

class SolarResourceViewModel {
    // MARK: - Variables
    private let networkService: NetworkService
    var dataFetched: ((String) -> Void)?
    
    var solarData: SolarDataDisplay?
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Helper Functions
    func fetchSolarData(for address: String) {
        let apiKey = "IuzFOnfRsDbOwA6UVR9djsH3bsmU8Z8SaWzHy4a8"
        guard let url = URL(string: "https://developer.nrel.gov/api/solar/solar_resource/v1.json?api_key=\(apiKey)&amp;address=\(address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") else { return }
        
        networkService.fetch(url: url, parse: { data -> SolarData? in
            print(String(data: data, encoding: .utf8) ?? "No data")
            return try? JSONDecoder().decode(SolarData.self, from: data)
        }) { [weak self] result in
            switch result {
            case .success(let solarData):
                guard let solarData = solarData else { return }
                let displayData = SolarDataDisplay(
                    avgDniAnnual: solarData.outputs.avg_dni.annual,
                    avgGhiAnnual: solarData.outputs.avg_ghi.annual,
                    avgTiltAnnual: solarData.outputs.avg_lat_tilt.annual,
                    avgDniMonthly: solarData.outputs.avg_dni.monthly,
                    avgGhiMonthly: solarData.outputs.avg_ghi.monthly,
                    avgTiltMonthly: solarData.outputs.avg_lat_tilt.monthly
                )
                self?.solarData = displayData
                let dataString = """
                Average Direct Normal Irradiance: \(displayData.avgDniAnnual)
                Average Global Horizontal Irradiance: \(displayData.avgGhiAnnual)
                Average Tilt at Latitude: \(displayData.avgTiltAnnual)
                """
                self?.dataFetched?(dataString)
            case .failure(let error):
                print(error)
            }
        }
    }
}
