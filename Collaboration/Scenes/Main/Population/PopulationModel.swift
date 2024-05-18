//
//  PopulationModel.swift
//  Collaboration
//
//  Created by Elene Donadze on 5/17/24.
//


import Foundation

struct PopulationResponse: Codable {
    let total_population: [Population]
}
 
struct Population: Codable {
    let date: String
    let population: Int
}
