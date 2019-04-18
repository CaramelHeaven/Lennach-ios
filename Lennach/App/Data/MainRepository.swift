//
//  MainRepository.swift
//  Lennach
//
//  Created by Sergey Fominov on 13/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import Foundation

class MainRepository {
    static let instance = MainRepository()

    var data = [Comment]()

    private init() {
    }

    public func provideThreadsByBoard(completion: @escaping (Bool, Any?, Error?) -> Void) {
        RemoteRepository.instance.getThreadsByBoard(boardName: "b", page: "1") { (state, data, error) in
            completion(state, data, error)
        }
    }

    public func provideCommentData() -> [Comment] {
        let comment = Comment(kek: "1")

        data.append(comment)
        data.append(comment)
        data.append(comment)
        data.append(comment)
        data.append(comment)
        data.append(comment)
        data.append(comment)

        let com = Comment(kek: "2")
        data.append(com)
        data.append(com)
        data.append(com)

        return data
    }
}
