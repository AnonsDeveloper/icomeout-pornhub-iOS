//
//  ColorLayout.swift
//  ICO-visualizer
//
//  Created by Anonymous on 03/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import UIKit

class ColorLayout {
    static let default_background: UIColor = UIColor(named: "default_background") ?? .black
    static let default_tab_background: UIColor = UIColor(named: "default_tab_background") ?? .darkGray
    static let default_orange: UIColor = UIColor(named: "default_orange") ?? .systemOrange
    static let default_grey: UIColor = UIColor(named: "default_grey") ?? .lightGray
    static let default_text: UIColor = UIColor(named: "default_text") ?? .white
}

class ContentLayout {
    public static var safeAreaTopHeight: CGFloat {
        let window = UIApplication.shared.windows.first
        return window?.safeAreaInsets.top ?? 0
    }
    
    public static var safeAreaBottomHeight: CGFloat {
        let window = UIApplication.shared.windows.first
        return window?.safeAreaInsets.bottom ?? 0
    }
}
