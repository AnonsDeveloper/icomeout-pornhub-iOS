//
//  StarsCarouselCollectionViewCell.swift
//  ICO-visualizer
//
//  Created by Anonymous on 05/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import UIKit

class StarsCarouselCollectionViewCell: FullWidthCollectionViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var stars: [Star] = []
    
    private var onItemSelect: ((IndexPath) -> Void)?
    
    func setup(stars: [Star], onItemSelect: @escaping (IndexPath) -> Void){
        self.stars = stars
        self.onItemSelect = onItemSelect
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            flowLayout.scrollDirection = .horizontal
           //flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 45)
           //flowLayout.sectionHeadersPinToVisibleBounds = true
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

//            flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 45)
//            flowLayout.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 12)
//            flowLayout.sectionHeadersPinToVisibleBounds = true
//            flowLayout.estimatedItemSize = CGSize(
//                width: UIScreen.main.bounds.width - 30,
//                height: 200
//            )
//            flowLayout.invalidateLayout()
        }
        collectionView.register(cellType: StarCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.reloadData()
    }
}

extension StarsCarouselCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.stars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let starCell = collectionView.dequeueReusableCell(withReuseIdentifier: StarCollectionViewCell.className, for: indexPath) as! StarCollectionViewCell
        starCell.setup(star: self.stars[indexPath.row])
        return starCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.onItemSelect?(indexPath)
    }
}
