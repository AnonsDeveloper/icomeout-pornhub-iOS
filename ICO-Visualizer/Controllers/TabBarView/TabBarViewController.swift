//
//  TabBarViewController.swift
//  Crypto Bot
//
//  Created by Anonymous on 21/09/21.
//

import UIKit

class TabBarViewController: UIViewController {
    
    @IBOutlet var tabItems: Array<UIButton>?

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerHeightConstraing: NSLayoutConstraint!
    private let defaultHeaderHeight: CGFloat = 120
    
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var headerLogoImageView: UIImageView!
    private var mainNavigationController: BaseNavigationController!

    lazy var controllers = [HomeViewController(), BookmarksViewController(), StarsViewController(), ReelsViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onDidEnterFakePin(_:)), name: .didEnterFakePin, object: nil)
    }
    
    @objc func onDidEnterFakePin(_ notification: Notification)
    {
        DispatchQueue.main.async {
            let vc = FakeViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BaseNavigationController,
                    segue.identifier == "mainSegue" {
            self.mainNavigationController = vc
            self.mainNavigationController.setNavigationBarHidden(true, animated: false)
            self.setViewController(index: 0)
        }
    }
    
    private func setViewController(index: Int){
        self.headerHeightConstraing.constant = index == 3 ? 0 : self.defaultHeaderHeight
        self.headerView.isHidden = index == 3
        let vc = controllers[index]
        vc.tabDelegate = self
        self.mainNavigationController.setViewControllers([vc], animated: false)
        
        for item in tabItems! {
            item.setTitle("", for: .normal)
            item.tintColor = ColorLayout.default_grey
        }
        self.tabItems![index].tintColor = ColorLayout.default_orange
        settingsButton.setTitle("", for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            vc.viewDidSet()
        }
        
    }
    @IBAction func onItemSelect(_ sender: UIButton) {
        self.setViewController(index: sender.tag)
    }
    
    @IBAction func onSettingsButtonTap(_ sender: UIButton) {
        if mainNavigationController.topViewController is SettingsViewController {
            return
        }
        let vc = SettingsViewController()
        self.mainNavigationController.pushViewController(vc, animated: true)
    }
}

extension TabBarViewController: TabBarViewControllerDelegate {
    func setPage(index: Int) {
        self.setViewController(index: index)
    }
    
    func searchForCategory(category: String) {
        if let vc = self.controllers[0] as? HomeViewController {
            vc.searchForCategory(category: category)
        }
    }
    
    func setHeader() {
        self.headerLogoImageView.image = UIImage(named: "header_logo")
    }
}
