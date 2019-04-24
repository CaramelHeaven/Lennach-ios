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

    // for transition, inited in makeTransition()
    private var selectedImage: UIImageView?
    // animation

    private var present = true
    private var boardData = Board()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        print("FUCK YOU: \(view.frame)")

        initBoard()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boardData.usenets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardTableViewCell", for: indexPath as IndexPath) as! BoardTableViewCell

        let usenet = boardData.usenets[indexPath.row]
        cell.dataLabel?.text = usenet.threadData

        Utilities.loadAsynsImage(image: cell.threadImage!, url: Constants.baseUrl + usenet.thumbnail, fade: true)

        //html converter
        guard let data = usenet.threadMsg.data(using: String.Encoding.unicode) else { return UITableViewCell() }
        do {
            cell.threadLabel?.attributedText = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            print(error)
        }

        cell.tapHandler = {
            self.kek = indexPath
            self.makeTransition(indexPath: indexPath, imageTapped: cell.imageView)
        }

        return cell
    }

    private var imageVC: ImageController?

    //MARK: make transition animation
    func makeTransition(indexPath path: IndexPath, imageTapped: UIImageView?) {
        selectedImage = imageTapped

        let cell = tableView.cellForRow(at: path) as! BoardTableViewCell

        let configuration = ImageViewerConfiguration { config in
            config.imageView = cell.threadImage!
        }

        let controller = ImageController(configuration: configuration)
        controller.urlThumbnail = boardData.usenets[path.row].thumbnail
        
        present(controller, animated: true)
    }

    var kek = IndexPath()
    //MARK: load board data
    private func initBoard() {
        MainRepository.instance.provideThreadsByBoard { (state, data, error) in
            if state {
                //print("data: \(data)")
                self.boardData = data as! Board

                self.tableView.reloadData()
            } else {
                //print("error: \(error)")
            }
        }
    }
}
