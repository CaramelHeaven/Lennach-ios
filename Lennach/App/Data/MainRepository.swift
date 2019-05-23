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
    private var threadNum = "" // caching thread num for situation if user will saving it to favourites

    var data = [Comment]()

    private init() { }

    //MARK: Remote
    public func provideThreadsByBoard(board: String, completion: @escaping (Bool, Any?, Error?) -> Void) {
        currentBoard = board

        RemoteRepository.instance.getThreadsByBoard(boardName: currentBoard) { (state, data, error) in
            completion(state, data, error)
        }
    }

    public func provideMessagesByThread(_ num: String, completion: @escaping (Bool, Any?, Error?) -> Void) {
        threadNum = num

        RemoteRepository.instance.getCommentsByThread(boardName: currentBoard, threadNum: num) { (result, data, error) in
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

    func provideSavingThreadToFavourite(comments: [Comment], completion: @escaping (Bool) -> Void) {
        //FIXME: comment is empty, because we used modern comment
        LocalRepository.instance.provideAddToFavouriteThread(boardName: currentBoard, numThread: threadNum, imageUrl: comments[0].files![0].path, quantityPosts: comments.count, opMessage: comments[0].comment) { result in
            completion(result)
        }
    }

    func provideSavedFavouritesThreadFromDatabase(completion: @escaping ([ThreadFavourite]?) -> Void) {
        LocalRepository.instance.provideSavedFavouritesBoard { objects in
            if let data = objects as? [ThreadFavourite] {
                completion(data)
            } else {
                completion(nil)
            }
        }
    }

    func provideDeleteBoardFromNavigation(_ boardId: String, completion: @escaping (Bool) -> Void) {
        LocalRepository.instance.provideRemoveBoardFromNavigation(idBoard: boardId) { result in
            completion(result)
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
