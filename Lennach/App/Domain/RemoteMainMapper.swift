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

        for item in response.threads![0..<80] {

            let usenet = Usenet(threadNum: item.num ?? "", threadMsg: item.comment ?? "", thumbnail: item.files![0].path ?? "", date: item.date ?? "", thumbnailName: item.files![0].displayname ?? "")

            board.usenets.append(usenet)
        }

        return board
    }

    func mapResponseToThreadCommentsUseCase(response: [ThreadResponse]) -> [Comment] {
        var comments = response.map { (item) -> Comment in
            var pictures = [Picture]()
            if let files = item.files {
                for file in files {
                    pictures.append(Picture(displayName: file.displayname ?? "", path: file.path ?? ""))
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
//        for item in response.users! {
//            allBoards.boards.append(BoardDescription(name: item.name!, bumpLimit: item.bumpLimit!, id: item.id!))
//        }

        for item in response.subjects! {
            switch item.id! {
            case "bi":
                allBoards.boards.append(BoardDescription(name: "Отдельные треды \"посоветуйте велосипед за 15к\" нежелательны, пишите в посоветуй-тред. Конференция доски в Телеграме - @velach", bumpLimit: item.bumpLimit!, id: item.id!))
                break
            case "fl":
                allBoards.boards.append(BoardDescription(name: "Обсуждаем теоретические и практические аспекты иностранных языков, делимся своим опытом.", bumpLimit: item.bumpLimit!, id: item.id!))
                break
            case "me":
                allBoards.boards.append(BoardDescription(name: "/me - это раздел для обсуждения медицины, здоровья, терапии, диагностики, здорового образа жизни.", bumpLimit: item.bumpLimit!, id: item.id!))
                break
            case "mo":
                allBoards.boards.append(BoardDescription(name: "Доска для помощи как начинающим мотоциклистам, так и опытным байкерам. Разговоры на все темы, так или иначе связанные с мотоциклами и байкерским движением. У нас тут мотобратство!", bumpLimit: item.bumpLimit!, id: item.id!))
                break
            case "tv":
                allBoards.boards.append(BoardDescription(name: "Доска посвящена обсуждению телесериалов, телешоу, телепрограмм и всего, связанного с ними. Вся анимация следует в /c/, все фильмы - в /mov/. Закрепленный тред предназначен исключительно для реквестов и помощи в поисках. Конференция доски в Телеграме - @ru2chmov", bumpLimit: item.bumpLimit!, id: item.id!))
                break
            case "wm":
                allBoards.boards.append(BoardDescription(name: "Обсуждение военной техники, армий и вооруженных конфликтов. Политика, а также новости, не связанные с военной техникой обсуждаются в /po/ и /news/. Оружие самообороны, камуфляж, ножи и т.д. - /w/.", bumpLimit: item.bumpLimit!, id: item.id!))
                break
            default:
                print("asf")
            }

        }

        for item in response.software! {
            switch item.id! {
            case "gd":
                allBoards.boards.append(BoardDescription(name: "Доска создана для обсуждения вопросов, связаных с разработкой компьютерных игр. Аргументированная критика поощряется.", bumpLimit: item.bumpLimit!, id: item.id!))
                break
            case "hw":
                allBoards.boards.append(BoardDescription(name: "Обсуждаем компьютерное железо.", bumpLimit: item.bumpLimit!, id: item.id!))
                break
            case "moni":
                allBoards.boards.append(BoardDescription(name: "Доска для мобильных телефонов. О покупке и мелких вопросах спрашивают прикрепленном треде. Читалки - в /bo/, наушники и плееры - в /t/.", bumpLimit: item.bumpLimit!, id: item.id!))
                break
            case "pr":
                allBoards.boards.append(BoardDescription(name: "Программы и операционные системы обсуждаются в /s/. Воздержитесь от холиваров. Конференция доски в Телеграме - @pr2ch", bumpLimit: item.bumpLimit!, id: item.id!))
                break
            case "ra":
                allBoards.boards.append(BoardDescription(name: "Паяем, осуждаем друг друга за разводку платы и макетку из куска фанеры. Пиратское радио и официальное - связисты приветствуются. Не можешь сходу назвать закон ома и первое правило кирхгофа - в прикрепленный тред по любому вопросу.", bumpLimit: item.bumpLimit!, id: item.id!))
                break
            case "t":
                allBoards.boards.append(BoardDescription(name: "t/ - доска для обсуждения техники и технологий. Мобильные телефоны, планшеты, гаджеты обсуждаются в /mobi/. Компьютерное железо обсуждается в /hw/, но при этом по вопросам выбора или починки ноутбука можно обратиться сюда, по вопросам компьютерной периферии тоже, так повелось.", bumpLimit: item.bumpLimit!, id: item.id!))
                break
            default:
                print("asf")
            }
        }

//        for item in response.forAdults! {
//            allBoards.boards.append(BoardDescription(name: item.name!, bumpLimit: item.bumpLimit!, id: item.id!))
//        }

        for item in response.differences! {
            allBoards.boards.append(BoardDescription(name: "", bumpLimit: item.bumpLimit!, id: item.id!))
        }

        for item in response.creation! {
            allBoards.boards.append(BoardDescription(name: item.name!, bumpLimit: item.bumpLimit!, id: item.id!))
        }

        for item in response.games! {
            allBoards.boards.append(BoardDescription(name: item.name!, bumpLimit: item.bumpLimit!, id: item.id!))
        }

        for item in response.travel! {
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
