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
    
    //MARK: - Flip Animation Enums
    
    private enum Side {
        case head
        case tail
    }
    
    //MARK: - Properties

    var model = DetailViewModel()
    var pokeDetailUrl = String()
    var pokeDetail: PokeDetail?
    var abilities = [String]()
    private var currentSide: Side = .head

    //MARK: - IBOutlets

    @IBOutlet weak var detailType: UILabel!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailAbilities: UILabel!
    @IBOutlet weak var detailHp: UILabel!
    @IBOutlet weak var detailAttack: UILabel!
    @IBOutlet weak var detailDef: UILabel!
    @IBOutlet weak var detailHpLabel: UILabel!
    @IBOutlet weak var detailAttackLabel: UILabel!
    @IBOutlet weak var detailDefLabel: UILabel!
    
    @IBOutlet weak var detailPokeFront: UIImageView!
    @IBOutlet weak var detailPokeBack: UIImageView!
    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bind(url: pokeDetailUrl)
        tapGesture()
        hiddenUIElements(true)
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
        detailName.text = pokeDetail?.name.uppercased()
        detailAbilities.text = "Abilities: \n\(abilities.map { "• \($0)".capitalized }.joined(separator: "\n"))"
        detailType.text = pokeDetail?.types?[0].type?.name?.capitalized
        detailHp.text = String(pokeDetail?.stats?[0].baseStat ?? 0)
        detailAttack.text = String(pokeDetail?.stats?[1].baseStat ?? 0)
        detailDef.text = String(pokeDetail?.stats?[2].baseStat ?? 0)
        
        // Svg Image Download
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
        if let url = pokeDetail?.sprite.other?.dreamWorld?.frontDefault {
            detailImage.sd_setImage(with: URL(string: url))
        }
    }
    
    func hiddenUIElements(_ status: Bool) {
        [detailType, detailName, detailImage, detailAbilities, detailHp, detailAttack, detailDef, detailHpLabel, detailAttackLabel, detailDefLabel].forEach { $0.isHidden = status }
    }
    
    // Tap Gesture for Flip Animation
    func tapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapContainer))
        view.addGestureRecognizer(tapGesture)
    }
    
    // Selector for Tap Gesture
    @objc func tapContainer() {
        switch currentSide {
        case .head:
            UIView.transition(from: detailPokeBack,
                              to: detailPokeFront,
                              duration: 1,
                              options: [.transitionFlipFromRight, .showHideTransitionViews],
                              completion: nil)
            currentSide = .tail
            hiddenUIElements(false)
        case .tail:
            UIView.transition(from: detailPokeFront,
                              to: detailPokeBack,
                              duration: 1,
                              options: [.transitionFlipFromLeft, .showHideTransitionViews],
                              completion: nil)
            currentSide = .head
            hiddenUIElements(true)
        }
    }
    
}
