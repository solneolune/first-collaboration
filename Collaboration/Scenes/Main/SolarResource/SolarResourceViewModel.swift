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
        guard let url = URL(string: "https://developer.nrel.gov/api/solar/solar_resource/v1.json?api_key=\(apiKey)&address=\(address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") else { return }
        
        networkService.fetch(url: url, parse: { data -> SolarData? in
            print(String(data: data, encoding: .utf8) ?? "No data")
            return try? JSONDecoder().decode(SolarData.self, from: data)
        }) { [weak self] result in
            switch result {
            case .success(let solarData):
                guard let solarData = solarData else { return }
                let sortedDniMonthly = self?.sortAndMapMonthlyData(solarData.outputs.avg_dni.monthly) ?? [:]
                let sortedGhiMonthly = self?.sortAndMapMonthlyData(solarData.outputs.avg_ghi.monthly) ?? [:]
                let sortedTiltMonthly = self?.sortAndMapMonthlyData(solarData.outputs.avg_lat_tilt.monthly) ?? [:]
                print(sortedDniMonthly)
                print(sortedGhiMonthly)
                print(sortedTiltMonthly)
                
                let displayData = SolarDataDisplay(
                    avgDniAnnual: solarData.outputs.avg_dni.annual,
                    avgGhiAnnual: solarData.outputs.avg_ghi.annual,
                    avgTiltAnnual: solarData.outputs.avg_lat_tilt.annual,
                    avgDniMonthly: sortedDniMonthly,
                    avgGhiMonthly: sortedGhiMonthly,
                    avgTiltMonthly: sortedTiltMonthly
                )
                self?.solarData = displayData
                for month in solarData.outputs.avg_dni.monthly {
                    print(month)
                }
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
    private func sortAndMapMonthlyData(_ monthlyData: [String: Double]) -> [String: Double] {
           let monthOrder = ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"]
           let monthMapping = [
               "jan": "January", "feb": "February", "mar": "March", "apr": "April",
               "may": "May", "jun": "June", "jul": "July", "aug": "August",
               "sep": "September", "oct": "October", "nov": "November", "dec": "December"
           ]
           var monthlyArray = monthlyData.map { (month: $0.key, value: $0.value) }
           monthlyArray.sort { (a, b) -> Bool in
               let aIndex = monthOrder.firstIndex(of: a.month) ?? 0
               let bIndex = monthOrder.firstIndex(of: b.month) ?? 0
               return aIndex < bIndex
           }
           var sortedMonthlyData = [String: Double]()
           for item in monthlyArray {
               if let fullMonthName = monthMapping[item.month] {
                   sortedMonthlyData[fullMonthName] = item.value
               }
           }
           return sortedMonthlyData
       }
}
