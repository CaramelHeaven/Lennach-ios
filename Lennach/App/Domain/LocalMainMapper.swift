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
}
