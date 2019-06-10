//
//  AllBoardsResponse.swift
//  Lennach
//
//  Created by Sergey Fominov on 02/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import Foundation

struct AllBoardsResponse: Codable {

    let games: [Games]?
    let politics: [Politics]?
    let users: [Users]?
    let differences: [Differences]?
    let creation: [Creation]?
    let subjects: [Subjects]?
    let software: [Software]?
    let travel: [Travel]?

    private enum CodingKeys: String, CodingKey {
        case games = "Игры"
        case politics = "Политика"
        case users = "Пользовательские"
        case differences = "Разное"
        case creation = "Творчество"
        case subjects = "Тематика"
        case software = "Техника и софт"
        case travel = "Путешествия и культура"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        games = try values.decodeIfPresent([Games].self, forKey: .games)
        politics = try values.decodeIfPresent([Politics].self, forKey: .politics)
        users = try values.decodeIfPresent([Users].self, forKey: .users)
        differences = try values.decodeIfPresent([Differences].self, forKey: .differences)
        creation = try values.decodeIfPresent([Creation].self, forKey: .creation)
        subjects = try values.decodeIfPresent([Subjects].self, forKey: .subjects)
        software = try values.decodeIfPresent([Software].self, forKey: .software)
        travel = try values.decodeIfPresent([Travel].self, forKey: .travel)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(games, forKey: .games)
        try container.encodeIfPresent(politics, forKey: .politics)
        try container.encodeIfPresent(users, forKey: .users)
        try container.encodeIfPresent(differences, forKey: .differences)
        try container.encodeIfPresent(creation, forKey: .creation)
        try container.encodeIfPresent(subjects, forKey: .subjects)
        try container.encodeIfPresent(software, forKey: .software)
        try container.encodeIfPresent(travel, forKey: .travel)
    }

}
