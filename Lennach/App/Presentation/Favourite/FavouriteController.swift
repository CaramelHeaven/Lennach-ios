//
//  FavouriteController.swift
//  Lennach
//
//  Created by Sergey Fominov on 13/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

protocol FavouriteClickable: class {
    func selectThread(board: String, thread: String)
}

class FavouriteController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    private var dataFavourites = [ThreadFavourite]()
    weak var clickableFavourite: FavouriteClickable?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }

    //When user click on it from menu bar
    func showFavouriteContent() {
        MainRepository.instance.provideSavedFavouritesThreadFromDatabase { array in
            if let data = array {
                self.dataFavourites = data
                self.tableView.reloadData()
            }
        }
    }

    func clearFavouriteContent() {
        dataFavourites.forEach { $0.clearTimer() }
        dataFavourites.removeAll()

        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataFavourites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteTableViewCell", for: indexPath) as! FavouriteTableViewCell

        let data = dataFavourites[indexPath.row]

        //load image from cache
        Utilities.WorkWithUI.loadAsynsImage(image: cell.threadImage, url: "https://2channel.hk/" + data.imageUrl, fade: false)
        cell.threadImage.layer.cornerRadius = cell.threadImage.frame.height / 2

        cell.labelNewMessages.text = "0 новых сообщений"
        if let value = data.countNewMessages {
            cell.labelNewMessages.text = "+\(value) новых сообщений"
        }

        data.updateFirstLoadingData { (progress, value) in
            if progress == .startLoading {
                cell.aivProgress.isHidden = false
            } else {
                cell.aivProgress.isHidden = true

                if let msgsCount = data.countNewMessages {
                    let updated = value as! Int

                    let result = updated - data.quantityPosts
                    if result != msgsCount, result > 0 {
                        data.countNewMessages! += result - msgsCount
                        cell.labelNewMessages.text = "+\(result) новых сообщений"
                    }
                } else {
                    let result = (value as! Int) - data.quantityPosts

                    if result > 0 {
                        cell.labelNewMessages.text = "+\(result) новых сообщений"
                        data.countNewMessages = 0 + result
                    }
                }
                cell.labelNewMessages.isHidden = false
            }
        }

        //TIMER
        data.updateCountMessages { progress, value in
            if progress == .startLoading {
                cell.aivProgress.isHidden = false
            } else {
                cell.aivProgress.isHidden = true

                if let msgsCount = data.countNewMessages {
                    let updated = value as! Int

                    let result = updated - data.quantityPosts
                    if result != msgsCount, result > 0 {
                        data.countNewMessages! += result - msgsCount
                        cell.labelNewMessages.text = "+\(result) новых сообщений"
                    }
                } else {
                    let result = (value as! Int) - data.quantityPosts

                    if result > 0 {
                        cell.labelNewMessages.text = "+\(result) новых сообщений"
                        data.countNewMessages = 0 + result
                    }
                }
                cell.labelNewMessages.isHidden = false
            }
        }


        cell.threadLabel.text = data.opMessage
        cell.labelCountMessages.text = "\(data.quantityPosts) сообщений"
        print("RETURN CELL")

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = dataFavourites[indexPath.row]

        clickableFavourite?.selectThread(board: result.boardName, thread: result.numThread)
    }
}

