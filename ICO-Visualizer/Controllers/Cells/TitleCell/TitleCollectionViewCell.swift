//
//  TitleCollectionViewCell.swift
//  ICO-visualizer
//
//  Created by Anonymous on 03/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import UIKit

class TitleCollectionViewCell: FullWidthCollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    func setup(title: String){
        self.titleLabel.text = title
    }
}
