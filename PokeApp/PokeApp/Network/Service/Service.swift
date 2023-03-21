//
//  Service.swift
//  PokeApp
//
//  Created by Burak Erden on 20.03.2023.
//

import Alamofire

//MARK: - Protocols

protocol ServiceProtocol {
    func getPokeName(onSuccess: @escaping (PokeName?) -> Void, onError: @escaping (AFError) -> Void)
}

protocol DetailServiceProtocol {
    func getPokeDetail(url: String, onSuccess: @escaping (PokeDetail?) -> Void, onError: @escaping (AFError) -> Void)
}

protocol PaginationServiceProtocol {
    func getPokePagination(paginationUrl: String, onSuccess: @escaping (PokeName?) -> Void, onError: @escaping (AFError) -> Void)
}

//MARK: - Service Class

final class Service: ServiceProtocol {
    func getPokeName(onSuccess: @escaping (PokeName?) -> Void, onError: @escaping (Alamofire.AFError) -> Void) {
        ServiceManager.shared.fetch(path: "https://pokeapi.co/api/v2/pokemon/") { (response: PokeName) in
            onSuccess(response)
        } onError: { (error) in
            onError(error)
        }
    }
}


final class DetailService: DetailServiceProtocol {
    func getPokeDetail(url: String, onSuccess: @escaping (PokeDetail?) -> Void, onError: @escaping (Alamofire.AFError) -> Void) {
        ServiceManager.shared.fetch(path: url) { (response: PokeDetail) in
            onSuccess(response)
        } onError: { (error) in
            onError(error)
        }
    }
}


final class PaginationService: PaginationServiceProtocol {
    func getPokePagination(paginationUrl: String, onSuccess: @escaping (PokeName?) -> Void, onError: @escaping (Alamofire.AFError) -> Void) {
        ServiceManager.shared.fetch(path: paginationUrl) { (response: PokeName) in
            onSuccess(response)
        } onError: { (error) in
            onError(error)
        }
    }
}
