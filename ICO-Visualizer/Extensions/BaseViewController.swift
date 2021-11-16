//
//  BaseViewController.swift
//  ICO-visualizer
//
//  Created by Anonymous on 28/09/21.
//

import UIKit

class BaseViewController: UIViewController {
    var collectionView: UICollectionView!
    var tabDelegate: TabBarViewControllerDelegate?
    
    let errorTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = ""
        label.isHidden = true
        label.textColor = ColorLayout.default_grey
        label.font = UIFont(name: "HelveticaNeue-Semibold", size: 18.0)
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        collectionView.backgroundColor = .clear
        self.view.backgroundColor = ColorLayout.default_background
        self.view.addSubview(self.errorTextLabel)
        errorTextLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        errorTextLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        errorTextLabel.centerYAnchor.constraint(equalTo: self.collectionView.centerYAnchor).isActive = true
    }
    
    func viewDidSet(){
        
    }
}

