//
//  AllBoards.swift
//  Lennach
//
//  Created by Sergey Fominov on 02/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import Foundation

struct AllBoards {
    var boards = [BoardDescription]()
}

struct BoardDescription {
    var name = ""
    var bumpLimit = 0
    var id = ""
}
