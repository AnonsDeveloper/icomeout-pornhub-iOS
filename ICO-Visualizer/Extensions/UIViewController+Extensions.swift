//
//  UIViewController+Extensions.swift
//  ICO-visualizer
//
//  Created by Anonymous on 09/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import UIKit

extension UIViewController {
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
