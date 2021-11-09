//
//  StarsModel.swift
//  ICO-visualizer
//
//  Created by Anonymous on 03/11/21.
//  Copyright © 2021 Anonymous. All rights reserved.
//

import Foundation

// MARK: - Stars
struct StarsModel: Codable {
    var stars: [StarElement]?
}

// MARK: - StarElement
struct StarElement: Codable {
    var star: Star?
}

// MARK: - StarStar
struct Star: Codable {
    var starName: String?
    var starThumb: String?
    var starURL: String?
    var gender: String?
    var videosCountAll: String?
    var starVideos: [Video]?

    enum CodingKeys: String, CodingKey {
        case starName = "star_name"
        case starThumb = "star_thumb"
        case starURL = "star_url"
        case gender
        case videosCountAll = "videos_count_all"
        case starVideos
    }
}
//
//enum Gender: String, Codable {
//    case couple = "Couple"
//    case f2M = "f2m"
//    case female = "female"
//    case m2F = "m2f"
//    case male = "male"
//    case nonBinary = "Non-Binary"
//    case other = "Other"
//    case sameSexCoupleFemale = "Same Sex Couple (Female)"
//    case sameSexCoupleMale = "Same Sex Couple (Male)"
//    case unknown = "unknown"
//}
