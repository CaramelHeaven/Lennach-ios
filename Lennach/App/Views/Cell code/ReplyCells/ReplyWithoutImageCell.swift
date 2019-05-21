//
//  ReplyWithoutImageCell.swift
//  Lennach
//
//  Created by Sergey Fominov on 22/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

class ReplyWithoutImageCell: UITableViewCell {
    
    @IBOutlet weak var labelNumberAndDate: UILabel!
    @IBOutlet weak var tvComment: UITextView!
    @IBOutlet weak var btnReplies: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
