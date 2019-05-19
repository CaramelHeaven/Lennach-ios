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

        for item in response.threads![0..<20] {
            let usenet = Usenet(threadNum: item.num!, threadMsg: item.comment!, thumbnail: item.files![0].path!, date: item.date!)

            board.usenets.append(usenet)
        }

        return board
    }

    func mapResponseToThreadCommentsUseCase(response: [ThreadResponse]) -> [Comment] {
        var comments = response.map { (item) -> Comment in
            var pictures = [Picture]()
            if let files = item.files {
                for file in files {
                    pictures.append(Picture(displayName: file.displayname!, path: file.path!))
                }
            }

            var reply = item.comment!.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            reply = reply.replacingOccurrences(of: "&gt;", with: "")

            let comment = Comment(num: item.num!, name: item.name!, comment: "", date: item.date!, modernComment: makeModernComment(baseComment: reply), repliesContent: [String](), files: pictures.count != 0 ? pictures : nil)

            return comment
        }

        comments.forEach { (comment) in
            counterRepliesToEachComment(currentComment: comment, list: &comments)
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

extension RemoteMainMapper {
    func counterRepliesToEachComment(currentComment: Comment, list: inout [Comment]) {
        var usedReferences = [String]()
        var lines = currentComment.comment.components(separatedBy: "\n")
        lines = lines.filter { $0.contains(">>") }

        for line in lines {
            let result = line.filter("0123456789".contains)

            if usedReferences.contains(result) { break }
            usedReferences.append(result)

            if let index = list.lastIndex(where: { $0.num == result }) {
                var replies = list[index].repliesContent!
                replies.append(currentComment.num)

                list[index].repliesContent?.append(currentComment.num)
            }
        }
    }

    func makeModernComment(baseComment: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: baseComment)
        let lines = baseComment.components(separatedBy: "\n")

        for line in lines {
            if line.contains(">>") {
                let reference = (line.filter("0123456789>>(OP)".contains))
                    .replacingOccurrences(of: " ", with: "")
                let stringForRange = line.filter("0123456789 >>(OP)".contains)

                var localArray = (reference.components(separatedBy: ">>"))
                localArray.removeFirst()
                for item in localArray {
                    let filteringValue = item.filter("0123456789".contains)

                    attributedString.addAttribute(.link, value: filteringValue + "://" + filteringValue, range: (attributedString.string as NSString).range(of: stringForRange))
                }
            }
        }

        return attributedString
    }

    func showCurrentTime() {
        let dateFormatter: DateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        let interval = date.timeIntervalSince1970

        print("CurrentTime: \(dateString), interval: \(interval)")
    }
}
