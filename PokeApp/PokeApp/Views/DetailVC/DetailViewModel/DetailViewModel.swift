//
//  ViewModel.swift
//  PokeApp
//
//  Created by Burak Erden on 21.03.2023.
//

import Foundation

class DetailViewModel {
    
    //MARK: - Properties

    var pokeDetailData: ((PokeDetail) -> Void)?
    
    //MARK: - Functions

    func getPokeDetail(url: String) {
        DetailService().getPokeDetail(url: url){ result in
            guard let data = result else {return}
            self.pokeDetailData?(data)
        } onError: { error in
            print("ERROR: ", error.localizedDescription)
        }
    }
}
