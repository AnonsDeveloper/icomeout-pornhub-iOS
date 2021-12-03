//
//  TikResponse.swift
//  ICO-visualizer
//
//  Created by Anonymous on 11/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import Foundation

// MARK: - TikResponse
struct TikResponse: Codable {
    let data: DataClass?
    let meta: Meta?
}

// MARK: - DataClass
struct DataClass: Codable {
    let posts: [Post]?
}

// MARK: - Post
struct Post: Codable {
    let id: Int?
    let uuid: String?
    let authorID: Int?
    let postDescription, vimeoID, vimeoURI, vimeoThumbnailURL: String?
    let viemoGIFURL: String?
    let redgifs: Bool?
    let redGifsThumbnailURL: String?
    let redGifsVideoURL: String?
    let status: Status?
    let width, height: Int?
    let mediaID, thumbnailID, thumbnailName, videoName: String?
    let postCount: Int?
    let source: String?
    let visible: Bool?
    let reactionInitial: Int?
    let createdAt, updatedAt: String?
    let author: Author?
    let tags: [TikPornTag]?
    let count: Count?
    let index: Int?

    enum CodingKeys: String, CodingKey {
        case id, uuid
        case authorID = "authorId"
        case postDescription = "description"
        case vimeoID = "vimeoId"
        case vimeoURI = "vimeoUri"
        case vimeoThumbnailURL = "vimeoThumbnailUrl"
        case viemoGIFURL = "viemoGifUrl"
        case redgifs
        case redGifsThumbnailURL = "redGifsThumbnailUrl"
        case redGifsVideoURL = "redGifsVideoUrl"
        case status, width, height
        case mediaID = "mediaId"
        case thumbnailID = "thumbnailId"
        case thumbnailName, videoName
        case postCount = "count"
        case source, visible, reactionInitial, createdAt, updatedAt, author, tags
        case count = "_count"
        case index
    }
}

// MARK: - Author
struct Author: Codable {
    let id: Int?
    let uuid, email: String?
    let emailVerified, publisher: Bool?
    let name: String?
    let authorDescription: Description?
    let website, avatarName, avatarID: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id, uuid, email, emailVerified, publisher, name
        case authorDescription = "description"
        case website, avatarName
        case avatarID = "avatarId"
        case createdAt
    }
}

enum Description: String, Codable {
    case officialXxxtikPage = "Official xxxtik page."
}

// MARK: - Count
struct Count: Codable {
    let reactions: Int?
}

enum Status: String, Codable {
    case approved = "approved"
}

// MARK: - Tag
struct TikPornTag: Codable {
    let id: Int?
    let uuid, name: String?
}

// MARK: - Meta
struct Meta: Codable {
    let key: String?
}

