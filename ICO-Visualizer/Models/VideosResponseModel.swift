//
//  VideoResponseModel.swift
//  ICO-visualizer
//
//  Created by Anonymous on 03/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import Foundation

// MARK: - VideoResponse
struct VideosResponseModel: Codable {
    let videos: [Video]
}

// MARK: - VideoResult
struct VideoResult: Codable {
    let video: Video
}

// MARK: - Video
struct Video: Codable {
    let duration: String?
    let views: Int?
    let videoID: String?
    let ratings: Int?
    let rating: Rating?
    let title: String?
    let url: String?
    let defaultThumb, thumb: String?
    let publishDate: String?
    let thumbs: [Thumb]?
    let tags: [Tag]?
    let pornstars: [Pornstar]?
    let categories: [Category]?
    let segment: Segment?

    enum CodingKeys: String, CodingKey {
        case duration, views
        case videoID = "video_id"
        case ratings, title, url
        case defaultThumb = "default_thumb"
        case thumb
        case rating
        case publishDate = "publish_date"
        case thumbs, tags, pornstars, categories, segment
    }
}

//struct Rating: Codable {
//    let type: Int?
//
//    init(from decoder: Decoder) throws {
//        // Decode all fields and store them
//        let container = try decoder.container(keyedBy: CodingKeys.self) // The compiler creates coding keys for each property, so as long as the keys are the same as the property names, we don't need to define our own enum.
//
//        // First check for a Double
//        do {
//            type = try container.decode(Int.self, forKey: .type)
//
//        } catch {
//            // The check for a String and then cast it, this will throw if decoding fails
//            if let typeValue = Int(try container.decode(String.self, forKey: .type)) {
//                type = typeValue
//            } else {
//                // You may want to throw here if you don't want to default the value(in the case that it you can't have an optional).
//                type = nil
//            }
//        }
//
//        // Perform other decoding for other properties.
//    }
//}

struct Rating: Codable {
    let rating: Double
    let ratingString: String

    // Where we determine what type the value is
    init(from decoder: Decoder) throws {
        let container =  try decoder.singleValueContainer()

        // Check for a boolean
        do {
            rating = try container.decode(Double.self)
            ratingString = "0"
        } catch {
            // Check for an integer
            ratingString = try container.decode(String.self)
            rating = 0
        }
    }

    // We need to go back to a dynamic type, so based on the data we have stored, encode to the proper type
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try rating == 0 ? container.encode(ratingString) : container.encode(0)
    }
}

// MARK: - Category
struct Category: Codable {
    let category: String?
    let id: String?
}

// MARK: - Pornstar
struct Pornstar: Codable {
    let pornstarName: String?

    enum CodingKeys: String, CodingKey {
        case pornstarName = "pornstar_name"
    }
}

enum Segment: String, Codable {
    case gay = "gay"
    case straight = "straight"
}

// MARK: - Tag
struct Tag: Codable {
    let tagName: String?

    enum CodingKeys: String, CodingKey {
        case tagName = "tag_name"
    }
}

// MARK: - Thumb
struct Thumb: Codable {
    let size: String?
    let width, height: String?
    let src: String?
}
