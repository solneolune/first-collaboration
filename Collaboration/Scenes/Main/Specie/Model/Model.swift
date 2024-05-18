//
//  Model.swift
//  Collaboration
//
//  Created by Data on 18.05.24.
//

import Foundation

struct Place: Codable {
    let id: Int
    let display_name: String
}

struct AutocompleteResponse: Codable {
    let results: [Place]
}

struct Observation: Codable {
    let taxon: Taxon
}

struct Taxon: Codable {
    let name: String?
    let wikipedia_url: String?
    let default_photo: DefaultPhoto?
}

struct DefaultPhoto: Codable {
    let square_url: String
    let attribution: String
}

struct SpeciesCountsResponse: Codable {
    let results: [Observation]
}
