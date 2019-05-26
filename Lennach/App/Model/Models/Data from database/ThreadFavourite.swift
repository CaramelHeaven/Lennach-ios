//
//  ThreadFavourite.swift
//  Lennach
//
//  Created by Sergey Fominov on 20/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import Foundation

enum ProgressUpdateThreadFavourite {
    case startLoading, stopLoading
}

class ThreadFavourite {
    var boardName: String
    var numThread: String
    var imageUrl: String
    var quantityPosts: Int
    var opMessage: String

    //helper fields
    var countNewMessages: Int?
    weak var timerUpdate: Timer?
    var permissionToUpdate = true, permissionForFirstLoading = true


    init(boardName: String, numThread: String, imageUrl: String, quantityPosts: Int, opMessage: String) {
        self.boardName = boardName
        self.numThread = numThread
        self.imageUrl = imageUrl
        self.quantityPosts = quantityPosts
        self.opMessage = opMessage
    }

    func updateCountMessages(completable: @escaping (ProgressUpdateThreadFavourite, Any?) -> ()) {
        if permissionToUpdate {
            permissionToUpdate = false

            timerUpdate?.invalidate()

            timerUpdate = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { _ in
                completable(.startLoading, "")

                MainRepository.instance.provideUpdateCountMsgsInThreadFavourite(self.boardName, self.numThread, completion: { value in
                    completable(.stopLoading, value)

                    self.permissionToUpdate = true
                })
            })
        }
    }

    func updateFirstLoadingData(completable: @escaping (ProgressUpdateThreadFavourite, Any?) -> ()) {
        if permissionForFirstLoading {
            MainRepository.instance.provideUpdateCountMsgsInThreadFavourite(self.boardName, self.numThread, completion: { value in
                completable(.stopLoading, value)

                self.permissionForFirstLoading = false
            })
        }
    }

    func clearTimer() {
        timerUpdate?.invalidate()
    }

    deinit {
        print("thread FAVOURITE DEINIT")
        timerUpdate?.invalidate()
    }
}
