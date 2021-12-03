//
//  VideoPreviewViewController.swift
//  ICO-visualizer
//
//  Created by Anonymous on 03/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import UIKit
import WebKit

class VideoPreviewViewController: UIViewController {
    
    static func present(fromView: UIViewController, video: Video, delegate: TabBarViewControllerDelegate?){
        let vc1 = VideoPreviewViewController()
        vc1.video = video
        vc1.delegate = delegate
        if UIDevice.current.userInterfaceIdiom == .pad {
            fromView.present(vc1, animated: true, completion: nil)
        }
        else{
            let vc = CustomActivityViewController(controller: vc1)
            fromView.present(vc, animated: true, completion: nil)
        }

    }
    
    public var video: Video!
    public var delegate: TabBarViewControllerDelegate?
    
    let videoPlayer: WKWebView = {
       let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.setShadowAndCorner(cornerRadius: 8)
        webView.backgroundColor = .clear
        return webView
    }()
    
    let loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startAnimating()
        view.isHidden = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        label.numberOfLines = 0
        label.textColor = ColorLayout.default_text
        return label
    }()
    
    let categoriesLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Regular", size: 8)
        label.textColor = ColorLayout.default_grey
        label.numberOfLines = 2
        return label
    }()
    
    let starsLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Regular", size: 10)
        label.textColor = ColorLayout.default_text
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let viewsLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Semibold", size: 12.0)
        label.textColor = ColorLayout.default_grey
        label.numberOfLines = 2
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "close_icon"), for: .normal)
        button.tintColor = ColorLayout.default_orange
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "bookmark_icon"), for: .normal)
        button.setTitle("", for: .normal)
        button.tintColor = ColorLayout.default_grey
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let previewDurationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = ""
        label.textColor = ColorLayout.default_text
        label.font = UIFont(name: "HelveticaNeue-Regular", size: 13.0)
        label.textAlignment = .right
        return label
    }()
    
    let gradientView: UIView = {
        let view = UIView()
        view.alpha = 0.7
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let gradient: CAGradientLayer = {
        return CAGradientLayer()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorLayout.default_background
        
        self.view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12).isActive = true
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)

        self.view.addSubview(bookmarkButton)
        bookmarkButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        bookmarkButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12).isActive = true
        bookmarkButton.addTarget(self, action: #selector(onBookmarkTap), for: .touchUpInside)
        
        
        self.view.addSubview(videoPlayer)
        videoPlayer.topAnchor.constraint(equalTo: self.closeButton.bottomAnchor, constant: 20).isActive = true
        videoPlayer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12).isActive = true
        videoPlayer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12).isActive = true
        videoPlayer.heightAnchor.constraint(equalTo: videoPlayer.widthAnchor, multiplier: 315/560).isActive = true
        
        self.view.addSubview(loadingIndicator)
        loadingIndicator.centerYAnchor.constraint(equalTo: self.videoPlayer.centerYAnchor).isActive = true
        loadingIndicator.centerXAnchor.constraint(equalTo: self.videoPlayer.centerXAnchor).isActive = true
        
        self.view.addSubview(self.gradientView)
        gradientView.bottomAnchor.constraint(equalTo: self.videoPlayer.bottomAnchor).isActive = true
        gradientView.trailingAnchor.constraint(equalTo: self.videoPlayer.trailingAnchor).isActive = true
        gradientView.leadingAnchor.constraint(equalTo: self.videoPlayer.leadingAnchor).isActive = true
        gradientView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.gradient.frame = self.gradientView.bounds
            self.gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]

            self.gradientView.layer.insertSublayer(self.gradient, at: 0)
        }
        
        self.view.addSubview(previewDurationLabel)
        previewDurationLabel.trailingAnchor.constraint(equalTo: self.videoPlayer.trailingAnchor, constant: -7).isActive = true
        previewDurationLabel.bottomAnchor.constraint(equalTo: self.videoPlayer.bottomAnchor, constant: -7).isActive = true
        
        self.view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: self.videoPlayer.bottomAnchor, constant: 12).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12).isActive = true
        
        self.view.addSubview(viewsLabel)
        viewsLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 12).isActive = true
        viewsLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12).isActive = true
        viewsLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12).isActive = true
        
       
        
        self.view.addSubview(starsLabel)
        starsLabel.topAnchor.constraint(equalTo: self.viewsLabel.bottomAnchor, constant: 12).isActive = true
        starsLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12).isActive = true

        self.view.addSubview(categoriesLabel)
        categoriesLabel.topAnchor.constraint(equalTo: self.starsLabel.bottomAnchor, constant: 12).isActive = true
        categoriesLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12).isActive = true
        categoriesLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12).isActive = true
        videoPlayer.isHidden = true
        self.fillData()
    }
    
    @objc func onBookmarkTap(_ button: UIButton) {
        if UserBookmakrs.shared.checkVideoBookmarksCointain(self.video){
            UserBookmakrs.shared.removeVideoBookmark(video: self.video)
        }
        else{
            UserBookmakrs.shared.saveVideoToBookmark(video: self.video)
        }
        refreshBookmarkAspect()
    }
    
    private func refreshBookmarkAspect(){
        self.bookmarkButton.tintColor = UserBookmakrs.shared.checkVideoBookmarksCointain(self.video) ? ColorLayout.default_orange : ColorLayout.default_grey
    }
    
    @objc func closeAction(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func fillData(){
        if UIDevice.current.userInterfaceIdiom == .pad {
            videoPlayer.configuration.allowsInlineMediaPlayback = false
            videoPlayer.customUserAgent = "Mozilla/5.0 (iPad; CPU iPhone OS 13_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko)"
            gradientView.isHidden = true
        }
        
        if let videoId = self.video.videoID{
            videoPlayer.navigationDelegate = self
            let html = """
                        <iframe src="https://www.pornhub.com/embed/\(videoId)" frameborder="0" width="100%" height="100%" scrolling="no" allowfullscreen></iframe>
                        """
            videoPlayer.loadHTMLString(html, baseURL: nil)
        }

        titleLabel.text = video.title
        if let categories = self.video.categories?.map({ $0.category! }) {
            self.categoriesLabel.text = categories.joined(separator: ", ")
        }
        if let stars = self.video.pornstars?.map({ $0.pornstarName! }), stars.count > 0 {
            var text = ""
            text += stars.joined(separator: ", ")
            self.starsLabel.attributedText = NSAttributedString(string: text)
            self.starsLabel.isUserInteractionEnabled = true
            self.starsLabel.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        }
        var viewsText = ""
        if let views = self.video.views {
            let largeNumber = Double(views)
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber)) ?? String(views)
            viewsText += "\(formattedNumber.replacingOccurrences(of: ".", with: " ")) Views"
        }
        if let rating = self.video.rating?.ratingString, let ratingDouble = Double(rating) {
            viewsText += " | \(String(format: "%.0f", ratingDouble))%"
        }
        if let date = self.video.publishDate?.toDate()?.timeAgo(){
            viewsText += " | \(date)"
        }
        if let duration = self.video.duration {
            previewDurationLabel.text = duration
        }
        self.viewsLabel.text = viewsText
        self.refreshBookmarkAspect()
    }
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        if let stars = self.video.pornstars?.map({ $0.pornstarName! }){
            for item in stars {
                if let starRange = (self.starsLabel.text ?? "").range(of: item)?.nsRange(in: self.starsLabel.text ?? ""){
                    if gesture.didTapAttributedTextInLabel(label: self.starsLabel, inRange: starRange) {
                        self.dismiss(animated: true) {
                            UserPreferences.shared.starToFind = item
                            self.delegate?.setPage(index: 2)
                        }
                    }
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
}


extension RangeExpression where Bound == String.Index  {
    func nsRange<S: StringProtocol>(in string: S) -> NSRange { .init(self, in: string) }
}

extension VideoPreviewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.isHidden = false
        loadingIndicator.isHidden = true
    }
}


class CustomActivityViewController: UIActivityViewController {

    private let controller: UIViewController!

    required init(controller: UIViewController) {
        self.controller = controller
        super.init(activityItems: [], applicationActivities: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let subViews = self.view.subviews
        for view in subViews {
            view.removeFromSuperview()
        }

        self.addChild(controller)
        self.view.addSubview(controller.view)
    }

}
