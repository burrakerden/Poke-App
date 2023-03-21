//
//  DetailViewController.swift
//  PokeApp
//
//  Created by Burak Erden on 20.03.2023.
//

import UIKit
import Kingfisher
import SDWebImage
import SDWebImageSVGCoder

class DetailViewController: UIViewController {
    
    var model = DetailViewModel()
    var pokeDetailUrl = String()
    var pokeDetail: PokeDetail?
    var abilities = [String]()

    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailAbilities: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(url: pokeDetailUrl)
    }
    //MARK: - Get Data
    
    func bind(url: String) {
            self.model.getPokeDetail(url: url)
            self.model.pokeDetailData = {[weak self] value in
                guard let self = self else {return}
                self.pokeDetail = value
                for ability in value.abilities {
                    self.abilities.append((ability.ability?.name)!)
                }
                self.setupUI()
            }
    }
    
    //MARK: - Config
    
    func setupUI() {
        detailName.text = pokeDetail?.name.capitalized
        detailAbilities.text = abilities.map { "• \($0)".capitalized }.joined(separator: "\n")
        
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
        if let url = pokeDetail?.sprite.other?.dreamWorld?.frontDefault {
            detailImage.sd_setImage(with: URL(string: url))
        }
    }
    
}
