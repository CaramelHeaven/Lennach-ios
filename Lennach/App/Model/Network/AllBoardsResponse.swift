//
//  AllBoardsResponse.swift
//  Lennach
//
//  Created by Sergey Fominov on 02/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import Foundation

struct AllBoardsResponse: Codable {

    let forAdults: [ForAdults]?
    let games: [Games]?
    let politics: [Politics]?
    let users: [Users]?
    let differences: [Differences]?
    let creation: [Creation]?
    let subjects: [Subjects]?
    let software: [Software]?
    let japanesCulture: [JapanesCulture]?

    private enum CodingKeys: String, CodingKey {
        case forAdults = "Взрослым"
        case games = "Игры"
        case politics = "Политика"
        case users = "Пользовательские"
        case differences = "Разное"
        case creation = "Творчество"
        case subjects = "Тематика"
        case software = "Техника и софт"
        case japanesCulture = "Японская культура"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        forAdults = try values.decodeIfPresent([ForAdults].self, forKey: .forAdults)
        games = try values.decodeIfPresent([Games].self, forKey: .games)
        politics = try values.decodeIfPresent([Politics].self, forKey: .politics)
        users = try values.decodeIfPresent([Users].self, forKey: .users)
        differences = try values.decodeIfPresent([Differences].self, forKey: .differences)
        creation = try values.decodeIfPresent([Creation].self, forKey: .creation)
        subjects = try values.decodeIfPresent([Subjects].self, forKey: .subjects)
        software = try values.decodeIfPresent([Software].self, forKey: .software)
        japanesCulture = try values.decodeIfPresent([JapanesCulture].self, forKey: .japanesCulture)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(forAdults, forKey: .forAdults)
        try container.encodeIfPresent(games, forKey: .games)
        try container.encodeIfPresent(politics, forKey: .politics)
        try container.encodeIfPresent(users, forKey: .users)
        try container.encodeIfPresent(differences, forKey: .differences)
        try container.encodeIfPresent(creation, forKey: .creation)
        try container.encodeIfPresent(subjects, forKey: .subjects)
        try container.encodeIfPresent(software, forKey: .software)
        try container.encodeIfPresent(japanesCulture, forKey: .japanesCulture)
    }

}
