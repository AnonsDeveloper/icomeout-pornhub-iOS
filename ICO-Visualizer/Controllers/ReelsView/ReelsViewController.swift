//
//  ReelsViewController.swift
//  ICO-visualizer
//
//  Created by Anonymous on 10/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import Foundation
import UIKit

class ReelsViewController: BaseViewController {
    
    private var coordinator: ReelsViewCoordinator!

    private var currentPage: Int = 0
    
    let audioImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startAnimating()
        view.isHidden = false
        return view
    }()
    
    
    
    override func viewDidLoad() {
        self.view.addSubview(loadingView)
        loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        super.viewDidLoad()
        self.coordinator = ReelsViewCoordinator(self)
        
        self.collectionView.setupView(self)
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.bounces = false
        self.coordinator.load()
        
        self.view.addSubview(audioImageView)
        audioImageView.centerYAnchor.constraint(equalTo: self.collectionView.centerYAnchor).isActive = true
        audioImageView.centerXAnchor.constraint(equalTo: self.collectionView.centerXAnchor).isActive = true
        audioImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        audioImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        audioImageView.tintColor = ColorLayout.default_grey
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidPressVolumeUp(_:)), name: .didPressVolumeUp, object: nil)
    }
    
    @objc func onDidPressVolumeUp(_ notification: Notification){
        if UserPreferences.shared.isAudioOn == false{
            self.switchSound()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        for cell in self.collectionView.visibleCells {
            if let videoCell = (cell as? ReelCollectionViewCell){
                videoCell.player?.pause()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for cell in self.collectionView.visibleCells {
            if let videoCell = (cell as? ReelCollectionViewCell){
                if videoCell.index == currentPage {
                    videoCell.player?.play()
                }
                else{
                    videoCell.player?.pause()
                }
            }
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
}

extension ReelsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.coordinator.videos.count == 0 ? 0 : (self.coordinator.videos.count + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReelCollectionViewCell.className, for: indexPath) as! ReelCollectionViewCell
        if indexPath.row == self.coordinator.videos.count {
            cell.setupNotContentView()
        }
        else{
            cell.setup(gif: self.coordinator.videos[indexPath.row], index: indexPath.row, playOnStart: indexPath.row == 0, isAudioOn: UserPreferences.shared.isAudioOn, delegate: self)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let videoCell = (cell as? ReelCollectionViewCell) else { return }
        videoCell.player?.play()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let videoCell = (cell as? ReelCollectionViewCell) else { return }
        videoCell.player?.pause()
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.y
        let w = scrollView.bounds.size.height
        self.currentPage = Int(ceil(x/w))
        for cell in self.collectionView.visibleCells {
            if let videoCell = (cell as? ReelCollectionViewCell){
                if videoCell.index == currentPage {
                    videoCell.player?.play()
                }
                else{
                    videoCell.player?.pause()
                }
            }
        }
    }
}

extension ReelsViewController: ReelsViewControllerDelegate {
    func reloadView() {
        let layout = self.collectionView.collectionViewLayout
        if let flowLayout = layout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(
                width:  self.collectionView.frame.width,
                height:  self.collectionView.frame.height
            )
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        })
    }
    
    func openUrl(url: URL) {
        let alert = UIAlertController(title: "Alert", message: "You will ber redirect to external link\nOpen: \(url.absoluteString)?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open", style: .default, handler: { action in
            if UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func switchSound() {
        if UserPreferences.shared.isAudioOn {
            audioImageView.image = UIImage(named: "audio_off")
            UserPreferences.shared.isAudioOn = false
            for cell in self.collectionView.visibleCells {
                if let videoCell = (cell as? ReelCollectionViewCell){
                    videoCell.player?.volume = 0
                }
            }
        }
        else{
            UserPreferences.shared.isAudioOn = true
            audioImageView.image = UIImage(named: "audio_on")
            for cell in self.collectionView.visibleCells {
                if let videoCell = (cell as? ReelCollectionViewCell){
                    videoCell.player?.volume = 1
                }
            }
        }
        audioImageView.isHidden = false
        audioImageView.alpha = 1
        UIView.animate(withDuration: 1) {
            self.audioImageView.alpha = 0
        } completion: { completed in
            
        }
    }
}
