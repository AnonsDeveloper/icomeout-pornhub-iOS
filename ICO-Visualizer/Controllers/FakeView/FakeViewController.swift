//
//  FakeViewController.swift
//  ICO-visualizer
//
//  Created by Anonymous on 07/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import UIKit

class FakeViewController: UIViewController {
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(
            width: UIScreen.main.bounds.width - 2,
            height: 200
        )
        let cView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cView.translatesAutoresizingMaskIntoConstraints = false

        cView.register(LeftImageCaptionTableViewCell.self, forCellWithReuseIdentifier: LeftImageCaptionTableViewCell.className)
        return cView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "Pokemons"
        label.textColor = ColorLayout.default_text
        return label
    }()
    
    private var pokemonList: [PokemonListResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 24).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor).isActive = true
        
        self.view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 12).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor).isActive = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        APIService.shared.fetchPokemons { response in
            switch response {
            case .success(let list):
                self.pokemonList = list.results
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension FakeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pokemonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LeftImageCaptionTableViewCell.className, for: indexPath) as! LeftImageCaptionTableViewCell
        cell.setup(imageUrl: self.pokemonList[indexPath.row].imageUrl, caption: self.pokemonList[indexPath.row].name)
        return cell
    }
    
    
}
