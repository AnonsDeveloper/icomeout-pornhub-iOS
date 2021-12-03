//
//  TitleSectionHeaderReusableView.swift
//  ICO-visualizer
//
//  Created by Anonymous on 22/10/21.
//

import UIKit

class TitleSectionHeaderReusableView: UICollectionReusableView {

    var titleLabel: UILabel = {
        let label = UILabel()
        label.custom(title: "Title", font: UIFont(name: "HelveticaNeue-Medium", size:20)!, titleColor: ColorLayout.default_text, textAlignment: .left, numberOfLines: 1)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTitle(title: String){
        titleLabel.text = title
    }
}

extension TitleSectionHeaderReusableView : ViewSetable {

    func setupViews() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = ColorLayout.default_background
        addSubview(titleLabel)
    }

    func setupConstraints() {
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 30).isActive = true
    }
}

extension UILabel {

    func custom(title: String, font: UIFont, titleColor: UIColor, textAlignment: NSTextAlignment, numberOfLines: Int) {
        self.text = title
        self.textAlignment = textAlignment
        self.font = font
        self.textColor = titleColor
        self.numberOfLines = numberOfLines
        self.adjustsFontSizeToFitWidth = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

/// Defines methods for creating view.
protocol ViewSetable {

    /// Creates view hierarchy.
    func setupViews()

    /// Creates anchors between views.
    func setupConstraints()
}
