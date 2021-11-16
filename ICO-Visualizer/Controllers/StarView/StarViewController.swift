//
//  StarViewController.swift
//  ICO-visualizer
//
//  Created by Anonymous on 04/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import UIKit
import ImageViewer_swift


class StarViewController: BaseViewController {
    
    public enum ContentType {
        case videos
        case images
    }
    
    private var coordinator: StarViewCoordinator!
    
    public var star: Star!
    
    private var defaultImageWidht: CGFloat = UIScreen.main.bounds.width / 2.5
    private var minImageWidht: CGFloat = {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return (UIScreen.main.bounds.width / 5)
        }
        return (UIScreen.main.bounds.width / 2.5) - 70
    }()
    
    private var imageWidhtConstraint: NSLayoutConstraint?
    
    public var videosCompleted: Bool = false
    
    let photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing =  8
        layout.minimumInteritemSpacing =  4
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 85)
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        let cView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cView.translatesAutoresizingMaskIntoConstraints = false
        return cView
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "bookmark_icon"), for: .normal)
        button.setTitle("", for: .normal)
        button.tintColor = ColorLayout.default_grey
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let headerView: UIView = {
        let hView = UIView()
        hView.translatesAutoresizingMaskIntoConstraints = false
        hView.backgroundColor = ColorLayout.default_tab_background
        hView.setShadowAndCorner(cornerRadius: 8)
        return hView
    }()
    
    let starNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = ColorLayout.default_text
        return label
    }()
    
    let starImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let openLinkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "external_icon"), for: .normal)
        button.tintColor = ColorLayout.default_orange
        return button
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = ColorLayout.default_orange
        return button
    }()
    
    private var loadingData: Bool = false
    private var loadingImagesData: Bool = false
    private var stareImageLoaded: UIImage?
    private var contentType: ContentType = .videos
    private var lastVideoError: String?
    private var lastImagesError: String?
    
    override func viewDidLoad() {
        coordinator = StarViewCoordinator(self)
        self.setupView()
        
        if let imageUrl = self.coordinator.star.starThumb {
            self.starImage.sd_setImage(with: URL(string: imageUrl)!, completed: {image,_,_,_ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.starImage.setShadowAndCorner(cornerRadius: self.starImage.frame.width / 2)
                    self.starImage.isUserInteractionEnabled = true
                    self.stareImageLoaded = image
                    self.starImage.setupImageViewer(options: [.theme(.dark), .closeIcon(UIImage(named: "close_icon")!)])
                }
                
            })
            self.starNameLabel.text = self.coordinator.star.starName
        }
        self.loadingData = true
        self.loadingImagesData = true
        collectionView.bottomRefreshControl?.beginRefreshing()
        photosCollectionView.bottomRefreshControl?.beginRefreshing()
        self.refreshBookmarkAspect()
        self.coordinator.loadImages()
        self.coordinator.loadVideos()
    }
    
    func setupView(){
        self.view.addSubview(self.headerView)
        headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        self.headerView.addSubview(starNameLabel)
        starNameLabel.topAnchor.constraint(equalTo: self.headerView.topAnchor, constant: 16).isActive = true
        starNameLabel.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor, constant: 30).isActive = true
        starNameLabel.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor, constant: -30).isActive = true
        
        self.headerView.addSubview(starImage)
        starImage.topAnchor.constraint(equalTo: starNameLabel.bottomAnchor, constant: 16).isActive = true
        starImage.centerXAnchor.constraint(equalTo: self.headerView.centerXAnchor).isActive = true
        self.imageWidhtConstraint = starImage.widthAnchor.constraint(equalToConstant: defaultImageWidht)
        self.imageWidhtConstraint?.isActive = true
        starImage.heightAnchor.constraint(equalTo: starImage.widthAnchor, multiplier: 1).isActive = true
        starImage.bottomAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 30).isActive = true
        starImage.contentMode = .scaleAspectFill
        starImage.clipsToBounds = true
        
        self.headerView.addSubview(openLinkButton)
        openLinkButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        openLinkButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        openLinkButton.bottomAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: -16).isActive = true
        openLinkButton.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor, constant: -16).isActive = true
        openLinkButton.addTarget(self, action: #selector(onOpenTap(_:)), for: .touchUpInside)
        
        self.headerView.addSubview(bookmarkButton)
        bookmarkButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        bookmarkButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        bookmarkButton.bottomAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: -16).isActive = true
        bookmarkButton.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor, constant: 16).isActive = true
        bookmarkButton.addTarget(self, action: #selector(onBookmarkTap(_:)), for: .touchUpInside)
        
        self.headerView.addSubview(closeButton)
        closeButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: self.starNameLabel.centerYAnchor).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor, constant: 16).isActive = true
        closeButton.addTarget(self, action: #selector(onCloseTap(_:)), for: .touchUpInside)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing =  8
        layout.minimumInteritemSpacing =  4
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 85)
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        collectionView.backgroundColor = .clear
        self.view.backgroundColor = ColorLayout.default_background
        
        collectionView.setupView(self)
        
        self.view.addSubview(self.photosCollectionView)
        photosCollectionView.translatesAutoresizingMaskIntoConstraints = false
        photosCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        photosCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        photosCollectionView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 0).isActive = true
        photosCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        photosCollectionView.backgroundColor = .clear
        
        photosCollectionView.setupView(self)
        photosCollectionView.isHidden = true
        
        self.view.bringSubviewToFront(headerView)
        
        let bottomRefreshController = UIRefreshControl()
        bottomRefreshController.tintColor = .white
        collectionView.bottomRefreshControl = bottomRefreshController
        collectionView.bottomRefreshControl?.beginRefreshing()
        
        let imagesBottomRefresh = UIRefreshControl()
        imagesBottomRefresh.tintColor = .white
        photosCollectionView.bottomRefreshControl = imagesBottomRefresh
        photosCollectionView.bottomRefreshControl?.beginRefreshing()
        
        collectionView.backgroundColor = .clear
        self.view.addSubview(self.errorTextLabel)
        errorTextLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        errorTextLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        errorTextLabel.centerYAnchor.constraint(equalTo: self.collectionView.centerYAnchor).isActive = true
        NotificationCenter.default.addObserver(self, selector: #selector(onDidUpdateBookmarks(_:)), name: .didUpdateBookmarks, object: nil)
        self.refreshCollection()
    }
    
    private func refreshCollection(){
        self.collectionView.isHidden = !(self.contentType == ContentType.videos)
        self.photosCollectionView.isHidden = !(self.contentType == ContentType.images)
        if self.photosCollectionView.isHidden == false  {
            if let imageError = self.lastImagesError, self.coordinator.images.count == 0 {
                self.errorTextLabel.isHidden = false
                self.errorTextLabel.text = imageError
            }
            else{
                self.errorTextLabel.isHidden = true
            }
        }
       
        if self.collectionView.isHidden == false {
            if let videoError = self.lastVideoError{
                self.errorTextLabel.isHidden = false
                self.errorTextLabel.text = videoError
            }
            else{
                self.errorTextLabel.isHidden = true
            }
        }
        
    }
    
    @objc func onOpenTap(_ button: UIButton) {
        if let starUrl = self.coordinator.star.starURL {
            let vc = WebViewController()
            vc.url = starUrl
            vc.titleText = "\(self.coordinator.star.starName ?? "") Web Page"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func onDidUpdateBookmarks(_ notification: Notification)
    {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @objc func onBookmarkTap(_ button: UIButton) {
        if UserBookmakrs.shared.checkStarBookmarksCointain(self.star){
            UserBookmakrs.shared.removeStarBookmark(star: self.star)
        }
        else{
            UserBookmakrs.shared.saveStarToBookmark(star: self.star)
        }
        refreshBookmarkAspect()
    }
    
    @objc func onCloseTap(_ button: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func refreshBookmarkAspect(){
        self.bookmarkButton.tintColor = UserBookmakrs.shared.checkStarBookmarksCointain(self.star) ? ColorLayout.default_orange : ColorLayout.default_grey
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension StarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == photosCollectionView {
            (collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = .zero
            if indexPath.row == 0 {
                return CGSize(
                    width: UIScreen.main.bounds.width,
                    height: 60
                )
            }
            let size = (UIScreen.main.bounds.width / 2) - 2
            return CGSize(
                width: size,
                height: size
            )
        }
        return CGSize(
            width: UIScreen.main.bounds.width,
            height: 200
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:

            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSectionHeaderReusableView.className, for: indexPath) as! TitleSectionHeaderReusableView
            let title = "\(self.coordinator.star.starName ?? "") \(collectionView == self.collectionView ? "Videos" : "Photos")"
            headerView.setupTitle(title: title)
            
            return headerView

        case UICollectionView.elementKindSectionFooter:
            return UICollectionReusableView()

        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.photosCollectionView {
            return self.coordinator.images.count + 1
        }
        return (self.coordinator.star.starVideos?.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let navCell = collectionView.dequeueReusableCell(withReuseIdentifier: NavigationButtonCollectionViewCell.className, for: indexPath) as! NavigationButtonCollectionViewCell
            navCell.setup(title: collectionView == self.collectionView ? "Photos" : "Videos") {
                if self.contentType == .videos {
                    self.contentType = .images
                }
                else{
                    self.contentType = .videos
                }
                DispatchQueue.main.async {
                    self.refreshCollection()
                }
            }
            return navCell
        }
        if collectionView == self.photosCollectionView {
            let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.className, for: indexPath) as! ImageCollectionViewCell
            imageCell.setup(imageUrl: self.coordinator.images[indexPath.row - 1])
            imageCell.imageView.setupImageViewer(urls: self.coordinator.images.map({ URL(string: $0)! }), initialIndex: indexPath.row - 1, options: [.theme(.dark), .closeIcon(UIImage(named: "close_icon")!)])
            return imageCell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.className, for: indexPath) as! VideoCollectionViewCell
        if let video = self.coordinator.star.starVideos?[indexPath.row - 1]{
            cell.setup(video: video)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.photosCollectionView {
            let lastElement = self.coordinator.images.count - 1
            if !loadingImagesData && indexPath.row == lastElement {
                photosCollectionView.bottomRefreshControl?.beginRefreshing()
                loadingImagesData = true
                self.coordinator.fetchNextImages()
            }
        }
        else if let videos = self.coordinator.star.starVideos {
            let lastElement = videos.count - 1
            if !loadingData && indexPath.row == lastElement && !videosCompleted {
                collectionView.bottomRefreshControl?.beginRefreshing()
                loadingData = true
                self.coordinator.fetchNextVideos()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        if collectionView == self.collectionView, let video = self.coordinator.star.starVideos?[indexPath.row - 1]{
            VideoPreviewViewController.present(fromView: self, video: video, delegate: self.tabDelegate)
        }

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.imageWidhtConstraint?.constant = self.defaultImageWidht - collectionView.contentOffset.y
        starImage.setShadowAndCorner(cornerRadius: starImage.frame.width / 2)
        if self.imageWidhtConstraint?.constant ?? 0 < minImageWidht {
            self.imageWidhtConstraint?.constant = minImageWidht
        }
    }
}

extension StarViewController: StarViewControllerDelegate{
    
    func reloadView(_ message: String? = nil) {
        DispatchQueue.main.async {
            self.loadingData = false
            self.collectionView.bottomRefreshControl?.endRefreshing()
            self.starImage.setShadowAndCorner(cornerRadius: self.starImage.frame.width / 2)
            self.collectionView.reloadData()
            if let message = message {
                self.setupErrorMessage(message: message)
            }
            else{
                self.errorTextLabel.isHidden = true
            }
            
        }
    }
    
    func getStar() -> Star {
        return self.star
    }
    func setupErrorMessage(message: String){
        if self.contentType == .videos {
            self.errorTextLabel.isHidden = false
            self.errorTextLabel.text = message
        }
        self.lastVideoError = message
    }
    
    func reloadImages(_ message: String?){
        DispatchQueue.main.async {
            self.loadingImagesData = false
            self.photosCollectionView.reloadData()
            self.lastImagesError = message
            self.photosCollectionView.bottomRefreshControl?.endRefreshing()
            if let message = message, self.contentType == .images && self.coordinator.images.count == 0 {
                self.errorTextLabel.isHidden = false
                self.errorTextLabel.text = message
            }
        }
    }
}

