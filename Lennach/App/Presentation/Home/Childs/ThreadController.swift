//
//  ThreadController.swift
//  Lennach
//
//  Created by Sergey Fominov on 13/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

protocol ThreadDelegate: class {
    func translateXState(threadX: CGFloat)

    func dragState(flag: Bool, lastValueX: CGFloat)
}

class ThreadController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView?

    weak var threadDelegate: ThreadDelegate?

    private var dataThread: [Comment] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.dataSource = self
        tableView?.delegate = self
//        tableView?.estimatedRowHeight = 30
//        tableView?.rowHeight = UITableView.automaticDimension

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onDragController))
        self.view.addGestureRecognizer(panGesture)
    }

    @objc func onDragController(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)

        //compute X
        var updateX: CGFloat = 0

        if let view = recognizer.view {
            updateX = view.frame.origin.x + translation.x
            print("view frame origin: \(view.frame.origin.x)")
        }

        switch recognizer.state {
        case .began, .changed:
            threadDelegate?.translateXState(threadX: updateX)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        case .ended:
            threadDelegate?.dragState(flag: false, lastValueX: updateX)
        default:
            print("default")
        }
    }

    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataThread.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostWithoutImageCell", for: indexPath as IndexPath) as! PostWithoutImageCell

        cell.tvComment.text = dataThread[indexPath.row].comment

        //        switch data[indexPath.row].kek {
        //        case "1":
        //            //let cell = Bundle.main.loadNibNamed("ThreadOpC", owner: self, options: nil)?.first as! ThreadOpC
        //
        //            //cell.textLabel!.text = data[indexPath.row].kek
        //
        //            return return UITableViewCell()
        //        case "2":
        //            let cell = Bundle.main.loadNibNamed("ThreadCommentC", owner: self, options: nil)?.first as! ThreadCommentC
        //            //cell.labelComment.text = data[indexPath.row].kek
        //
        //            return UITableViewCell()
        //        default:
        return cell
    }
}

//MARK: Load comments from network
extension ThreadController {
    func callbackFromTapAction(data: (boardName: String, numThread: String)) {
        MainRepository.instance.provideMessagesByThread(data.boardName, data.numThread) { (result, objects, error) in
            if result {
                self.dataThread = objects as! [Comment]
                self.tableView?.reloadData()
            } else {
                fatalError()
            }
        }
    }
}
