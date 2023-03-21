//
//  MainViewController.swift
//  PokeApp
//
//  Created by Burak Erden on 20.03.2023.
//

import UIKit
import Kingfisher

class MainViewController: UIViewController {
    
    //MARK: - Properties
    
    var model = ViewModel()
    var paginationUrl: String?
    var pokeUrls = [String]()
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindPokeName()
    }
    //MARK: - Config
    
    func setupUI() {
        // Collection View Setup
        mainCollectionView.register(UINib(nibName: "MainCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MainCollectionViewCell")
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.isUserInteractionEnabled = true
        
        // Navigation Controller Setup
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "MarkerFelt-Wide", size: 24)!]
        title = "Poke Poke"
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .systemRed
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
//MARK: - CollectionView Delegate and DataSource

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pokeUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: MainCollectionViewCell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell else {return UICollectionViewCell()}
            cell.cellConfig(url: pokeUrls[indexPath.row])
        cell.delegate = self
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if let url = self.paginationUrl {
                    self.model.getNextPageData(url: url)
                    self.model.pokeNamesData = {[weak self] value in
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
    
}

//MARK: - MainViewController Extension

extension MainViewController: GestureProtocol {
    func turnTheImage() {
    }
}
