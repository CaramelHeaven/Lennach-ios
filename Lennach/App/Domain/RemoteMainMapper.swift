//
//  BoardMapper.swift
//  Lennach
//
//  Created by Sergey Fominov on 18/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import Foundation

class RemoteMainMapper {
    func mapResponseToBoardUseCase(response: BoardResponse) -> Board {
        var board = Board()

        for item in Array(response.threads![0..<10]) {
            let usenet = Usenet(threadNum: item.num!, threadMsg: item.comment!, thumbnail: item.files![0].path!, date: item.date!)

            board.usenets.append(usenet)
        }

        return board
    }

    func mapResponseToThreadCommentsUseCase(response: [ThreadResponse]) -> [Comment] {
        var comments = [Comment]()

        for item in response {
            //Fill files
            var pictures = [Picture]()
            if let files = item.files {
                for file in files {
                    pictures.append(Picture(displayName: file.displayname!, path: file.path!))
                }
            }

            //Fill base data in comment
            comments.append(Comment(num: item.num!, name: item.name!, comment: item.comment!, date: item.date!, files: pictures.count != 0 ? pictures : nil))
        }

        return comments
    }
}
