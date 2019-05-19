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

protocol BoardNavigatable {

}

//Board current App [business data]. Used in NavigationVC
struct BoardDescription: BoardNavigatable {
    var name = ""
    var bumpLimit = 0
    var id = ""

    var isSelected = false //for popupController cell - state switch

    init(name: String, bumpLimit: Int, id: String) {
        self.name = name
        self.bumpLimit = bumpLimit
        self.id = id
    }
}

//BoardAdd for cell in NavigationVC
struct AddBoard: BoardNavigatable {

}

//Emtpy boards for fill invisible cells in NavigationVC
struct EmtpyBoard: BoardNavigatable {

}
