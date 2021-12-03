//
//  ReelSourceSelectionViewController.swift
//  ICO-visualizer
//
//  Created by Anonymous on 16/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import UIKit

class ReelSourceSelectionViewController: BaseViewController {
    
    private let sources: [APIService.ReelSource] = [.redgifs, .xxxtik, .tikporn]
    
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

extension ReelSourceSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:

            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSectionHeaderReusableView.className, for: indexPath) as! TitleSectionHeaderReusableView
            headerView.setupTitle(title: "Select Reel Data Source")
            
            return headerView

        case UICollectionView.elementKindSectionFooter:
            return UICollectionReusableView()

        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let selectIconCell = collectionView.dequeueReusableCell(withReuseIdentifier: NavigationButtonCollectionViewCell.className, for: indexPath) as! NavigationButtonCollectionViewCell
        if indexPath.row == 0 {
            selectIconCell.setup(title: "Redgifs") {
                UserPreferences.shared.reelSource = self.sources[indexPath.row]
                NotificationCenter.default.post(name: .didChangeReelPreference, object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
        else if indexPath.row == 1 {
            selectIconCell.setup(title: "XXX Tik") {
                UserPreferences.shared.reelSource = self.sources[indexPath.row]
                NotificationCenter.default.post(name: .didChangeReelPreference, object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
        else if indexPath.row == 2 {
            selectIconCell.setup(title: "Tik Porn") {
                UserPreferences.shared.reelSource = self.sources[indexPath.row]
                NotificationCenter.default.post(name: .didChangeReelPreference, object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
        return selectIconCell
    }
}

