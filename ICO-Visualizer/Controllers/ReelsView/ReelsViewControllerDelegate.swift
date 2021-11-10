//
//  ReelsViewControllerDelegate.swift
//  ICO-visualizer
//
//  Created by Anonymous on 10/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import Foundation

protocol ReelsViewControllerDelegate {
    func reloadView()
    
    func openUrl(url: URL)
    func switchSound()
}
