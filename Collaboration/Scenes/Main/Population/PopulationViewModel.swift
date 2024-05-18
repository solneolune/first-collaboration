//
//  PopulationViewModel.swift
//  Collaboration
//
//  Created by Barbare Tepnadze on 17.05.24.
//

import Foundation
import BarbareDoesNetworking

protocol PopulationViewModelDelegate: AnyObject {
    func didFetchData()
}

class PopulationViewModel {
    
    
    // MARK: - Variables
    private let populationService: PopulationService
    var todayPopulationText: String?
    var tomorrowPopulationText: String?
    var errorMessage: ((String) -> Void)?
    private let networkService = NetworkService()
    weak var delegate: PopulationViewModelDelegate?
    
    // MARK: - Initialiser
    
    init(populationService: PopulationService = PopulationService()) {
        self.populationService = populationService
    }
    // MARK: - Helper Functions
    
    
    func fetchCountryWeatherData(country: String){
        
        
        guard let url = URL(string: "https://d6wn6bmjj722w.population.io:443/1.0/population/\(country)/today-and-tomorrow/") else {
            fatalError("Invalid URL")
        }
        
        networkService.fetch(url: url, parse: { data -> PopulationResponse? in
            return try? JSONDecoder().decode(PopulationResponse.self, from: data)
        }) { [weak self] result in
            switch result {
            case .success(let weatherData):
                print(weatherData)
                guard let weatherData = weatherData else { return }
                self?.todayPopulationText = ("\(weatherData.total_population[0].population)")
                self?.tomorrowPopulationText = ("\(weatherData.total_population[1].population)")
                self?.delegate?.didFetchData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
