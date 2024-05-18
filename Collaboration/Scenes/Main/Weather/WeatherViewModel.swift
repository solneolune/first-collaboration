//
//  WeatherViewModel.swift
//  Collaboration
//
//  Created by Barbare Tepnadze on 17.05.24.
//

import Foundation
import BarbareDoesNetworking

protocol WeatherViewModelDelegate: AnyObject {
    func didUpdateWeatherData()
    func cantFetchData(errorMessage: String)
}

class WeatherViewModel {
    // MARK: - Variables
    var cityDataResults: CityDataModel?
    var locationDataResults: LocationWeatherModel?
    var latitude: Double?
    var longitude: Double?
    var selectedCountryName = "Tbilisi"
    
    weak var delegate: WeatherViewModelDelegate?
    
    private let networkService = NetworkService()
    
    // MARK: - Initialiser
    func viewLoaded() {
        fetchCountryCoordinates(country: selectedCountryName)
    }
    
    // MARK: - Helper Functions
    func getWeatherData(countryName: String) {
        fetchCountryCoordinates(country: countryName)
    }
    
    func fetchCountryCoordinates(country: String) {
        let apiKey = "2cf8d24ae52349ef811a6ff1fdd4c3fe"
        guard let url = URL(string: "https://api.opencagedata.com/geocode/v1/json?q=\(country)&key=\(apiKey)") else {
            fatalError("Invalid URL")
        }
        
        networkService.fetch(url: url, parse: { data -> CityDataModel? in
            return try? JSONDecoder().decode(CityDataModel.self, from: data)
        }) { [weak self] result in
            switch result {
            case .success(let cityData):
                guard let cityData = cityData, !cityData.results.isEmpty else {
                    DispatchQueue.main.async {
                        self?.delegate?.cantFetchData(errorMessage: "No results found for the city: \(country)")
                    }
                    return
                }
                self?.selectedCountryName = country
                self?.cityDataResults = cityData
                self?.latitude = self?.cityDataResults?.results[0].geometry.lat
                self?.longitude = self?.cityDataResults?.results[0].geometry.lng
                self?.fetchCountryWeatherData(latitude: (self?.latitude)!, longitude: (self?.longitude)!)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchCountryWeatherData(latitude: Double, longitude: Double){
        let apiKey = "2bc0404bf7932948f77efddde0175888"
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric") else {
            fatalError("Invalid URL")
        }
        
        networkService.fetch(url: url, parse: { data -> LocationWeatherModel? in
            return try? JSONDecoder().decode(LocationWeatherModel.self, from: data)
        }) { [weak self] result in
            switch result {
            case .success(let weatherData):
                guard let weatherData = weatherData else { return }
                self?.locationDataResults = weatherData
                self?.delegate?.didUpdateWeatherData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func degreeToDirection(degree: Double) -> String {
        switch degree {
        case 0..<22.5, 337.5..<360:
            return "N"
        case 22.5..<67.5:
            return "NE"
        case 67.5..<112.5:
            return "E"
        case 112.5..<157.5:
            return "SE"
        case 157.5..<202.5:
            return "S"
        case 202.5..<247.5:
            return "SW"
        case 247.5..<292.5:
            return "W"
        case 292.5..<337.5:
            return "NW"
        default:
            return "N"
        }
        
    }
    
    func convertUnixTo24HR(unixTime: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let formattedTime = dateFormatter.string(from: date)
        
        return formattedTime
    }
    
    
    // MARK: - Computed Properties
    

    func getMinTemp() -> Int {
        Int(locationDataResults?.list[0].main.temp_min.rounded() ?? 0)
    }
    
    func getMaxTemp() -> Int {
        Int(locationDataResults?.list[0].main.temp_max.rounded() ?? 0)
    }
    
    func getFeelsLike() -> Double {
        locationDataResults?.list[0].main.feels_like ?? 0
    }
    
    func getHumidity() -> Int {
        locationDataResults?.list[0].main.humidity ?? 0
    }
    
    func getVisibility() -> Int {
        (locationDataResults?.list[0].visibility ?? 0)/1000
    }
    
    func getPressure() -> Int {
        locationDataResults?.list[0].main.pressure ?? 0
    }
    
    func getWindDegree() -> Int {
        Int(locationDataResults?.list[0].wind.deg ?? 0.rounded())
    }
    
    func getDirection() -> String {
        degreeToDirection(degree: locationDataResults?.list[0].wind.deg ?? 0)
    }
    
    func getWindSpeed() -> Int {
        Int(locationDataResults?.list[0].wind.speed.rounded() ?? 0)
    }
    
    func getGustSpeed() -> Int {
        Int(locationDataResults?.list[0].wind.gust.rounded() ?? 0)
    }
    
    func getWeatherTemperature() -> String {
        Int(locationDataResults?.list[0].main.temp ?? 0.rounded()).description
    }
    
    func getWeatherDetail() -> String {
        locationDataResults?.list[0].weather[0].main.description ?? ""
    }
    
    func getWeatherIcon() -> String {
        if let icon = locationDataResults?.list[0].weather[0].icon {
            return "https://openweathermap.org/img/wn/\(icon).png"
        }
        return ""
    }
    
    func getSelectedCountryName() -> String {
        selectedCountryName
    }
    
    func getWeatherDataCount() -> Int {
        return locationDataResults?.list.count ?? 0
    }
    
    func getWeatherDataDay(at index: Int) -> List? {
        return locationDataResults?.list[index]
    }
}
