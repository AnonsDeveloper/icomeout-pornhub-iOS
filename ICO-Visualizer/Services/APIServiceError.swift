//
//  APIServiceError.swift
//  ICO-visualizer
//
//  Created by Anonymous on 03/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import Foundation

public enum APIServiceError: Error {
    case unknown
    case decodeError(Error)
    case noDataFound
    case error(ErrorResponse)
}
