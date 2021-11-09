//
//  StarViewControllerDelegate.swift
//  ICO-visualizer
//
//  Created by Anonymous on 04/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import Foundation

protocol StarViewControllerDelegate{
    var videosCompleted: Bool {get set}
    func reloadView(_ message: String?)
    func reloadImages(_ message: String?)
    func getStar() -> Star
    func setupErrorMessage(message: String)
}
