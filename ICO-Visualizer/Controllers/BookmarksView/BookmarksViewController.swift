//
//  BookmarksViewController.swift
//  ICO-visualizer
//
//  Created by Anonymous on 05/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import UIKit

class BookmarksViewController: BaseViewController {
    
    private var videoBookmarks: [Video] {
        return UserBookmakrs.shared.getVideosBookmarks().reversed()
    }
    
    private var starsBookmarks: [Star] {
        return UserBookmakrs.shared.getStarsBookmarks().reversed()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.setupView(self)
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
//            flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 45)
//            flowLayout.sectionHeadersPinToVisibleBounds = true
//            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

            flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            flowLayout.sectionHeadersPinToVisibleBounds = true
            flowLayout.estimatedItemSize = CGSize(
                width: UIScreen.main.bounds.width - 2,
                height: 200
            )
            flowLayout.invalidateLayout()
        }
        
        collectionView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(onDidUpdateBookmarks(_:)), name: .didUpdateBookmarks, object: nil)
        checkIfHaveBookmarks()
    }
    
    private func checkIfHaveBookmarks(){
        self.errorTextLabel.isHidden = !(self.videoBookmarks.count == 0 && self.starsBookmarks.count == 0)
        self.errorTextLabel.text = "You haven't added any videos or pornstars to your bookmarks yet :("
    }
    
    @objc func onDidUpdateBookmarks(_ notification: Notification)
    {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.checkIfHaveBookmarks()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension BookmarksViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if indexPath.section == 0 {
//            return UICollectionViewFlowLayout.automaticSize
//        }
//        else{
//            return CGSize(width: UIScreen.main.bounds.width - 30, height: 200)
//        }
//    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:

            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSectionHeaderReusableView.className, for: indexPath) as! TitleSectionHeaderReusableView
            if indexPath.section == 0 {
                headerView.setupTitle(title: self.starsBookmarks.count == 0 ? "" : "Pornstars")
            }
            else{
                headerView.setupTitle(title: self.videoBookmarks.count == 0 ? "" : "Videos")
            }
            
            
            return headerView

        case UICollectionView.elementKindSectionFooter:
            return UICollectionReusableView()

        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.starsBookmarks.count > 0 ? 1 : 0
        }
        return self.videoBookmarks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let starCell = collectionView.dequeueReusableCell(withReuseIdentifier: StarsCarouselCollectionViewCell.className, for: indexPath) as! StarsCarouselCollectionViewCell
            starCell.setup(stars: self.starsBookmarks, onItemSelect: { index in
                let vc = StarViewController()
                vc.tabDelegate = self.tabDelegate
                vc.star = self.starsBookmarks[index.row]
                self.navigationController?.pushViewController(vc, animated: true)
            })
            return starCell
        }
        let videoCell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.className, for: indexPath) as! VideoCollectionViewCell
        videoCell.setup(video: self.videoBookmarks[indexPath.row])
        return videoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            VideoPreviewViewController.present(fromView: self, video: self.videoBookmarks[indexPath.row], delegate: self.tabDelegate)
        }
    }
}

