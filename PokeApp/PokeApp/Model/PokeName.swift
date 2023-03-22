//  PokeName.swift
//  PokeApp
//
//  Created by Burak Erden on 20.03.2023.
//


import Foundation

// MARK: - PokeName
struct PokeName: Codable {
    let count: Int?
    let results: [Result]?
}

// MARK: - Result
struct Result: Codable {
    let name: String?
    let url: String?
}
