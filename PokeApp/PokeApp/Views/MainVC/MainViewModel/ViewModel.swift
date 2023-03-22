//
//  ViewModel.swift
//  PokeApp
//
//  Created by Burak Erden on 20.03.2023.
//

import Foundation

class ViewModel {
    
    //MARK: - Properties

    var pokeNamesData: (([Result]?) -> Void)?

    //MARK: - Functions
    
    func getPokeData() {
        Service().getPokeName(){ result in
            guard let data = result?.results else {return}
            self.pokeNamesData?(data)
        } onError: { error in
            print("ERROR: ", error.localizedDescription)
        }
    }
}
