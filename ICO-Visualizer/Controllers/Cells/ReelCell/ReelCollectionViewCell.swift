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
    
    func setup(gif: HorizontalGIF, index: Int, playOnStart: Bool, isAudioOn: Bool, delegate: ReelsViewControllerDelegate){
        notContentView.isHidden = true
        self.delegate = delegate
        guard let url = URL(string: gif.urls.hd) else { return }
        
        if let avatarUrl = URL(string: gif.user.profileImageURL ?? ""){
            userAvatarView.isHidden = false
            userAvatarView.sd_setImage(with: avatarUrl, completed: nil)
        }
        else{
            userAvatarView.isHidden = true
        }
        usernameLabel.text = "@\(gif.user.username)"
        

        
        self.index = index
        let avPlayer = AVPlayer(url: url);
        avPlayer.volume = 0
//        playerView?.playerLayer.player = avPlayer;
//        playerView?.playerLayer.player?.play()
//
//
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
        //self.playerView.backgroundColor = .clear
        let soundTap = UITapGestureRecognizer(target: self, action: #selector(self.switchSoundTap(_:)))
        playerView.isUserInteractionEnabled = true
        playerView.addGestureRecognizer(soundTap)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed(_:)))
        playerView.addGestureRecognizer(longPressRecognizer)
        
        player?.addPeriodicTimeObserver(forInterval: CMTime(value: CMTimeValue(1), timescale: 2), queue: DispatchQueue.main) {[weak self] (progressTime) in
           // self?.playerView.backgroundColor = gif.avgColor.hexStringToUIColor()
            let currentTime = Float(CMTimeGetSeconds(progressTime))
            let progress = self?.normalize(val: currentTime, min: 0, max: Float(gif.duration)) ?? 0
            self?.progressBar.setProgress(progress, animated: true)
        }
        
        verifiedIcon.isHidden = !gif.user.verified
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            self.userAvatarView.layer.cornerRadius = self.userAvatarView.frame.width / 2
            self.userAvatarView.layer.borderWidth = 1
            self.userAvatarView.layer.borderColor = UIColor.white.cgColor
          //  self.userAvatarView.layer.
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
            if let profileUrl = URL(string: gif.user.profileURL) {
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
        viewsView.textLabel.text = Double(gif.views).shortStringRepresentation
        viewsView.imageView.image = UIImage(named: "views_icon")
        
        self.contentView.addSubview(self.likesView)
        likesView.bottomAnchor.constraint(equalTo: self.viewsView.topAnchor, constant: -24).isActive = true
        likesView.centerXAnchor.constraint(equalTo: self.userAvatarView.centerXAnchor).isActive = true
        likesView.widthAnchor.constraint(equalToConstant: self.userAvatarView.frame.width - 12).isActive = true
        likesView.textLabel.text = Double(gif.likes).shortStringRepresentation
        likesView.imageView.image = UIImage(named: "like_icon")
        
        

    }
    
    func normalize(val: Float, min: Float, max: Float) -> Float {
        //function(val, max, min) { return (val - min) / (max - min); }
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

class PlayerView: UIView {
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self;
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer;
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player;
        }
        set {
            playerLayer.player = newValue;
        }
    }
}
