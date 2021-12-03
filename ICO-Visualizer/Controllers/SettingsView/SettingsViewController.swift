//
//  SettingsViewController.swift
//  ICO-visualizer
//
//  Created by Anonymous on 05/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {
    
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

extension SettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:

            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSectionHeaderReusableView.className, for: indexPath) as! TitleSectionHeaderReusableView
            headerView.setupTitle(title: "Settings")
            
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
        let faceIdToggle = collectionView.dequeueReusableCell(withReuseIdentifier: ToggleCollectionViewCell.className, for: indexPath) as! ToggleCollectionViewCell
        faceIdToggle.setup(title: "Face ID", isOn: UserPreferences.shared.faceIdEnabled) { isOn in
            UserPreferences.shared.faceIdEnabled = isOn
        }
        if indexPath.row == 1{
            let iconSelectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: NavigationButtonCollectionViewCell.className, for: indexPath) as! NavigationButtonCollectionViewCell
            iconSelectionCell.setup(title: "Select App Icon") {
                let iconSelectionVc = IconSelectionViewController()
                self.navigationController?.pushViewController(iconSelectionVc, animated: true)
            }
            return iconSelectionCell
        }
        if indexPath.row == 2{
            let iconSelectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: NavigationButtonCollectionViewCell.className, for: indexPath) as! NavigationButtonCollectionViewCell
            iconSelectionCell.setup(title: "Setup a fake PIN") {
                let pinVc = PinSetupViewController()
                pinVc.pinType = .fakePin
                self.navigationController?.pushViewController(pinVc, animated: true)
            }
            return iconSelectionCell
        }
        if indexPath.row == 3{
            let iconSelectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: NavigationButtonCollectionViewCell.className, for: indexPath) as! NavigationButtonCollectionViewCell
            iconSelectionCell.setup(title: "Select Reels source") {
                let pinVc = ReelSourceSelectionViewController()
                self.navigationController?.pushViewController(pinVc, animated: true)
            }
            return iconSelectionCell
        }
        return faceIdToggle
    }
}
