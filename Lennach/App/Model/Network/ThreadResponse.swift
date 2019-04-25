//
//  ThreadResponse.swift
//  Lennach
//
//  Created by Sergey Fominov on 25/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import Foundation

struct ThreadResponse: Codable {

    let banned: Int?
    let closed: Int?
    let comment: String?
    let date: String?
    let email: String?
    let endless: Int?
    let files: [FilesThreadResponse]?
    let lasthit: Int?
    let name: String?
    let num: String?
    let op: Int?
    let parent: String?
    let sticky: Int?
    let subject: String?
    let tags: String?
    let timestamp: Int?
    let trip: String?
    let tripType: String?
    let uniquePosters: String?

    private enum CodingKeys: String, CodingKey {
        case banned = "banned"
        case closed = "closed"
        case comment = "comment"
        case date = "date"
        case email = "email"
        case endless = "endless"
        case files = "files"
        case lasthit = "lasthit"
        case name = "name"
        case num = "num"
        case op = "op"
        case parent = "parent"
        case sticky = "sticky"
        case subject = "subject"
        case tags = "tags"
        case timestamp = "timestamp"
        case trip = "trip"
        case tripType = "trip_type"
        case uniquePosters = "unique_posters"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        banned = try values.decodeIfPresent(Int.self, forKey: .banned)
        closed = try values.decodeIfPresent(Int.self, forKey: .closed)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        endless = try values.decodeIfPresent(Int.self, forKey: .endless)
        files = try values.decodeIfPresent([FilesThreadResponse].self, forKey: .files)
        lasthit = try values.decodeIfPresent(Int.self, forKey: .lasthit)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        num = try values.decodeIfPresent(String.self, forKey: .num)
        op = try values.decodeIfPresent(Int.self, forKey: .op)
        parent = try values.decodeIfPresent(String.self, forKey: .parent)
        sticky = try values.decodeIfPresent(Int.self, forKey: .sticky)
        subject = try values.decodeIfPresent(String.self, forKey: .subject)
        tags = try values.decodeIfPresent(String.self, forKey: .tags)
        timestamp = try values.decodeIfPresent(Int.self, forKey: .timestamp)
        trip = try values.decodeIfPresent(String.self, forKey: .trip)
        tripType = try values.decodeIfPresent(String.self, forKey: .tripType)
        uniquePosters = try values.decodeIfPresent(String.self, forKey: .uniquePosters)
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
        try container.encodeIfPresent(lasthit, forKey: .lasthit)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(num, forKey: .num)
        try container.encodeIfPresent(op, forKey: .op)
        try container.encodeIfPresent(parent, forKey: .parent)
        try container.encodeIfPresent(sticky, forKey: .sticky)
        try container.encodeIfPresent(subject, forKey: .subject)
        try container.encodeIfPresent(tags, forKey: .tags)
        try container.encodeIfPresent(timestamp, forKey: .timestamp)
        try container.encodeIfPresent(trip, forKey: .trip)
        try container.encodeIfPresent(tripType, forKey: .tripType)
        try container.encodeIfPresent(uniquePosters, forKey: .uniquePosters)
    }
}
