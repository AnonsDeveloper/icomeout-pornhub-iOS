//
//  ErrorResponse.swift
//  ICO-visualizer
//
//  Created by Anonymous on 03/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import Foundation

// MARK: - ErrorResponse
public struct ErrorResponse: Codable {
    let code, message: String
    let example: String
}
