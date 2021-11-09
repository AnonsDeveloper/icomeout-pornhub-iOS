//
//  StarCollectionViewCell.swift
//  ICO-visualizer
//
//  Created by Anonymous on 03/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import UIKit
import SDWebImage

class StarCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var bookmarkIcon: UIImageView!
    
    func setup(star: Star){
        backgroundCellView.setShadowAndCorner(cornerRadius: 8)
        if let thumbUrl = star.starThumb{
            thumbImageView.sd_setImage(with: URL(string: thumbUrl)!, completed: nil)
        }
        titleLabel.text = star.starName
        bookmarkIcon.isHidden = !UserBookmakrs.shared.checkStarBookmarksCointain(star)
    }
}
