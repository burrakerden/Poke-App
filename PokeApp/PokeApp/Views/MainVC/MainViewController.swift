//
//  MainViewController.swift
//  PokeApp
//
//  Created by Burak Erden on 20.03.2023.
//

import UIKit
import Kingfisher

class MainViewController: UIViewController {
    
    var model = ViewModel()
    var pokeNames: [Result]?
    var pokeDetail: PokeDetail?
    var paginationUrl: String?
    
    var pokeUrls = [String]()

    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.red,
          NSAttributedString.Key.font: UIFont(name: "MarkerFelt-Wide", size: 24)!
        ]
        title = "Poke Poke"
        setupUI()
        bindPokeName()
    }
    //MARK: - Config
    
    func setupUI() {
        view.backgroundColor = .systemYellow
        mainCollectionView.register(UINib(nibName: "MainCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MainCollectionViewCell")
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self

    }
    
    //MARK: - Get Data
    
    func bindPokeName() {
        model.getPokeData()
        self.model.pokeNamesData = {[weak self] value in
            guard let self = self else {return}
            if let value = value {
                for i in 0...value.count - 1 {
                    if let url = value[i].url {
                        self.pokeUrls.append(url)
                    }
                }
                self.mainCollectionView.reloadData()
            }
            
        }

    }
}
//MARK: - CollectionView

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pokeUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: MainCollectionViewCell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell else {return UICollectionViewCell()}
            cell.cellConfig(url: pokeUrls[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.pokeDetailUrl = self.pokeUrls[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == pokeUrls.count - 1 {
            model.getNextPageUrl()
            model.pokePaginationUrl = {[weak self] value in
                guard let self = self else {return}
                    self.paginationUrl = value
            }
            
            if let url = paginationUrl {
                model.getNextPageData(url: url)
                model.pokeNamesData = {[weak self] value in
                    guard let self = self else {return}
                    if let value = value {
                        DispatchQueue.main.async {
                            for i in 0...value.count - 1 {
                                if let url = value[i].url {
                                    self.pokeUrls.append(url)
                                }
                            }
                            self.mainCollectionView.reloadData()
                        }

                    }
                }
            }
            
        }
    }
    
}
