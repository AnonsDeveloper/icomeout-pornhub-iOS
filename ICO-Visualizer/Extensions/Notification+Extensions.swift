//
//  Notification+Extensions.swift
//  ICO-visualizer
//
//  Created by Anonymous on 09/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let didUpdateBookmarks = Notification.Name("didUpdateBookmarks")
    static let didEnterCorrectPin = Notification.Name("didEnterCorrectPin")
    static let didEnterFakePin = Notification.Name("didEnterFakePin")
}
