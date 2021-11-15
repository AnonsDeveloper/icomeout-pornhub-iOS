//
//  ReelCollectionViewCell.swift
//  ICO-visualizer
//
//  Created by Anonymous on 10/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import SDWebImage

class ReelCollectionViewCell: UICollectionViewCell {
    
     @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var userAvatarView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var verifiedIcon: UIImageView!
    var playerLooper: AVPlayerLooper?
    var playerLayer:AVPlayerLayer!
    var player: AVQueuePlayer?
    
    @IBOutlet weak var tagsLabel: UILabel!
    private var userUrl: URL?
    
    public var index: Int = 0
    
    private var delegate: ReelsViewControllerDelegate?
    
    let likesView: IconTextView = {
        let view = IconTextView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let viewsView: IconTextView = {
        let view = IconTextView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @IBOutlet weak var notContentView: UIView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    private var longPressed: Bool = false
    
    func setupNotContentView(){
        self.notContentView.isUserInteractionEnabled = true
        self.notContentView.isHidden = false
    }
    
    func setup(element: ReelElement, index: Int, playOnStart: Bool, isAudioOn: Bool, delegate: ReelsViewControllerDelegate){
        notContentView.isHidden = true
        self.delegate = delegate
        guard let url = URL(string: element.videoUrl ?? "") else { return }
        
        //progressBar.isHidden = element.duration == nil
        let avatarplaceholder = UIImage(named: "user_icon")
        
        if let avatarUrl = URL(string: element.avatarUrl ?? ""){
            userAvatarView.sd_setImage(with: avatarUrl, completed: {image,_,_,_ in
                if let image = image {
                    self.userAvatarView.image = image
                }
                else{
                    self.userAvatarView.image = avatarplaceholder
                }
            })
        }
        else{
            userAvatarView.image = avatarplaceholder
        }
        usernameLabel.text = "@\(element.username ?? "")"
        
        if element.tags?.count ?? 0 > 0, let joinedString = element.tags?.joined(separator: " #") {
            tagsLabel.text = "#\(joinedString)"
        }
        else{
            tagsLabel.text = ""
        }

        
        self.index = index
        let avPlayer = AVPlayer(url: url);
        avPlayer.volume = 0

        self.playerView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        let playerItem = AVPlayerItem(url: url)
        self.player = AVQueuePlayer(items: [playerItem])
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLooper = AVPlayerLooper(player: self.player!, templateItem: playerItem)
        self.playerView.layer.addSublayer(self.playerLayer!)
        self.player?.volume = isAudioOn ? 1 : 0
        if playOnStart {
            self.player?.play()
        }
        else{
            self.player?.pause()
        }
        
        for recognizer in self.playerView.gestureRecognizers ?? [] {
            playerView.removeGestureRecognizer(recognizer)
        }

        let soundTap = UITapGestureRecognizer(target: self, action: #selector(self.switchSoundTap(_:)))
        playerView.isUserInteractionEnabled = true
        playerView.addGestureRecognizer(soundTap)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed(_:)))
        playerView.addGestureRecognizer(longPressRecognizer)
        
        player?.addPeriodicTimeObserver(forInterval: CMTime(value: CMTimeValue(1), timescale: 2), queue: DispatchQueue.main) {[weak self] (progressTime) in
            let currentTime = Float(CMTimeGetSeconds(progressTime))
            let progress = self?.normalize(val: currentTime, min: 0, max: Float(CMTimeGetSeconds(playerItem.duration))) ?? 0
            self?.progressBar.setProgress(progress, animated: true)
        }
        
        verifiedIcon.isHidden = !(element.verified ?? false)
        
        DispatchQueue.main.async {//After(deadline: .now() + 0.2) {
            self.playerLayer.videoGravity = (element.width ?? 1 < element.height ?? 0) ? .resizeAspectFill : .resizeAspect
            self.userAvatarView.layer.cornerRadius = self.userAvatarView.frame.width / 2
            self.userAvatarView.layer.borderWidth = 1
            self.userAvatarView.layer.borderColor = UIColor.white.cgColor
            self.playerLayer?.frame = self.playerView.frame
            self.bringSubviewToFront(self.userAvatarView)
            self.bringSubviewToFront(self.notContentView)
            self.usernameLabel.isUserInteractionEnabled = true
            self.userAvatarView.isUserInteractionEnabled = true
            for recognizer in self.usernameLabel.gestureRecognizers ?? [] {
                self.usernameLabel.removeGestureRecognizer(recognizer)
            }
            for recognizer in self.userAvatarView.gestureRecognizers ?? [] {
                self.userAvatarView.removeGestureRecognizer(recognizer)
            }
            if let profileUrl = URL(string: element.externalUrl ?? "") {
                self.userUrl = profileUrl
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                
               

                self.usernameLabel.addGestureRecognizer(tap)
                self.userAvatarView.addGestureRecognizer(tap)
            }
        }

        self.contentView.addSubview(self.viewsView)
        viewsView.bottomAnchor.constraint(equalTo: self.userAvatarView.topAnchor, constant: -24).isActive = true
        viewsView.centerXAnchor.constraint(equalTo: self.userAvatarView.centerXAnchor).isActive = true
        viewsView.widthAnchor.constraint(equalToConstant: self.userAvatarView.frame.width - 12).isActive = true
        viewsView.textLabel.text = Double(element.views ?? 0).shortStringRepresentation
        viewsView.imageView.image = UIImage(named: "views_icon")
        
        self.contentView.addSubview(self.likesView)
        likesView.bottomAnchor.constraint(equalTo: self.viewsView.topAnchor, constant: -24).isActive = true
        likesView.centerXAnchor.constraint(equalTo: self.userAvatarView.centerXAnchor).isActive = true
        likesView.widthAnchor.constraint(equalToConstant: self.userAvatarView.frame.width - 12).isActive = true
        likesView.textLabel.text = Double(element.likes ?? 0).shortStringRepresentation
        likesView.imageView.image = UIImage(named: "like_icon")
        
        

    }
    
    func normalize(val: Float, min: Float, max: Float) -> Float {
        return (val - min) / (max - min)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if let url = self.userUrl {
            self.delegate?.openUrl(url: url)
        }
    }
    
    @objc func longPressed(_ sender: UITapGestureRecognizer? = nil) {
        if (sender?.state == .ended || sender?.state == .cancelled || sender?.state == .failed) && self.longPressed {
            self.longPressed = false
            if self.player?.timeControlStatus == .paused {
                self.player?.play()
            }
            return
        }
        if self.player?.timeControlStatus == .playing {
            self.longPressed = true
            self.player?.pause()
        }
    }
    
    @objc func switchSoundTap(_ sender: UITapGestureRecognizer? = nil) {
        self.delegate?.switchSound()
    }
    
}
