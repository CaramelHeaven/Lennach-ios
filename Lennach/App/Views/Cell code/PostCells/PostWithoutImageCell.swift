//
//  PostWithoutImageCell.swift
//  Lennach
//
//  Created by Sergey Fominov on 13/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

class PostWithoutImageCell: UITableViewCell {

    @IBOutlet weak var labelNumberAndDate: UILabel!
    @IBOutlet weak var tvComment: UITextView!
    @IBOutlet weak var btnReplies: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}