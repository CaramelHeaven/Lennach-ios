//
//  ReplyWithImageCell.swift
//  Lennach
//
//  Created by Sergey Fominov on 22/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import Foundation

class ReplyWithImageCell: UITableViewCell {
    
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var labelNumberAndDate: UILabel!
    @IBOutlet weak var tvComment: UITextView!
    @IBOutlet weak var btnReplies: UIButton!

    var clickable: ReplyClickable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnReplies.addTarget(self, action: #selector(actionRepliesClick), for: .touchUpInside)
    }
    
    @objc func actionRepliesClick() {
        clickable?.click(cell: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
