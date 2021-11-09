//
//  BannerCollectionViewCell.swift
//  Crypto Bot
//
//  Created by Anonymous on 28/09/21.
//

import UIKit

class BannerCollectionViewCell: FullWidthCollectionViewCell {
    @IBOutlet weak var backgroundViewCell: UIView!
    @IBOutlet weak var textLabel: UILabel!
    private var onTap: (() -> Void)?
    
    func setup(text: String, onTap: (() -> Void)? = nil){
        backgroundViewCell.setShadowAndCorner(cornerRadius: 8)
        self.onTap = onTap
        self.textLabel.text = text
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.backgroundViewCell.addGestureRecognizer(tap)
        self.backgroundViewCell.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        onTap?()
    }
    
    func setup(text: NSMutableAttributedString){
        backgroundViewCell.setShadowAndCorner(cornerRadius: 8)
        self.textLabel.attributedText = text
    }
}
