//
//  FilesThreadResponse.swift
//  Lennach
//
//  Created by Sergey Fominov on 25/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import Foundation

struct FilesThreadResponse: Codable {
    
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
