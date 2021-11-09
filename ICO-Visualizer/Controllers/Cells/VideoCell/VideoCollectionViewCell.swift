//
//  VideoCollectionViewCell.swift
//  ICO-visualizer
//
//  Created by Anonymous on 03/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import UIKit
import SDWebImage

class VideoCollectionViewCell: FullWidthCollectionViewCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var bookmarkIcon: UIImageView!
    
    let gradient: CAGradientLayer = {
        return CAGradientLayer()
    }()
    
    func setup(video: Video){
        backgroundCellView.setShadowAndCorner(cornerRadius: 8)
        if let thumbUrl = video.thumb{
            thumbImageView.sd_setImage(with: URL(string: thumbUrl)!, completed: nil)
        }
        titleLabel.text = video.title
        viewsLabel.text = ""
        var viewsText = ""
        if let views = video.views {
            viewsText += "\(Double(views).shortStringRepresentation) Views"
        }
        if let rating = video.rating?.ratingString, let ratingDouble = Double(rating) {
            viewsText += " | \(String(format: "%.0f", ratingDouble))%"
        }
        self.viewsLabel.text = viewsText
        self.starLabel.text = video.pornstars?.first?.pornstarName ?? ""
        self.durationLabel.text = video.duration ?? ""
        bookmarkIcon.isHidden = !UserBookmakrs.shared.checkVideoBookmarksCointain(video)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.gradient.frame = self.gradientView.bounds
            self.gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]

            self.gradientView.layer.insertSublayer(self.gradient, at: 0)
        }
    }
}
