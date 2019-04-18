//
//  BoardMapper.swift
//  Lennach
//
//  Created by Sergey Fominov on 18/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import Foundation

class BoardMapper {
    func mapResponseToBoardUseCase(response: BoardResponse) -> Board {
        var board = Board()

        for item in response.threads! {
            let post = item.posts![0]
            let usenet = Usenet(threadNum: item.threadNum!, threadMsg: post.comment!, thumbnail: post.files![0].thumbnail!, threadData: post.date!)

            board.usenets.append(usenet)
        }

        return board
    }
}
