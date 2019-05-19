//
//  FavouriteController.swift
//  Lennach
//
//  Created by Sergey Fominov on 13/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

class FavouriteController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //When user click on it from menu bar
    func showFavouriteContent() {
        print("pressed")
        MainRepository.instance.provideSavedFavouritesThreadFromDatabase { array in
            if let data = array {
                print("data: \(data)")
            }
        }
    }
}

