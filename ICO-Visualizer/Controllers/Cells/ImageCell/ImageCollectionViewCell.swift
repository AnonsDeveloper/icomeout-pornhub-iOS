//
//  ImageCollectionViewCell.swift
//  ICO-visualizer
//
//  Created by Anonymous on 08/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import Foundation
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func setup(imageUrl: String){
        self.imageView.clipsToBounds = true
        self.imageView.sd_setImage(with: URL(string: imageUrl)!, completed: nil)
    }
}
