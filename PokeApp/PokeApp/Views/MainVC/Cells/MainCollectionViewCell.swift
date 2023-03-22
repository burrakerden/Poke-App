//
//  MainCollectionViewCell.swift
//  PokeApp
//
//  Created by Burak Erden on 20.03.2023.
//

import UIKit
import Kingfisher

//MARK: - Protocols

protocol GestureProtocol {
    func turnTheImage()
}

class MainCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    let model = DetailViewModel()
    var pokeData: PokeDetail?
    var delegate: GestureProtocol?

    //MARK: - IBOutlets

    @IBOutlet weak var pokeImage: UIImageView!
    @IBOutlet weak var pokeName: UILabel!
    
    //MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        doubleTapGesture()
    }
    
    //MARK: - Config
    
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
        DispatchQueue.main.async {
            if self.isSelected {
                if let url = self.pokeData?.sprite.frontDefault {
                    self.pokeImage.kf.setImage(with: URL(string: url))
                }
            } else {
                if let url = self.pokeData?.sprite.backDefault {
                    self.pokeImage.kf.setImage(with: URL(string: url))
                }
            }
        }
        isSelected = !isSelected
    }
    
    //MARK: - Double Tap Gesture
    
    func doubleTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        tapGesture.numberOfTapsRequired = 2
        pokeImage.addGestureRecognizer(tapGesture)
        pokeImage.isUserInteractionEnabled = true
        tapGesture.delaysTouchesBegan = true
    }
    
    @objc func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        delegate?.turnTheImage()
        setupUI()
    }
}
