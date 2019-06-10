//
//  FavouriteTableViewCell.swift
//  Lennach
//
//  Created by Sergey Fominov on 26/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {

    @IBOutlet var threadImage: UIImageView!
    @IBOutlet var threadLabel: UILabel!
    @IBOutlet var labelCountMessages: UILabel!
    @IBOutlet var labelNewMessages: UILabel!
    @IBOutlet var aivProgress: UIActivityIndicatorView!
    @IBOutlet var btnRemove: UIButton!

    private var permissionToUpdateData = true

    override func awakeFromNib() {
        super.awakeFromNib()
        print("CREATED FAVOURITE TABLE VIEW CELL")

        aivProgress.isHidden = true
        labelNewMessages.isHidden = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func observeCountNewMessages(completable: @escaping (Any?) -> ()) {
        if permissionToUpdateData {
            permissionToUpdateData = false

            updateMessagesCount { data in
                completable(5)
            }
        } else {
           //aivProg
            DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
                self.permissionToUpdateData = true
                completable(true)
            }
        }
    }

    func updateMessagesCount(completable: @escaping (Any?) -> ()) {
        aivProgress.isHidden = false

        //network request

        return completable([String]())
    }
}
