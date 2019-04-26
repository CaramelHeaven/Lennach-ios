//
//  BoardResponse.swift
//  Lennach
//
//  Created by Sergey Fominov on 18/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import Foundation

struct BoardResponse: Codable {
    
    let Board: String?
    let BoardInfo: String?
    let BoardInfoOuter: String?
    let BoardName: String?
    let advertBottomImage: String?
    let advertBottomLink: String?
    let advertMobileImage: String?
    let advertMobileLink: String?
    let advertTopImage: String?
    let advertTopLink: String?
    let boardBannerImage: String?
    let boardBannerLink: String?
    let bumpLimit: Int?
    let defaultName: String?
    let enableDices: Int?
    let enableFlags: Int?
    let enableIcons: Int?
    let enableImages: Int?
    let enableLikes: Int?
    let enableNames: Int?
    let enableOekaki: Int?
    let enablePosting: Int?
    let enableSage: Int?
    let enableShield: Int?
    let enableSubject: Int?
    let enableThreadTags: Int?
    let enableTrips: Int?
    let enableVideo: Int?
    let filter: String?
    let maxComment: Int?
    let maxFilesSize: Int?
    let threads: [UsenetsBoardResponse]?
    
    private enum CodingKeys: String, CodingKey {
        case Board = "Board"
        case BoardInfo = "BoardInfo"
        case BoardInfoOuter = "BoardInfoOuter"
        case BoardName = "BoardName"
        case advertBottomImage = "advert_bottom_image"
        case advertBottomLink = "advert_bottom_link"
        case advertMobileImage = "advert_mobile_image"
        case advertMobileLink = "advert_mobile_link"
        case advertTopImage = "advert_top_image"
        case advertTopLink = "advert_top_link"
        case boardBannerImage = "board_banner_image"
        case boardBannerLink = "board_banner_link"
        case bumpLimit = "bump_limit"
        case defaultName = "default_name"
        case enableDices = "enable_dices"
        case enableFlags = "enable_flags"
        case enableIcons = "enable_icons"
        case enableImages = "enable_images"
        case enableLikes = "enable_likes"
        case enableNames = "enable_names"
        case enableOekaki = "enable_oekaki"
        case enablePosting = "enable_posting"
        case enableSage = "enable_sage"
        case enableShield = "enable_shield"
        case enableSubject = "enable_subject"
        case enableThreadTags = "enable_thread_tags"
        case enableTrips = "enable_trips"
        case enableVideo = "enable_video"
        case filter = "filter"
        case maxComment = "max_comment"
        case maxFilesSize = "max_files_size"
        case threads = "threads"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        Board = try values.decodeIfPresent(String.self, forKey: .Board)
        BoardInfo = try values.decodeIfPresent(String.self, forKey: .BoardInfo)
        BoardInfoOuter = try values.decodeIfPresent(String.self, forKey: .BoardInfoOuter)
        BoardName = try values.decodeIfPresent(String.self, forKey: .BoardName)
        advertBottomImage = try values.decodeIfPresent(String.self, forKey: .advertBottomImage)
        advertBottomLink = try values.decodeIfPresent(String.self, forKey: .advertBottomLink)
        advertMobileImage = try values.decodeIfPresent(String.self, forKey: .advertMobileImage)
        advertMobileLink = try values.decodeIfPresent(String.self, forKey: .advertMobileLink)
        advertTopImage = try values.decodeIfPresent(String.self, forKey: .advertTopImage)
        advertTopLink = try values.decodeIfPresent(String.self, forKey: .advertTopLink)
        boardBannerImage = try values.decodeIfPresent(String.self, forKey: .boardBannerImage)
        boardBannerLink = try values.decodeIfPresent(String.self, forKey: .boardBannerLink)
        bumpLimit = try values.decodeIfPresent(Int.self, forKey: .bumpLimit)
        defaultName = try values.decodeIfPresent(String.self, forKey: .defaultName)
        enableDices = try values.decodeIfPresent(Int.self, forKey: .enableDices)
        enableFlags = try values.decodeIfPresent(Int.self, forKey: .enableFlags)
        enableIcons = try values.decodeIfPresent(Int.self, forKey: .enableIcons)
        enableImages = try values.decodeIfPresent(Int.self, forKey: .enableImages)
        enableLikes = try values.decodeIfPresent(Int.self, forKey: .enableLikes)
        enableNames = try values.decodeIfPresent(Int.self, forKey: .enableNames)
        enableOekaki = try values.decodeIfPresent(Int.self, forKey: .enableOekaki)
        enablePosting = try values.decodeIfPresent(Int.self, forKey: .enablePosting)
        enableSage = try values.decodeIfPresent(Int.self, forKey: .enableSage)
        enableShield = try values.decodeIfPresent(Int.self, forKey: .enableShield)
        enableSubject = try values.decodeIfPresent(Int.self, forKey: .enableSubject)
        enableThreadTags = try values.decodeIfPresent(Int.self, forKey: .enableThreadTags)
        enableTrips = try values.decodeIfPresent(Int.self, forKey: .enableTrips)
        enableVideo = try values.decodeIfPresent(Int.self, forKey: .enableVideo)
        filter = try values.decodeIfPresent(String.self, forKey: .filter)
        maxComment = try values.decodeIfPresent(Int.self, forKey: .maxComment)
        maxFilesSize = try values.decodeIfPresent(Int.self, forKey: .maxFilesSize)
        threads = try values.decodeIfPresent([UsenetsBoardResponse].self, forKey: .threads)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(Board, forKey: .Board)
        try container.encodeIfPresent(BoardInfo, forKey: .BoardInfo)
        try container.encodeIfPresent(BoardInfoOuter, forKey: .BoardInfoOuter)
        try container.encodeIfPresent(BoardName, forKey: .BoardName)
        try container.encodeIfPresent(advertBottomImage, forKey: .advertBottomImage)
        try container.encodeIfPresent(advertBottomLink, forKey: .advertBottomLink)
        try container.encodeIfPresent(advertMobileImage, forKey: .advertMobileImage)
        try container.encodeIfPresent(advertMobileLink, forKey: .advertMobileLink)
        try container.encodeIfPresent(advertTopImage, forKey: .advertTopImage)
        try container.encodeIfPresent(advertTopLink, forKey: .advertTopLink)
        try container.encodeIfPresent(boardBannerImage, forKey: .boardBannerImage)
        try container.encodeIfPresent(boardBannerLink, forKey: .boardBannerLink)
        try container.encodeIfPresent(bumpLimit, forKey: .bumpLimit)
        try container.encodeIfPresent(defaultName, forKey: .defaultName)
        try container.encodeIfPresent(enableDices, forKey: .enableDices)
        try container.encodeIfPresent(enableFlags, forKey: .enableFlags)
        try container.encodeIfPresent(enableIcons, forKey: .enableIcons)
        try container.encodeIfPresent(enableImages, forKey: .enableImages)
        try container.encodeIfPresent(enableLikes, forKey: .enableLikes)
        try container.encodeIfPresent(enableNames, forKey: .enableNames)
        try container.encodeIfPresent(enableOekaki, forKey: .enableOekaki)
        try container.encodeIfPresent(enablePosting, forKey: .enablePosting)
        try container.encodeIfPresent(enableSage, forKey: .enableSage)
        try container.encodeIfPresent(enableShield, forKey: .enableShield)
        try container.encodeIfPresent(enableSubject, forKey: .enableSubject)
        try container.encodeIfPresent(enableThreadTags, forKey: .enableThreadTags)
        try container.encodeIfPresent(enableTrips, forKey: .enableTrips)
        try container.encodeIfPresent(enableVideo, forKey: .enableVideo)
        try container.encodeIfPresent(filter, forKey: .filter)
        try container.encodeIfPresent(maxComment, forKey: .maxComment)
        try container.encodeIfPresent(maxFilesSize, forKey: .maxFilesSize)
        try container.encodeIfPresent(threads, forKey: .threads)
    }
}
