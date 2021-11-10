//
//  HomeViewController.swift
//  ICO-visualizer
//
//  Created by Anonymous on 03/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import UIKit
import CCBottomRefreshControl

class HomeViewController: BaseViewController {
    
    private var coordinator: HomeViewCoordinator!
    private var loadingData = false
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(onEnterPin(_:)), name: .didEnterCorrectPin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidUpdateBookmarks(_:)), name: .didUpdateBookmarks, object: nil)
        
        #if targetEnvironment(simulator)
        self.load()
        return
        #endif
        
        let vc = PinSetupViewController()
        vc.pinType = UserPreferences.shared.userPin == nil ? .newPin : .auth
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    func showKillAlert(){
        let alert = UIAlertController(title: "Error", message: "Autentication failed, the app will be killed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            exit(-1)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func load(){
        self.collectionView.setupView(self)
        self.tabDelegate?.setHeader()
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
            flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 85)
            //flowLayout.sectionHeadersPinToVisibleBounds = true
            flowLayout.estimatedItemSize = CGSize(
                width: UIScreen.main.bounds.width - 2,
                height: 200
            )
            flowLayout.invalidateLayout()
        }
        
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
        
        let bottomRefreshController = UIRefreshControl()
        bottomRefreshController.tintColor = ColorLayout.default_text
        collectionView.bottomRefreshControl = bottomRefreshController
        coordinator = HomeViewCoordinator(self)
        self.loadingData = true
        collectionView.bottomRefreshControl?.beginRefreshing()
        coordinator.loadData()
        //self.setupToHideKeyboardOnTapOnView()
        collectionView.keyboardDismissMode = .onDrag
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        collectionView.refreshControl = refreshControl
        collectionView.refreshControl?.bounds = CGRect(x: refreshControl.bounds.origin.x,
                                       y: -50,
                                       width: refreshControl.bounds.size.width,
                                       height: refreshControl.bounds.size.height)
        self.collectionView.refreshControl?.beginRefreshing()
    }
    
    @objc func onEnterPin(_ notification: Notification)
    {
        DispatchQueue.main.async {
            self.load()
        }
    }
    
    @objc func refresh(_ sender: Any) {
        DispatchQueue.main.async {
            self.coordinator.videos = []
            self.collectionView.reloadData()
            self.coordinator.loadData()
            self.collectionView.refreshControl?.beginRefreshing()
        }
    }
    
    func searchForCategory(category: String){
        self.searchField.text = ""
        self.loadingData = true
        self.coordinator.videos = []
        self.collectionView.reloadData()
        self.collectionView.refreshControl?.beginRefreshing()
        self.collectionView.bottomRefreshControl?.beginRefreshing()
        self.coordinator.searchForCategory(category: category)
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

extension HomeViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchField.resignFirstResponder()
        DispatchQueue.main.async {
            self.loadingData = true
            self.coordinator.videos = []
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.beginRefreshing()
            self.collectionView.bottomRefreshControl?.beginRefreshing()
            self.coordinator.search(searchText: textField.text.nilOrEmpty ? nil : textField.text)
        }
        return true
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:

            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSectionHeaderReusableView.className, for: indexPath) as! TitleSectionHeaderReusableView
            var titleText = "Home"
            if !self.coordinator.searchText.nilOrEmpty {
                titleText = "\(self.coordinator.searchText!) Videos"
            }
            else if !self.coordinator.category.nilOrEmpty {
                titleText = "\(self.coordinator.category!.capitalizingFirstLetter().replacingOccurrences(of: "-", with: " ")) Videos"
            }
            headerView.setupTitle(title: titleText)
            
            return headerView

        case UICollectionView.elementKindSectionFooter:
            return UICollectionReusableView()

        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.coordinator.videos.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cat = collectionView.dequeueReusableCell(withReuseIdentifier: NavigationButtonCollectionViewCell.className, for: indexPath) as! NavigationButtonCollectionViewCell
            cat.setup(title: "Categories") {
                let vc = CategoriesViewController()
                vc.tabDelegate = self.tabDelegate
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cat
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.className, for: indexPath) as! VideoCollectionViewCell
        cell.setup(video: self.coordinator.videos[indexPath.row - 1])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastElement = (self.coordinator.videos.count + 1) - 1
        if !loadingData && indexPath.row == lastElement {
            collectionView.bottomRefreshControl?.beginRefreshing()
            loadingData = true
            self.coordinator.fetchNext()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        VideoPreviewViewController.present(fromView: self, video: self.coordinator.videos[indexPath.row - 1], delegate: self.tabDelegate)
    }
}

extension HomeViewController: HomeViewDelegate {
    func reloadView() {
        DispatchQueue.main.async {
            self.errorTextLabel.isHidden = true
            self.collectionView.bottomRefreshControl?.endRefreshing()
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
            self.loadingData = false
        }
    }
    
    func showError(message: String){
        DispatchQueue.main.async {
            self.collectionView.bottomRefreshControl?.endRefreshing()
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
            //self.loadingData = false
            self.errorTextLabel.isHidden = false
            self.errorTextLabel.text = message
        }

    }
}
