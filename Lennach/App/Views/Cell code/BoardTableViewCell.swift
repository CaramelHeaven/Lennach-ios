//
//  BoardTableViewCell.swift
//  Lennach
//
//  Created by Sergey Fominov on 18/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

class BoardTableViewCell: UITableViewCell {

    @IBOutlet var threadImage: UIImageView?
    @IBOutlet var threadLabel: UILabel?
    @IBOutlet var labelDate: UILabel?

    //MARK: image click listener
    var tapHandler: (() -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        threadImage?.isUserInteractionEnabled = true
        threadImage?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImage)))
    }

    @objc func tapImage() {
        tapHandler?()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
