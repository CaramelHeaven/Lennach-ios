//
//  BoardResponseHelper.swift
//  Lennach
//
//  Created by Sergey Fominov on 18/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//
// This helper for BoardResponse request
//

import Foundation

struct UsenetsBoardResponse: Codable {
    
    let banned: Int?
    let closed: Int?
    let comment: String?
    let date: String?
    let email: String?
    let endless: Int?
    let files: [FilesBoardResponse]?
    let filesCount: Int?
    let lasthit: Int?
    let name: String?
    let num: String?
    let op: Int?
    let parent: String?
    let postsCount: Int?
    let sticky: Int?
    let subject: String?
    let tags: String?
    let timestamp: Int?
    let trip: String?
    
    private enum CodingKeys: String, CodingKey {
        case banned = "banned"
        case closed = "closed"
        case comment = "comment"
        case date = "date"
        case email = "email"
        case endless = "endless"
        case files = "files"
        case filesCount = "files_count"
        case lasthit = "lasthit"
        case name = "name"
        case num = "num"
        case op = "op"
        case parent = "parent"
        case postsCount = "posts_count"
        case sticky = "sticky"
        case subject = "subject"
        case tags = "tags"
        case timestamp = "timestamp"
        case trip = "trip"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        banned = try values.decodeIfPresent(Int.self, forKey: .banned)
        closed = try values.decodeIfPresent(Int.self, forKey: .closed)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        endless = try values.decodeIfPresent(Int.self, forKey: .endless)
        files = try values.decodeIfPresent([FilesBoardResponse].self, forKey: .files)
        filesCount = try values.decodeIfPresent(Int.self, forKey: .filesCount)
        lasthit = try values.decodeIfPresent(Int.self, forKey: .lasthit)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        num = try values.decodeIfPresent(String.self, forKey: .num)
        op = try values.decodeIfPresent(Int.self, forKey: .op)
        parent = try values.decodeIfPresent(String.self, forKey: .parent)
        postsCount = try values.decodeIfPresent(Int.self, forKey: .postsCount)
        sticky = try values.decodeIfPresent(Int.self, forKey: .sticky)
        subject = try values.decodeIfPresent(String.self, forKey: .subject)
        tags = try values.decodeIfPresent(String.self, forKey: .tags)
        timestamp = try values.decodeIfPresent(Int.self, forKey: .timestamp)
        trip = try values.decodeIfPresent(String.self, forKey: .trip)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(banned, forKey: .banned)
        try container.encodeIfPresent(closed, forKey: .closed)
        try container.encodeIfPresent(comment, forKey: .comment)
        try container.encodeIfPresent(date, forKey: .date)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(endless, forKey: .endless)
        try container.encodeIfPresent(files, forKey: .files)
        try container.encodeIfPresent(filesCount, forKey: .filesCount)
        try container.encodeIfPresent(lasthit, forKey: .lasthit)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(num, forKey: .num)
        try container.encodeIfPresent(op, forKey: .op)
        try container.encodeIfPresent(parent, forKey: .parent)
        try container.encodeIfPresent(postsCount, forKey: .postsCount)
        try container.encodeIfPresent(sticky, forKey: .sticky)
        try container.encodeIfPresent(subject, forKey: .subject)
        try container.encodeIfPresent(tags, forKey: .tags)
        try container.encodeIfPresent(timestamp, forKey: .timestamp)
        try container.encodeIfPresent(trip, forKey: .trip)
    }
    
}

struct FilesBoardResponse: Codable {
    
    let displayname: String?
    let fullname: String?
    let height: Int?
    let md5: String?
    let name: String?
    let nsfw: Int?
    let path: String?
    let size: Int?
    let thumbnail: String?
    let tnHeight: Int?
    let tnWidth: Int?
    let type: Int?
    let width: Int?
    
    private enum CodingKeys: String, CodingKey {
        case displayname = "displayname"
        case fullname = "fullname"
        case height = "height"
        case md5 = "md5"
        case name = "name"
        case nsfw = "nsfw"
        case path = "path"
        case size = "size"
        case thumbnail = "thumbnail"
        case tnHeight = "tn_height"
        case tnWidth = "tn_width"
        case type = "type"
        case width = "width"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        displayname = try values.decodeIfPresent(String.self, forKey: .displayname)
        fullname = try values.decodeIfPresent(String.self, forKey: .fullname)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
        md5 = try values.decodeIfPresent(String.self, forKey: .md5)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        nsfw = try values.decodeIfPresent(Int.self, forKey: .nsfw)
        path = try values.decodeIfPresent(String.self, forKey: .path)
        size = try values.decodeIfPresent(Int.self, forKey: .size)
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
        tnHeight = try values.decodeIfPresent(Int.self, forKey: .tnHeight)
        tnWidth = try values.decodeIfPresent(Int.self, forKey: .tnWidth)
        type = try values.decodeIfPresent(Int.self, forKey: .type)
        width = try values.decodeIfPresent(Int.self, forKey: .width)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(displayname, forKey: .displayname)
        try container.encodeIfPresent(fullname, forKey: .fullname)
        try container.encodeIfPresent(height, forKey: .height)
        try container.encodeIfPresent(md5, forKey: .md5)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(nsfw, forKey: .nsfw)
        try container.encodeIfPresent(path, forKey: .path)
        try container.encodeIfPresent(size, forKey: .size)
        try container.encodeIfPresent(thumbnail, forKey: .thumbnail)
        try container.encodeIfPresent(tnHeight, forKey: .tnHeight)
        try container.encodeIfPresent(tnWidth, forKey: .tnWidth)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(width, forKey: .width)
    }
    
}
