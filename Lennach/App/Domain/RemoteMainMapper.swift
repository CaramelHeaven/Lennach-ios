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

        for item in response.threads! {
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

    func mapResponseToAllBoards(response: AllBoardsResponse) -> AllBoards {
        var allBoards = AllBoards()

        //Below we search all arrays and add each element to common array inside allBoards variable
        for item in response.users! {
            allBoards.boards.append(BoardDescription(name: item.name!, bumpLimit: item.bumpLimit!, id: item.id!))
        }

        for item in response.subjects! {
            allBoards.boards.append(BoardDescription(name: item.name!, bumpLimit: item.bumpLimit!, id: item.id!))
        }

        for item in response.software! {
            allBoards.boards.append(BoardDescription(name: item.name!, bumpLimit: item.bumpLimit!, id: item.id!))
        }

//        for item in response.forAdults! {
//            allBoards.boards.append(BoardDescription(name: item.name!, bumpLimit: item.bumpLimit!, id: item.id!))
//        }

        for item in response.differences! {
            allBoards.boards.append(BoardDescription(name: item.name!, bumpLimit: item.bumpLimit!, id: item.id!))
        }

        for item in response.creation! {
            allBoards.boards.append(BoardDescription(name: item.name!, bumpLimit: item.bumpLimit!, id: item.id!))
        }

        for item in response.games! {
            allBoards.boards.append(BoardDescription(name: item.name!, bumpLimit: item.bumpLimit!, id: item.id!))
        }

        for item in response.japanesCulture! {
            allBoards.boards.append(BoardDescription(name: item.name!, bumpLimit: item.bumpLimit!, id: item.id!))
        }

        for item in response.politics! {
            allBoards.boards.append(BoardDescription(name: item.name!, bumpLimit: item.bumpLimit!, id: item.id!))
        }

        return allBoards
    }
}
