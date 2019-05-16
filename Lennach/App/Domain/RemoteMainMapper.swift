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
        var comments = [Comment]()

        for item in response {
            //Fill files
            var pictures = [Picture]()
            if let files = item.files {
                for file in files {
                    pictures.append(Picture(displayName: file.displayname!, path: file.path!))
                }
            }

            let comment = Comment(num: item.num!, name: item.name!, comment: item.comment!.stripOutHtml()!, date: item.date!, modernComment: makeModernComment(baseComment: item.comment!.stripOutHtml()!), repliesContent: [String](), files: pictures.count != 0 ? pictures : nil)
            comments.append(comment)

            comments = counterRepliesToEachComment(currentComment: comment, list: comments)
        }
        print("after all actions: \(comments)")

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
    func counterRepliesToEachComment(currentComment: Comment, list: [Comment]) -> [Comment] {
        var usedReferences = [String]()
        var futureList = list
        let lines = currentComment.comment.components(separatedBy: "\n")

        for line in lines {
            if line.contains(">>") {
                let result = line.filter("0123456789".contains)

                if usedReferences.contains(result) { break }
                usedReferences.append(result)

                futureList = futureList.map { (comment) -> Comment in
                    if comment.num == result {
                        var replies = comment.repliesContent!
                        replies.append(currentComment.num)

                        return Comment(num: comment.num, name: comment.name, comment: comment.comment, date: comment.date, modernComment: comment.modernComment, repliesContent: replies, files: comment.files)
                    }
                    return comment
                }
            }
        }
        return futureList
    }

    func makeModernComment(baseComment: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: baseComment)
        let lines = baseComment.components(separatedBy: "\n")

        for line in lines {
            print("line: \(line)")
            if line.contains(">>") {
                let reference = (line.filter("0123456789>>(OP)".contains))
                    .replacingOccurrences(of: " ", with: "")
                let stringForRange = line.filter("0123456789 >>(OP)".contains)

                var localArray = (reference.components(separatedBy: ">>"))
                localArray.removeFirst()
                print("localArray: \(localArray)")
                for item in localArray {
                    print("STARTED")
                    let filteringValue = item.filter("0123456789".contains)
                    print("reference: \(reference), filtering value: \(filteringValue), range: \((attributedString.string as NSString).range(of: item))")
                    print("attributed string: \(attributedString.string)")
                    attributedString.addAttribute(.link, value: filteringValue + "://" + filteringValue, range: (attributedString.string as NSString).range(of: stringForRange))
                }


//                attributedString.addAttribute(.link, value: reference.filter("0123456789".contains) + "://" + reference, range: (attributedString.string as NSString).range(of: reference))
            }
        }

        return attributedString
    }
}

extension String {
    func stripOutHtml() -> String? {
        do {
            guard let data = self.data(using: .unicode) else {
                return nil
            }
            let attributed = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            return attributed.string
        } catch {
            return nil
        }
    }
}
