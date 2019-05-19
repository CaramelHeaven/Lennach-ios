//
//  LocalMainMapper.swift
//  Lennach
//
//  Created by Sergey Fominov on 25/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import Foundation

class LocalMainMapper {

    func mapNavigationBoardDataToDatabase(board: BoardDescription, boardDb: inout BoardDb) {
        boardDb.idName = board.id
    }

    func mapDatabaseBoardToBusinessObjects(boardDb: [BoardDb]) -> [BoardDescription] {
        var boards = Array<BoardDescription>()
        for item in boardDb {
            boards.append(BoardDescription(name: "", bumpLimit: 0, id: item.idName!))
        }

        return boards
    }

    func mapThreadToFavouriteInDatabase(_ savedThread: ThreadFavourite, threadDb: inout FavouriteThreadDb) {
        threadDb.boardName = savedThread.boardName
        threadDb.imageUrlThread = savedThread.imageUrl
        threadDb.numThread = savedThread.numThread
        threadDb.opMessage = savedThread.opMessage
        threadDb.quantityPosts = Int32(savedThread.quantityPosts)
    }

    func mapDatabaseFavouriteThreadsToBusinessObjects(threadsDb: [FavouriteThreadDb]) -> [ThreadFavourite] {
        var favourites = [ThreadFavourite]()
        for item in threadsDb {
            favourites.append(ThreadFavourite(boardName: item.boardName!, numThread: item.numThread!, imageUrl: item.imageUrlThread!, quantityPosts: Int(item.quantityPosts), opMessage: item.opMessage!))
        }

        return favourites
    }
}
