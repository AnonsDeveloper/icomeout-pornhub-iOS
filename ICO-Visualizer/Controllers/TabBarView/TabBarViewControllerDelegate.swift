//
//  TabBarViewControllerDelegate.swift
//  Crypto Bot
//
//  Created by Anonymous on 24/09/21.
//

import Foundation

protocol TabBarViewControllerDelegate {
    func setPage(index: Int)
    func searchForCategory(category: String)
    func setHeader()
}
