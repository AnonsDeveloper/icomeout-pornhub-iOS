//
//  WebViewController.swift
//  ICO-visualizer
//
//  Created by Anonymous on 03/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .clear
        return webView
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "back_icon"), for: .normal)
        button.tintColor = ColorLayout.default_orange
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = ColorLayout.default_text
        return label
    }()
    
    public var url: String!
    public var titleText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorLayout.default_background
        
        self.view.addSubview(closeButton)
        closeButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        closeButton.addTarget(self, action: #selector(onCloseTap(_:)), for: .touchUpInside)
        
        self.view.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.closeButton.trailingAnchor, constant: 12).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.closeButton.centerYAnchor).isActive = true
        
        self.view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: self.closeButton.bottomAnchor, constant: 14).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        let url = URL(string: url)!
        webView.load(URLRequest(url: url))
        self.titleLabel.text = self.titleText
    }
    
    @objc func onCloseTap(_ button: UIButton) {
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}
