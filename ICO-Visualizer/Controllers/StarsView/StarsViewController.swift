//
//  StarsViewController.swift
//  ICO-visualizer
//
//  Created by Anonymous on 03/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import UIKit
import CCBottomRefreshControl

class StarsViewController: BaseViewController {
    
    private var coordinator: StarsViewCoordinator!
    
    let searchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorLayout.default_tab_background
        view.setShadowAndCorner(cornerRadius: 8)
        return view
    }()
    
    let searchField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.returnKeyType = .search
        field.keyboardType = .default
        field.borderStyle = .none
        field.backgroundColor = ColorLayout.default_tab_background
        field.placeholder = " Search..."
        field.textColor = ColorLayout.default_text
        field.attributedPlaceholder = NSAttributedString(
            string: " Search...",
            attributes: [NSAttributedString.Key.foregroundColor: ColorLayout.default_text]
        )
        var imageView = UIImageView();
        var image = UIImage(named: "search_icon")
        imageView.image = image;
        imageView.tintColor = .lightGray
        field.leftView = imageView
        field.leftViewMode = UITextField.ViewMode.always
        field.leftViewMode = .always
        return field
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.searchView)
        searchView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        searchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        searchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        searchView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.searchView.addSubview(searchField)
        searchField.trailingAnchor.constraint(equalTo: self.searchView.trailingAnchor, constant: -30).isActive = true
        searchField.leadingAnchor.constraint(equalTo: self.searchView.leadingAnchor, constant: 30).isActive = true
        searchField.centerYAnchor.constraint(equalTo: self.searchView.centerYAnchor).isActive = true
        searchField.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: VideoCollectionViewCell.self)
        collectionView.register(cellType: TitleCollectionViewCell.self)
        collectionView.register(cellType: StarCollectionViewCell.self)
        collectionView.register(TitleSectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleSectionHeaderReusableView.className)
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
            flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 85)
            flowLayout.sectionHeadersPinToVisibleBounds = true
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        coordinator = StarsViewCoordinator(self)
        collectionView.keyboardDismissMode = .onDrag
        coordinator.loadData()
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        collectionView.refreshControl = refreshControl
        collectionView.refreshControl?.bounds = CGRect(x: refreshControl.bounds.origin.x,
                                       y: -50,
                                       width: refreshControl.bounds.size.width,
                                       height: refreshControl.bounds.size.height)
        self.collectionView.refreshControl?.beginRefreshing()
        NotificationCenter.default.addObserver(self, selector: #selector(onDidUpdateBookmarks(_:)), name: .didUpdateBookmarks, object: nil)
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchForStar()
    }


    @objc func refresh(_ sender: Any) {
        DispatchQueue.main.async {
            self.coordinator.loadData()
            self.collectionView.refreshControl?.beginRefreshing()
        }
    }
    
    func searchForStar(){
        if let starToFind = UserPreferences.shared.starToFind, let starFound = self.coordinator.stars.first(where: { $0.star?.starName == starToFind })?.star {
            UserPreferences.shared.starToFind = nil
            let vc = StarViewController()
            vc.tabDelegate = self.tabDelegate
            vc.star = starFound
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidSet() {
        super.viewDidSet()
        self.searchForStar()
    }
    
    @objc func onDidUpdateBookmarks(_ notification: Notification)
    {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension StarsViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchField.resignFirstResponder()
        DispatchQueue.main.async {
            self.coordinator.filterStars(filter: textField.text ?? "")
        }
        return true
    }
}

extension StarsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSectionHeaderReusableView.className, for: indexPath) as! TitleSectionHeaderReusableView
            
            if self.coordinator.stars.count == 0 {
                headerView.setupTitle(title: "")
            }
            else{
                headerView.setupTitle(title: "Pornstars")
            }
            return headerView

        case UICollectionView.elementKindSectionFooter:
            return UICollectionReusableView()

        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width,height:170)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.coordinator.stars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StarCollectionViewCell.className, for: indexPath) as! StarCollectionViewCell
        if let star = self.coordinator.stars[indexPath.row].star{
            cell.setup(star: star)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let star = self.coordinator.stars[indexPath.row].star, let _ = star.starName {
            let vc = StarViewController()
            vc.star = star
            vc.tabDelegate = self.tabDelegate
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension StarsViewController: StarsViewControllerDelegate {
    func reloadView() {
        DispatchQueue.main.async {
            self.errorTextLabel.isHidden = true
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
            self.searchForStar()
        }
    }
    
    func onError(error: Error) {
        self.errorTextLabel.isHidden = false
        self.errorTextLabel.text = error.localizedDescription
    }
}


