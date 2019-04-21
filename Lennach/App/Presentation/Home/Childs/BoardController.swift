//
//  BoardController.swift
//  Lennach
//
//  Created by Sergey Fominov on 13/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//
import UIKit
import Kingfisher

class BoardController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var boardData = Board()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        initBoard()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("counting: \(boardData.usenets.count)")
        return boardData.usenets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardTableViewCell", for: indexPath as IndexPath) as! BoardTableViewCell


        let usenet = boardData.usenets[indexPath.row]
        print("usenet: \(usenet)")
        cell.dataLabel?.text = usenet.threadData

        loadThumbnail(image: cell.threadImage!, url: usenet.thumbnail)

        //html converter
        guard let data = usenet.threadMsg.data(using: String.Encoding.unicode) else { return UITableViewCell() }
        do {
            cell.threadLabel?.attributedText = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            print(error)
        }

        return cell
    }

    //MARK: load board data
    private func initBoard() {
        print("RUN")
        MainRepository.instance.provideThreadsByBoard { (state, data, error) in
            if state {
                print("data: \(data)")
                self.boardData = data as! Board

                self.tableView.reloadData()
            } else {
                print("error: \(error)")
            }
        }
    }

    //MARK: Load image to cell with kingfisher
    private func loadThumbnail(image: UIImageView!, url: String) {
        let processor = DownsamplingImageProcessor(size: CGSize(width: image.bounds.width, height: image.bounds.height))
        
        image.kf.indicatorType = .activity
        image.kf.setImage(with: URL(string: Constants.baseUrl + url),
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
            ])
    }
}

