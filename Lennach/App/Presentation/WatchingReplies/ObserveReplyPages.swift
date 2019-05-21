//
//  ObservedReplyPages.swift
//  Lennach
//
//  Created by Sergey Fominov on 21/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import Foundation

//Class for control how many times user clicked on replies
class ObserveReplyPages {

    static let instance = ObserveReplyPages()

    private init() { }

    var currentPage = 0
    var page = [Int: [Comment]]()

    func addNewPage(comments: [Comment]) {
        page[currentPage] = comments
    }

    func clearPages() {
        page.removeAll()
        currentPage = 0
    }

    func getCurrentPage() -> [Comment] {
        return page[currentPage]!
    }
}
