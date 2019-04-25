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
        RemoteRepository.instance.getThreadsByBoard(boardName: "pr", page: "1") { (state, data, error) in
            completion(state, data, error)
        }
    }

    public func provideMessagesByThread(_ board: String, _ num: String, completion: @escaping (Bool, Any?, Error?) -> Void) {
        RemoteRepository.instance.getCommentsByThread(boardName: board, threadNum: num) { (result, data, error) in
            completion(result, data, error)
        }
    }
}
