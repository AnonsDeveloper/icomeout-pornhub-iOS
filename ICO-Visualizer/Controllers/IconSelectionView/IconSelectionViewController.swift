//
//  IconSelectionViewController.swift
//  ICO-visualizer
//
//  Created by Anonymous on 05/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import UIKit

class IconSelectionViewController: BaseViewController {
    
    private var icons: [String] = ["AlternateAppIconDuet", "AlternateAppIconSphere", "AlternateAppIconArmony"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.setupView(self)
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 45)
            flowLayout.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 12)
            flowLayout.sectionHeadersPinToVisibleBounds = true
            flowLayout.estimatedItemSize = CGSize(
                width: UIScreen.main.bounds.width - 2,
                height: 200
            )
            flowLayout.invalidateLayout()
        }
        
        collectionView.reloadData()
    }
}

extension IconSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:

            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSectionHeaderReusableView.className, for: indexPath) as! TitleSectionHeaderReusableView
            headerView.setupTitle(title: "Select Icon")
            
            return headerView

        case UICollectionView.elementKindSectionFooter:
            return UICollectionReusableView()

        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let selectIconCell = collectionView.dequeueReusableCell(withReuseIdentifier: NavigationButtonCollectionViewCell.className, for: indexPath) as! NavigationButtonCollectionViewCell
        if indexPath.row == 0 {
            selectIconCell.setup(title: "Default Icon") {
                UIApplication.shared.setAlternateIconName(nil) { (error) in }
                self.navigationController?.popViewController(animated: true)
            }
        }
        else{
            selectIconCell.setup(title: self.icons[indexPath.row - 1]) {
                UIApplication.shared.setAlternateIconName(self.icons[indexPath.row - 1]) { (error) in }
                self.navigationController?.popViewController(animated: true)
            }
        }

        return selectIconCell
    }
}

