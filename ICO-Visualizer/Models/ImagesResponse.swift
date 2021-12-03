//
//  ImagesResponse.swift
//  ICO-visualizer
//
//  Created by Anonymous on 16/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import Foundation

// MARK: - ImagesResponseElement
struct ImagesResponseElement: Codable {
    let gURL: String?
    let tURL: String?
    let h: Int?
    let desc: String?
    let tURL460: String?
    let gid, mid, tid, atid: String?
    let nofollow, outLink: Bool?

    enum CodingKeys: String, CodingKey {
        case gURL = "g_url"
        case tURL = "t_url"
        case h, desc
        case tURL460 = "t_url_460"
        case gid, mid, tid, atid, nofollow, outLink
    }
}

typealias ImagesResponse = [ImagesResponseElement]
