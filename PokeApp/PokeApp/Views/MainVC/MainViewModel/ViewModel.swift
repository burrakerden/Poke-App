//
//  ViewModel.swift
//  PokeApp
//
//  Created by Burak Erden on 20.03.2023.
//

import Foundation

class ViewModel {
    
    var pokeNamesData: (([Result]?) -> Void)?
    var pokePaginationUrl: ((String) -> Void)?
    
    func getPokeData() {
        Service().getPokeName(){ result in
            guard let data = result?.results else {return}
            self.pokeNamesData?(data)
        } onError: { error in
            print("ERROR: ", error.localizedDescription)
        }
    }
    
    func getNextPageUrl() {
        Service().getPokeName(){ result in
            guard let paginationUrl = result?.next else {return}
            self.pokePaginationUrl?(paginationUrl)
        } onError: { error in
            print("ERROR: ", error.localizedDescription)
        }
    }
    
    func getNextPageData(url: String) {
        PaginationService().getPokePagination(paginationUrl: url){ result in
            guard let data = result?.results else {return}
            guard let nextPageUrl = result?.next else {return}
            self.pokeNamesData?(data)
            self.pokePaginationUrl?(nextPageUrl)
        } onError: { error in
            print("ERROR: ", error.localizedDescription)
        }
    }
    
    
}
