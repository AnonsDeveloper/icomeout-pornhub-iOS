//
//  SearchViewController.swift
//  ICO-visualizer
//
//  Created by Anonymous on 03/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import UIKit
import CCBottomRefreshControl

class CategoriesViewController: BaseViewController {
    
    private var coordinator: CategoriesViewCoordinator!
    
    static var currentIndex: Int = 0
    
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
        
        self.collectionView.setupView(self)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 90)
            flowLayout.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 12)
            flowLayout.sectionHeadersPinToVisibleBounds = true
            flowLayout.estimatedItemSize = CGSize(
                width: UIScreen.main.bounds.width - 30,
                height: 200
            )
            flowLayout.invalidateLayout()
        }
       // let bottomRefreshController = UIRefreshControl()
        
//        self.view.addSubview(searchField)
//        searchField.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        searchField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//        searchField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
//        
        //collectionView.bottomRefreshControl = bottomRefreshController
        coordinator = CategoriesViewCoordinator(self)
        //self.loadingData = true
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.keyboardDismissMode = .onDrag
        collectionView.refreshControl = refreshControl
        collectionView.refreshControl?.bounds = CGRect(x: refreshControl.bounds.origin.x,
                                       y: -50,
                                       width: refreshControl.bounds.size.width,
                                       height: refreshControl.bounds.size.height)
        self.collectionView.refreshControl?.beginRefreshing()
        //collectionView.bottomRefreshControl?.beginRefreshing()
        coordinator.loadData()
        
    }
    
    @objc func refresh(_ sender: Any) {
        DispatchQueue.main.async {
            self.coordinator.categories = []
            self.collectionView.reloadData()
            self.coordinator.loadData()
            self.collectionView.refreshControl?.beginRefreshing()
        }
    }
}

extension CategoriesViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchField.resignFirstResponder()
        DispatchQueue.main.async {
            self.coordinator.filterCategories(filter: textField.text ?? "")
        }
        return true
    }
}

extension CategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:

            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSectionHeaderReusableView.className, for: indexPath) as! TitleSectionHeaderReusableView
            headerView.setupTitle(title: "Categories")
            
            return headerView

        case UICollectionView.elementKindSectionFooter:
            return UICollectionReusableView()

        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.coordinator.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.className, for: indexPath) as! TitleCollectionViewCell
        cell.setup(title: self.coordinator.categories[indexPath.row].category?.capitalizingFirstLetter().replacingOccurrences(of: "-", with: " ") ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let category = self.coordinator.categories[indexPath.row].category {
            CategoriesViewController.currentIndex = indexPath.row
            self.tabDelegate?.searchForCategory(category: category)
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension CategoriesViewController: CategoriesViewDelegate {
    func reloadView() {
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
            self.errorTextLabel.isHidden = true
            //self.collectionView.bottomRefreshControl?.endRefreshing()
            self.collectionView.reloadData()
            if CategoriesViewController.currentIndex != 0 {
                self.collectionView.scrollToItem(at: IndexPath(row: CategoriesViewController.currentIndex, section: 0), at: .centeredVertically, animated: false)
            }
           // self.loadingData = false
        }
    }
    
    func onError(message: Error) {
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
            self.errorTextLabel.isHidden = false
            self.errorTextLabel.text = message.localizedDescription
        }
    }
}

