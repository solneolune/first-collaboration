//
//  PopulationNetoworkService.swift
//  Collaboration
//
//  Created by Elene Donadze on 5/17/24.
//
import Foundation
import BarbareDoesNetworking
 
class PopulationService {
    
    let networkService = NetworkService()
    
    func fetchPopulation(for country: String, completion: @escaping (Result<PopulationResponse?, NetworkError>) -> Void) {
        guard let url = constructPopulationURL(for: country) else {
            completion(.failure(.wrongResponse))
            return
        }
        
        networkService.fetch(url: url, parse: { data in
            return try? JSONDecoder().decode(PopulationResponse.self, from: data)
        }, completion: completion)
    }
    
    private func constructPopulationURL(for country: String) -> URL? {
        let encodedCountryName = country.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        let urlString = "https://d6wn6bmjj722w.population.io:443/1.0/population/\(encodedCountryName ?? "")/today-and-tomorrow/"
        return URL(string: urlString)
    }
}

