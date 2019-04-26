//
//  BoardController.swift
//  Lennach
//
//  Created by Sergey Fominov on 13/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//
import UIKit
import Kingfisher

protocol BoardTapDelegatable: class {
    func itemTapped(data: (boardName: String, numThread: String))
}

class BoardController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    private var present = true
    private var boardData = Board()

    weak var boardDelegatable: BoardTapDelegatable?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        initBoard()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boardData.usenets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardTableViewCell", for: indexPath as IndexPath) as! BoardTableViewCell

        let usenet = boardData.usenets[indexPath.row]
        print("usenet: \(usenet)")
        print("-------------------------------------------")
        cell.labelDate?.text = usenet.date

        Utilities.WorkWithUI.loadAsynsImage(image: cell.threadImage!, url: Constants.baseUrl + usenet.thumbnail, fade: true)
        var lol = usenet.threadMsg.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)

        if let kek = Utilities.WorkWithUI.textHtmlConvert(text: lol) {
            cell.threadLabel?.attributedText = kek
        } else {
            cell.threadLabel?.text = lol
        }


        cell.tapHandler = { [unowned self] in
            self.makeTransition(indexPath: indexPath, imageTapped: cell.imageView)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        boardDelegatable?.itemTapped(data: ("pr", boardData.usenets[indexPath.row].threadNum))
    }

    private var imageVC: ImageController?

    //MARK: make transition animation
    func makeTransition(indexPath path: IndexPath, imageTapped: UIImageView?) {
        let cell = tableView.cellForRow(at: path) as! BoardTableViewCell

        let configuration = ImageViewerConfiguration { config in
            config.imageView = cell.threadImage!
        }

        let controller = ImageController(configuration: configuration)
        controller.urlThumbnail = boardData.usenets[path.row].thumbnail

        //present(KekViewController(), animated: true, completion: nil)
        present(controller, animated: true, completion: nil)
    }

    var kek = IndexPath()
    //MARK: load board data
    private func initBoard() {
        MainRepository.instance.provideThreadsByBoard { (state, data, error) in
            if state {
                //print("data: \(data)")
                self.boardData = data as! Board

                print("checkign: \(self.boardData.usenets)")
                self.tableView.reloadData()
            } else {
                //print("error: \(error)")
            }
        }
    }
}
