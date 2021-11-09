//
//  SearchViewDelegate.swift
//  ICO-visualizer
//
//  Created by Anonymous on 03/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import Foundation

protocol CategoriesViewDelegate{
    func reloadView()
    func onError(message: Error)
}
