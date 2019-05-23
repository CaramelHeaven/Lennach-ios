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

        for item in response.threads![0..<40] {
            let usenet = Usenet(threadNum: item.num!, threadMsg: item.comment!, thumbnail: item.files![0].path!, date: item.date!, thumbnailName: item.files![0].displayname!)

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
                .replacingOccurrences(of: "&quot;", with: "")
                .replacingOccurrences(of: "&#47;", with: "")

            //make \n after >>2834 reply, (>>\d*\s\(OP\)*)
            let arrayOfReferences = getArrayOfReplies(reply, regular: #"(>>\d*)"#)
            for item in arrayOfReferences {
                if let range = reply.range(of: item) {
                    let endPos = reply.distance(from: reply.startIndex, to: range.upperBound)
                    let index = reply.index(reply.startIndex, offsetBy: endPos)

                    var beforeIndexStr = String(reply[..<index])
                    var afterIndexStr = String(reply[index...])

                    if afterIndexStr.contains("(OP)") {
                        afterIndexStr = afterIndexStr.replacingOccurrences(of: "(OP)", with: "")
                        beforeIndexStr.append(" (OP)")
                    }
                    reply = beforeIndexStr + "\n" + afterIndexStr
                }
            }

            let comment = Comment(num: item.num!, name: item.name!, comment: reply, date: item.date!, modernComment: makeModernComment(baseComment: reply), repliesContent: [String](), files: pictures.count != 0 ? pictures : nil, containerRerefences: arrayOfReferences)

            return comment
        }

        comments.forEach { (comment) in
            for item in comment.containerRerefences {
                let numItem = item.filter("0123456789".contains)

                if let index = comments.firstIndex(where: { $0.num == numItem }) {
                    comments[index].repliesContent?.append(comment.num)
                }
            }
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

    func makeModernComment(baseComment: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: baseComment)
        let lines = baseComment.components(separatedBy: "\n")

        for line in lines {
            if line.contains(">>") {
                var dividedReplies = line.components(separatedBy: ">>")

                if dividedReplies[0] == "" { dividedReplies.removeFirst() }
                for item in dividedReplies {
                    let urlSchemaValue = filteringLine(item, regular: #"(^\d+)"#)
                    let selectableStr = item.contains("(OP)") ? filteringLine(">>" + item, regular: #"(>>\d*\s*\(OP\))"#) : ">>" + urlSchemaValue

                    attributedString.addAttribute(.link, value: urlSchemaValue + "://" + urlSchemaValue, range: (attributedString.string as NSString).range(of: selectableStr))
                }
            }
        }

        return attributedString
    }

    //"(>>\d*)"#
    func filteringLine(_ line: String, regular: String) -> String {
        var str = ""
        let pattern = #"\#(regular)"#
        print("PATTERN: \(pattern)")
        let regex = try! NSRegularExpression(pattern: pattern)
        regex.enumerateMatches(in: line, range: NSRange(line.startIndex..., in: line)) { match, _, _ in
            if let nsRange = match?.range(at: 1), let range = Range(nsRange, in: line) {
                str = String(line[range])
            }
        }

        return str
    }

    func getArrayOfReplies(_ lines: String, regular: String) -> [String] {
        var arrayReplies = [String]()
        let pattern = #"\#(regular)"#
        let regex = try! NSRegularExpression(pattern: pattern)
        regex.enumerateMatches(in: lines, range: NSRange(lines.startIndex..., in: lines)) { match, _, _ in
            if let nsRange = match?.range(at: 1), let range = Range(nsRange, in: lines) {
                arrayReplies.append(String(lines[range]))
            }
        }

        print("ARRAY OF REPLIES: \(arrayReplies)")
        return arrayReplies
    }
}
