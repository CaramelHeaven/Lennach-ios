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

    var baseThreadComments: [Comment]!
    var currentPage = 0
    
    var page = [Int: [Comment]]()

    func addNewPage(comments: [Comment]) {
        page[currentPage] = comments
        currentPage += 1
    }

    func clearPages() {
        page.removeAll()
        currentPage = 0
    }

    func getCurrentPage() -> [Comment] {
        if currentPage - 1 >= 0 {
            let pageq = currentPage - 1
            print("PAGE: \(pageq)")
            return page[currentPage - 1]!
        }
        return [Comment]()
    }

    func backToPage() -> Bool {
        if currentPage - 1 > 0 {
            currentPage -= 1
            return true
        }
        return false
    }
}
