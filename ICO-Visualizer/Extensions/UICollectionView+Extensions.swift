//
//  UICollectionView+Extensions.swift
//  Circular
//
//  Created by Anonymous on 15/07/2020.
//  Copyright © 2020 Anonymous. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func register(cellType cell: UICollectionViewCell.Type) {
        self.register(UINib(nibName: cell.className, bundle: nil), forCellWithReuseIdentifier: cell.className)
    }
    
    func setupView<T>(_ fromView: T) where T: UICollectionViewDataSource, T: UICollectionViewDelegate {
        self.delegate = fromView
        self.dataSource = fromView
        let layout = self.collectionViewLayout
        if let flowLayout = layout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(
                width: UIScreen.main.bounds.width,
                height: 200
            )
        }
        self.register(cellType: VideoCollectionViewCell.self)
        self.register(cellType: TitleCollectionViewCell.self)
        self.register(cellType: StarCollectionViewCell.self)
        self.register(cellType: BannerCollectionViewCell.self)
        self.register(cellType: NavigationButtonCollectionViewCell.self)
        self.register(cellType: ToggleCollectionViewCell.self)
        self.register(cellType: StarsCarouselCollectionViewCell.self)
        self.register(cellType: ImageCollectionViewCell.self)
        self.register(LeftImageCaptionTableViewCell.self, forCellWithReuseIdentifier: LeftImageCaptionTableViewCell.className)
        self.register(TitleSectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleSectionHeaderReusableView.className)
    }
}
