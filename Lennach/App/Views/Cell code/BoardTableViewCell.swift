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
    var imageClicker: (() -> Void)? = nil

    var videoClicker: (() -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        threadImage?.layer.cornerRadius = 8
    }

    func initVideoOrImageClicker(state: String) {
        if state == "video" {
            threadImage?.isUserInteractionEnabled = true
            threadImage?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapVideo)))
        } else if state == "image" {
            threadImage?.isUserInteractionEnabled = true
            threadImage?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImage)))
        }
    }

    @objc func tapImage() {
        imageClicker?()
    }

    @objc func tapVideo() {
        videoClicker?()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
