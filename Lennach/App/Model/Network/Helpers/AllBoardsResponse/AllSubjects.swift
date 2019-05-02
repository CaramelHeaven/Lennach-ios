//
//  AllSubjects.swift
//  Lennach
//
//  Created by Sergey Fominov on 02/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import Foundation

struct ForAdults: Codable {

    let bumpLimit: Int?
    let category: String?
    let defaultName: String?
    let id: String?
    let name: String?
    let pages: Int?
    let sage: Int?
    let tripcodes: Int?

    private enum CodingKeys: String, CodingKey {
        case bumpLimit = "bump_limit"
        case category = "category"
        case defaultName = "default_name"
        case id = "id"
        case name = "name"
        case pages = "pages"
        case sage = "sage"
        case tripcodes = "tripcodes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bumpLimit = try values.decodeIfPresent(Int.self, forKey: .bumpLimit)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        defaultName = try values.decodeIfPresent(String.self, forKey: .defaultName)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        pages = try values.decodeIfPresent(Int.self, forKey: .pages)
        sage = try values.decodeIfPresent(Int.self, forKey: .sage)
        tripcodes = try values.decodeIfPresent(Int.self, forKey: .tripcodes)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(bumpLimit, forKey: .bumpLimit)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(defaultName, forKey: .defaultName)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(pages, forKey: .pages)
        try container.encodeIfPresent(sage, forKey: .sage)
        try container.encodeIfPresent(tripcodes, forKey: .tripcodes)
    }

}

struct Games: Codable {

    let bumpLimit: Int?
    let category: String?
    let defaultName: String?
    let id: String?
    let name: String?
    let pages: Int?
    let sage: Int?
    let tripcodes: Int?

    private enum CodingKeys: String, CodingKey {
        case bumpLimit = "bump_limit"
        case category = "category"
        case defaultName = "default_name"
        case id = "id"
        case name = "name"
        case pages = "pages"
        case sage = "sage"
        case tripcodes = "tripcodes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bumpLimit = try values.decodeIfPresent(Int.self, forKey: .bumpLimit)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        defaultName = try values.decodeIfPresent(String.self, forKey: .defaultName)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        pages = try values.decodeIfPresent(Int.self, forKey: .pages)
        sage = try values.decodeIfPresent(Int.self, forKey: .sage)
        tripcodes = try values.decodeIfPresent(Int.self, forKey: .tripcodes)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(bumpLimit, forKey: .bumpLimit)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(defaultName, forKey: .defaultName)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(pages, forKey: .pages)
        try container.encodeIfPresent(sage, forKey: .sage)
        try container.encodeIfPresent(tripcodes, forKey: .tripcodes)
    }

}

struct Politics: Codable {

    let bumpLimit: Int?
    let category: String?
    let defaultName: String?
    let id: String?
    let name: String?
    let pages: Int?
    let sage: Int?
    let tripcodes: Int?

    private enum CodingKeys: String, CodingKey {
        case bumpLimit = "bump_limit"
        case category = "category"
        case defaultName = "default_name"
        case id = "id"
        case name = "name"
        case pages = "pages"
        case sage = "sage"
        case tripcodes = "tripcodes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bumpLimit = try values.decodeIfPresent(Int.self, forKey: .bumpLimit)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        defaultName = try values.decodeIfPresent(String.self, forKey: .defaultName)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        pages = try values.decodeIfPresent(Int.self, forKey: .pages)
        sage = try values.decodeIfPresent(Int.self, forKey: .sage)
        tripcodes = try values.decodeIfPresent(Int.self, forKey: .tripcodes)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(bumpLimit, forKey: .bumpLimit)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(defaultName, forKey: .defaultName)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(pages, forKey: .pages)
        try container.encodeIfPresent(sage, forKey: .sage)
        try container.encodeIfPresent(tripcodes, forKey: .tripcodes)
    }

}

struct Users: Codable {

    let bumpLimit: Int?
    let category: String?
    let defaultName: String?
    let id: String?
    let name: String?
    let pages: Int?
    let sage: Int?
    let tripcodes: Int?

    private enum CodingKeys: String, CodingKey {
        case bumpLimit = "bump_limit"
        case category = "category"
        case defaultName = "default_name"
        case id = "id"
        case name = "name"
        case pages = "pages"
        case sage = "sage"
        case tripcodes = "tripcodes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bumpLimit = try values.decodeIfPresent(Int.self, forKey: .bumpLimit)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        defaultName = try values.decodeIfPresent(String.self, forKey: .defaultName)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        pages = try values.decodeIfPresent(Int.self, forKey: .pages)
        sage = try values.decodeIfPresent(Int.self, forKey: .sage)
        tripcodes = try values.decodeIfPresent(Int.self, forKey: .tripcodes)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(bumpLimit, forKey: .bumpLimit)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(defaultName, forKey: .defaultName)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(pages, forKey: .pages)
        try container.encodeIfPresent(sage, forKey: .sage)
        try container.encodeIfPresent(tripcodes, forKey: .tripcodes)
    }

}

struct Differences: Codable {

    let bumpLimit: Int?
    let category: String?
    let defaultName: String?
    let id: String?
    let name: String?
    let pages: Int?
    let sage: Int?
    let tripcodes: Int?

    private enum CodingKeys: String, CodingKey {
        case bumpLimit = "bump_limit"
        case category = "category"
        case defaultName = "default_name"
        case id = "id"
        case name = "name"
        case pages = "pages"
        case sage = "sage"
        case tripcodes = "tripcodes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bumpLimit = try values.decodeIfPresent(Int.self, forKey: .bumpLimit)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        defaultName = try values.decodeIfPresent(String.self, forKey: .defaultName)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        pages = try values.decodeIfPresent(Int.self, forKey: .pages)
        sage = try values.decodeIfPresent(Int.self, forKey: .sage)
        tripcodes = try values.decodeIfPresent(Int.self, forKey: .tripcodes)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(bumpLimit, forKey: .bumpLimit)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(defaultName, forKey: .defaultName)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(pages, forKey: .pages)
        try container.encodeIfPresent(sage, forKey: .sage)
        try container.encodeIfPresent(tripcodes, forKey: .tripcodes)
    }

}

struct Creation: Codable {

    let bumpLimit: Int?
    let category: String?
    let defaultName: String?
    let id: String?
    let name: String?
    let pages: Int?
    let sage: Int?
    let tripcodes: Int?

    private enum CodingKeys: String, CodingKey {
        case bumpLimit = "bump_limit"
        case category = "category"
        case defaultName = "default_name"
        case id = "id"
        case name = "name"
        case pages = "pages"
        case sage = "sage"
        case tripcodes = "tripcodes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bumpLimit = try values.decodeIfPresent(Int.self, forKey: .bumpLimit)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        defaultName = try values.decodeIfPresent(String.self, forKey: .defaultName)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        pages = try values.decodeIfPresent(Int.self, forKey: .pages)
        sage = try values.decodeIfPresent(Int.self, forKey: .sage)
        tripcodes = try values.decodeIfPresent(Int.self, forKey: .tripcodes)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(bumpLimit, forKey: .bumpLimit)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(defaultName, forKey: .defaultName)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(pages, forKey: .pages)
        try container.encodeIfPresent(sage, forKey: .sage)
        try container.encodeIfPresent(tripcodes, forKey: .tripcodes)
    }

}

struct Subjects: Codable {

    let bumpLimit: Int?
    let category: String?
    let defaultName: String?
    let enableDices: Int?
    let enableFlags: Int?
    let enableIcons: Int?
    let enableLikes: Int?
    let enableNames: Int?
    let enableOekaki: Int?
    let enablePosting: Int?
    let enableSage: Int?
    let enableShield: Int?
    let enableSubject: Int?
    let enableThreadTags: Int?
    let enableTrips: Int?
    let icons: [Any]?
    let id: String?
    let name: String?
    let pages: Int?
    let sage: Int?
    let tripcodes: Int?

    private enum CodingKeys: String, CodingKey {
        case bumpLimit = "bump_limit"
        case category = "category"
        case defaultName = "default_name"
        case enableDices = "enable_dices"
        case enableFlags = "enable_flags"
        case enableIcons = "enable_icons"
        case enableLikes = "enable_likes"
        case enableNames = "enable_names"
        case enableOekaki = "enable_oekaki"
        case enablePosting = "enable_posting"
        case enableSage = "enable_sage"
        case enableShield = "enable_shield"
        case enableSubject = "enable_subject"
        case enableThreadTags = "enable_thread_tags"
        case enableTrips = "enable_trips"
        case icons = "icons"
        case id = "id"
        case name = "name"
        case pages = "pages"
        case sage = "sage"
        case tripcodes = "tripcodes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bumpLimit = try values.decodeIfPresent(Int.self, forKey: .bumpLimit)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        defaultName = try values.decodeIfPresent(String.self, forKey: .defaultName)
        enableDices = try values.decodeIfPresent(Int.self, forKey: .enableDices)
        enableFlags = try values.decodeIfPresent(Int.self, forKey: .enableFlags)
        enableIcons = try values.decodeIfPresent(Int.self, forKey: .enableIcons)
        enableLikes = try values.decodeIfPresent(Int.self, forKey: .enableLikes)
        enableNames = try values.decodeIfPresent(Int.self, forKey: .enableNames)
        enableOekaki = try values.decodeIfPresent(Int.self, forKey: .enableOekaki)
        enablePosting = try values.decodeIfPresent(Int.self, forKey: .enablePosting)
        enableSage = try values.decodeIfPresent(Int.self, forKey: .enableSage)
        enableShield = try values.decodeIfPresent(Int.self, forKey: .enableShield)
        enableSubject = try values.decodeIfPresent(Int.self, forKey: .enableSubject)
        enableThreadTags = try values.decodeIfPresent(Int.self, forKey: .enableThreadTags)
        enableTrips = try values.decodeIfPresent(Int.self, forKey: .enableTrips)
        icons = [] // TODO: Add code for decoding `icons`, It was empty at the time of model creation.
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        pages = try values.decodeIfPresent(Int.self, forKey: .pages)
        sage = try values.decodeIfPresent(Int.self, forKey: .sage)
        tripcodes = try values.decodeIfPresent(Int.self, forKey: .tripcodes)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(bumpLimit, forKey: .bumpLimit)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(defaultName, forKey: .defaultName)
        try container.encodeIfPresent(enableDices, forKey: .enableDices)
        try container.encodeIfPresent(enableFlags, forKey: .enableFlags)
        try container.encodeIfPresent(enableIcons, forKey: .enableIcons)
        try container.encodeIfPresent(enableLikes, forKey: .enableLikes)
        try container.encodeIfPresent(enableNames, forKey: .enableNames)
        try container.encodeIfPresent(enableOekaki, forKey: .enableOekaki)
        try container.encodeIfPresent(enablePosting, forKey: .enablePosting)
        try container.encodeIfPresent(enableSage, forKey: .enableSage)
        try container.encodeIfPresent(enableShield, forKey: .enableShield)
        try container.encodeIfPresent(enableSubject, forKey: .enableSubject)
        try container.encodeIfPresent(enableThreadTags, forKey: .enableThreadTags)
        try container.encodeIfPresent(enableTrips, forKey: .enableTrips)
        // TODO: Add code for encoding `icons`, It was empty at the time of model creation.
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(pages, forKey: .pages)
        try container.encodeIfPresent(sage, forKey: .sage)
        try container.encodeIfPresent(tripcodes, forKey: .tripcodes)
    }

}

struct Software: Codable {

    let bumpLimit: Int?
    let category: String?
    let defaultName: String?
    let enableDices: Int?
    let enableFlags: Int?
    let enableIcons: Int?
    let enableLikes: Int?
    let enableNames: Int?
    let enableOekaki: Int?
    let enablePosting: Int?
    let enableSage: Int?
    let enableShield: Int?
    let enableSubject: Int?
    let enableThreadTags: Int?
    let enableTrips: Int?
    let icons: [Any]?
    let id: String?
    let name: String?
    let pages: Int?
    let sage: Int?
    let tripcodes: Int?

    private enum CodingKeys: String, CodingKey {
        case bumpLimit = "bump_limit"
        case category = "category"
        case defaultName = "default_name"
        case enableDices = "enable_dices"
        case enableFlags = "enable_flags"
        case enableIcons = "enable_icons"
        case enableLikes = "enable_likes"
        case enableNames = "enable_names"
        case enableOekaki = "enable_oekaki"
        case enablePosting = "enable_posting"
        case enableSage = "enable_sage"
        case enableShield = "enable_shield"
        case enableSubject = "enable_subject"
        case enableThreadTags = "enable_thread_tags"
        case enableTrips = "enable_trips"
        case icons = "icons"
        case id = "id"
        case name = "name"
        case pages = "pages"
        case sage = "sage"
        case tripcodes = "tripcodes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bumpLimit = try values.decodeIfPresent(Int.self, forKey: .bumpLimit)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        defaultName = try values.decodeIfPresent(String.self, forKey: .defaultName)
        enableDices = try values.decodeIfPresent(Int.self, forKey: .enableDices)
        enableFlags = try values.decodeIfPresent(Int.self, forKey: .enableFlags)
        enableIcons = try values.decodeIfPresent(Int.self, forKey: .enableIcons)
        enableLikes = try values.decodeIfPresent(Int.self, forKey: .enableLikes)
        enableNames = try values.decodeIfPresent(Int.self, forKey: .enableNames)
        enableOekaki = try values.decodeIfPresent(Int.self, forKey: .enableOekaki)
        enablePosting = try values.decodeIfPresent(Int.self, forKey: .enablePosting)
        enableSage = try values.decodeIfPresent(Int.self, forKey: .enableSage)
        enableShield = try values.decodeIfPresent(Int.self, forKey: .enableShield)
        enableSubject = try values.decodeIfPresent(Int.self, forKey: .enableSubject)
        enableThreadTags = try values.decodeIfPresent(Int.self, forKey: .enableThreadTags)
        enableTrips = try values.decodeIfPresent(Int.self, forKey: .enableTrips)
        icons = [] // TODO: Add code for decoding `icons`, It was empty at the time of model creation.
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        pages = try values.decodeIfPresent(Int.self, forKey: .pages)
        sage = try values.decodeIfPresent(Int.self, forKey: .sage)
        tripcodes = try values.decodeIfPresent(Int.self, forKey: .tripcodes)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(bumpLimit, forKey: .bumpLimit)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(defaultName, forKey: .defaultName)
        try container.encodeIfPresent(enableDices, forKey: .enableDices)
        try container.encodeIfPresent(enableFlags, forKey: .enableFlags)
        try container.encodeIfPresent(enableIcons, forKey: .enableIcons)
        try container.encodeIfPresent(enableLikes, forKey: .enableLikes)
        try container.encodeIfPresent(enableNames, forKey: .enableNames)
        try container.encodeIfPresent(enableOekaki, forKey: .enableOekaki)
        try container.encodeIfPresent(enablePosting, forKey: .enablePosting)
        try container.encodeIfPresent(enableSage, forKey: .enableSage)
        try container.encodeIfPresent(enableShield, forKey: .enableShield)
        try container.encodeIfPresent(enableSubject, forKey: .enableSubject)
        try container.encodeIfPresent(enableThreadTags, forKey: .enableThreadTags)
        try container.encodeIfPresent(enableTrips, forKey: .enableTrips)
        // TODO: Add code for encoding `icons`, It was empty at the time of model creation.
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(pages, forKey: .pages)
        try container.encodeIfPresent(sage, forKey: .sage)
        try container.encodeIfPresent(tripcodes, forKey: .tripcodes)
    }

}

struct JapanesCulture: Codable {

    let bumpLimit: Int?
    let category: String?
    let defaultName: String?
    let enableDices: Int?
    let enableFlags: Int?
    let enableIcons: Int?
    let enableLikes: Int?
    let enableNames: Int?
    let enableOekaki: Int?
    let enablePosting: Int?
    let enableSage: Int?
    let enableShield: Int?
    let enableSubject: Int?
    let enableThreadTags: Int?
    let enableTrips: Int?
    let icons: [Any]?
    let id: String?
    let name: String?
    let pages: Int?
    let sage: Int?
    let tripcodes: Int?

    private enum CodingKeys: String, CodingKey {
        case bumpLimit = "bump_limit"
        case category = "category"
        case defaultName = "default_name"
        case enableDices = "enable_dices"
        case enableFlags = "enable_flags"
        case enableIcons = "enable_icons"
        case enableLikes = "enable_likes"
        case enableNames = "enable_names"
        case enableOekaki = "enable_oekaki"
        case enablePosting = "enable_posting"
        case enableSage = "enable_sage"
        case enableShield = "enable_shield"
        case enableSubject = "enable_subject"
        case enableThreadTags = "enable_thread_tags"
        case enableTrips = "enable_trips"
        case icons = "icons"
        case id = "id"
        case name = "name"
        case pages = "pages"
        case sage = "sage"
        case tripcodes = "tripcodes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bumpLimit = try values.decodeIfPresent(Int.self, forKey: .bumpLimit)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        defaultName = try values.decodeIfPresent(String.self, forKey: .defaultName)
        enableDices = try values.decodeIfPresent(Int.self, forKey: .enableDices)
        enableFlags = try values.decodeIfPresent(Int.self, forKey: .enableFlags)
        enableIcons = try values.decodeIfPresent(Int.self, forKey: .enableIcons)
        enableLikes = try values.decodeIfPresent(Int.self, forKey: .enableLikes)
        enableNames = try values.decodeIfPresent(Int.self, forKey: .enableNames)
        enableOekaki = try values.decodeIfPresent(Int.self, forKey: .enableOekaki)
        enablePosting = try values.decodeIfPresent(Int.self, forKey: .enablePosting)
        enableSage = try values.decodeIfPresent(Int.self, forKey: .enableSage)
        enableShield = try values.decodeIfPresent(Int.self, forKey: .enableShield)
        enableSubject = try values.decodeIfPresent(Int.self, forKey: .enableSubject)
        enableThreadTags = try values.decodeIfPresent(Int.self, forKey: .enableThreadTags)
        enableTrips = try values.decodeIfPresent(Int.self, forKey: .enableTrips)
        icons = [] // TODO: Add code for decoding `icons`, It was empty at the time of model creation.
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        pages = try values.decodeIfPresent(Int.self, forKey: .pages)
        sage = try values.decodeIfPresent(Int.self, forKey: .sage)
        tripcodes = try values.decodeIfPresent(Int.self, forKey: .tripcodes)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(bumpLimit, forKey: .bumpLimit)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(defaultName, forKey: .defaultName)
        try container.encodeIfPresent(enableDices, forKey: .enableDices)
        try container.encodeIfPresent(enableFlags, forKey: .enableFlags)
        try container.encodeIfPresent(enableIcons, forKey: .enableIcons)
        try container.encodeIfPresent(enableLikes, forKey: .enableLikes)
        try container.encodeIfPresent(enableNames, forKey: .enableNames)
        try container.encodeIfPresent(enableOekaki, forKey: .enableOekaki)
        try container.encodeIfPresent(enablePosting, forKey: .enablePosting)
        try container.encodeIfPresent(enableSage, forKey: .enableSage)
        try container.encodeIfPresent(enableShield, forKey: .enableShield)
        try container.encodeIfPresent(enableSubject, forKey: .enableSubject)
        try container.encodeIfPresent(enableThreadTags, forKey: .enableThreadTags)
        try container.encodeIfPresent(enableTrips, forKey: .enableTrips)
        // TODO: Add code for encoding `icons`, It was empty at the time of model creation.
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(pages, forKey: .pages)
        try container.encodeIfPresent(sage, forKey: .sage)
        try container.encodeIfPresent(tripcodes, forKey: .tripcodes)
    }

}
