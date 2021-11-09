//
//  PokemonListTableViewCell.swift
//  pokemon-visualizer
//
//  Created by Anonymous on 26/10/21.
//

import UIKit
import SDWebImage

class LeftImageCaptionTableViewCell : FullWidthCollectionViewCell {

    let background: UIView = {
        let bView = UIView()
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.backgroundColor = ColorLayout.default_tab_background
        bView.setShadowAndCorner(cornerRadius: 8)
        return bView
    }()
    
    let avatarView: UIImageView = {
        let iView = UIImageView()
        iView.translatesAutoresizingMaskIntoConstraints = false
        return iView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.font = FontLayout.medium16
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(imageUrl: String?, caption: String?){
        self.nameLabel.text = caption
        self.avatarView.sd_setImage(with: URL(string: imageUrl ?? ""), completed: nil)
    }
    
    private func setupView(){
        self.contentView.addSubview(background)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.background.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15).isActive = true
        self.background.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15).isActive = true
        self.background.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 30).isActive = true
        self.background.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -30).isActive = true
        
        self.background.addSubview(self.avatarView)
        self.avatarView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.avatarView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.avatarView.topAnchor.constraint(equalTo: self.background.topAnchor, constant: 8).isActive = true
        self.avatarView.leadingAnchor.constraint(equalTo: self.background.leadingAnchor, constant: 8).isActive = true
        self.avatarView.bottomAnchor.constraint(equalTo: self.background.bottomAnchor, constant: -8).isActive = true
        
        self.background.addSubview(self.nameLabel)

        self.nameLabel.leadingAnchor.constraint(equalTo: self.avatarView.trailingAnchor, constant: 8).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: self.avatarView.topAnchor).isActive = true
    }
}
