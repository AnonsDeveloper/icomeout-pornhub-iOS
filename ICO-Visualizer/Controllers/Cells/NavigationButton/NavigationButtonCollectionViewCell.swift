//
//  NavigationButtonViewController.swift
//  ICO-visualizer
//
//  Created by Anonymous on 28/09/21.
//

import UIKit

class NavigationButtonCollectionViewCell: FullWidthCollectionViewCell {
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var titleView: UILabel!
    
    private var tapAction: (() -> Void)?
    
    func setup(title: String, onTap: (() -> Void)?){
        self.titleView.text = title
        self.tapAction = onTap
        tapView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tapView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.tapAction?()
    }
}
