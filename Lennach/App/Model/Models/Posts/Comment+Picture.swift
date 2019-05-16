//
//  Comment.swift
//  Lennach
//
//  Created by Sergey Fominov on 13/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import Foundation

struct Comment {
    var num = ""
    var name = ""
    var comment = ""
    var date = ""
    var modernComment: NSMutableAttributedString!

    var repliesContent: [String]?
    var files: [Picture]?
}

struct Picture {
    var displayName = ""
    var path = ""
}
