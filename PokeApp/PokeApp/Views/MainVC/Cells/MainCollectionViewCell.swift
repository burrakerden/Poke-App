//
//  MainCollectionViewCell.swift
//  PokeApp
//
//  Created by Burak Erden on 20.03.2023.
//

import UIKit
import Kingfisher

class MainCollectionViewCell: UICollectionViewCell {
    
    let model = DetailViewModel()
    var pokeData: PokeDetail?

    @IBOutlet weak var pokeImage: UIImageView!
    @IBOutlet weak var pokeName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func cellConfig(url: String) {
        self.model.getPokeDetail(url: url)
        self.model.pokeDetailData = {[weak self] value in
            guard let self = self else {return}
            self.pokeData = value
                self.setupUI()
        }
    }
    
    func setupUI() {
        pokeName.text = pokeData?.name.capitalized
        if let url = pokeData?.sprite.frontDefault {
            pokeImage.kf.setImage(with: URL(string: url))
        }
    }

}
