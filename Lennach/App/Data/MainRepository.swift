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
    private var currentBoard = ""

    var data = [Comment]()

    private init() { }

    //MARK: Remote
    public func provideThreadsByBoard(board: String, completion: @escaping (Bool, Any?, Error?) -> Void) {
        currentBoard = board

        RemoteRepository.instance.getThreadsByBoard(boardName: currentBoard, page: "1") { (state, data, error) in
            completion(state, data, error)
        }
    }

    public func provideMessagesByThread(_ num: String, completion: @escaping (Bool, Any?, Error?) -> Void) {
        RemoteRepository.instance.getCommentsByThread(boardName: "b", threadNum: "196498331") { (result, data, error) in
            completion(result, data, error)
        }
    }

    func provideGetCaptcha(threadNum: String) {
        
    }

    //MARK: Local
    public func provideAllBoards(completion: @escaping (Bool, Any?) -> Void) {
        let group = DispatchGroup()

        var localBoards: [BoardDescription] = []
        var remoteBoards: [BoardDescription] = []

        group.enter()
        LocalRepository.instance.provideReadUserSavedBoards(completion: { (data) in
            localBoards = data as! [BoardDescription]
            group.leave()
        })

        group.enter()
        RemoteRepository.instance.getAllBoards { (result, data) in
            remoteBoards = (data as! AllBoards).boards
            group.leave()
        }

        group.notify(queue: DispatchQueue.main) {
            completion(true, self.diffBoards(local: localBoards, remote: remoteBoards))
        }
    }
}

extension MainRepository {
    private func diffBoards(local: Array<BoardDescription>, remote: Array<BoardDescription>) -> [BoardDescription] {
        var diffBoards = remote
        local.forEach { (localBoard) in
            if let index = diffBoards.firstIndex(where: { $0.id == localBoard.id }) {
                diffBoards.remove(at: index)
            }
        }

        return diffBoards
    }
}
