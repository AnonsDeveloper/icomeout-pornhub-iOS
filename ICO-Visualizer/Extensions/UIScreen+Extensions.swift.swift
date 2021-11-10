//
//  UIScreen+Extensions.swift.swift
//  ICO-visualizer
//
//  Created by Anonymous on 10/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import UIKit

extension UIScreen {
    
    public var topSafeAreaHeight: CGFloat {
        let window = UIApplication.shared.windows.first
        let topPadding = window?.safeAreaInsets.top
        return topPadding ?? 0
    }
    
    public var bottomSafeAreaHeight: CGFloat {
        let window = UIApplication.shared.windows.first
        let bottomPadding = window?.safeAreaInsets.bottom
        return bottomPadding ?? 0
    }
}
