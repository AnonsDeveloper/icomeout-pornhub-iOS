//
//  TikPornResponse.swift
//  ICO-visualizer
//
//  Created by Anonymous on 15/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let tikPornResponse = try? newJSONDecoder().decode(TikPornResponse.self, from: jsonData)

import Foundation

// MARK: - TikPornResponse
struct TikPornResponse: Codable {
    let code: Int?
    let message: String?
    let data: [TikPornPost]?
}

// MARK: - Datum
struct TikPornPost: Codable {
    let videoID, ewokVideoID, actionID: Int?
    let actionName: String?
    let startPosition, encodingTypeID: Int?
    let datumExtension: String?
    let mainCategory, producerID: Int?
    let tagVideoID: String?
    let onCDN, status: Int?
    let producerName: String?
    let producerAvatar: Int?
    let pornstars: [TikPornstar]?
    let userRating: Int?
    let likeCount: String?
    let tags: [TikTag]?
    let filename: String?
    let fileurl: String?
    let mimetype: String?
    let userID: Int?

    enum CodingKeys: String, CodingKey {
        case videoID = "video_id"
        case ewokVideoID = "ewok_video_id"
        case actionID = "action_id"
        case actionName = "action_name"
        case startPosition = "start_position"
        case encodingTypeID = "encoding_type_id"
        case datumExtension = "extension"
        case mainCategory = "main_category"
        case producerID = "producer_id"
        case tagVideoID = "tag_video_id"
        case onCDN = "on_cdn"
        case status
        case producerName = "producer_name"
        case producerAvatar = "producer_avatar"
        case pornstars
        case userRating = "user_rating"
        case likeCount = "like_count"
        case tags, filename, fileurl, mimetype
        case userID = "user_id"
    }
}

// MARK: - Pornstar
struct TikPornstar: Codable {
    let id, name, slug: String?
    let avatarImg: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case avatarImg = "avatar_img"
    }
}

// MARK: - Tag
struct TikTag: Codable {
    let id, name: String?
}
