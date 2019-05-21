//
//  ReplyController.swift
//  Lennach
//
//  Created by Sergey Fominov on 21/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

protocol ReplyButtonClosable: class {
    func closeController()
}

class ReplyController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var commentsData = [Comment]()
    weak var controllerClosable: ReplyButtonClosable?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()

        backBtn.addTarget(self, action: #selector(actionButtonBack), for: .touchUpInside)
        closeBtn.addTarget(self, action: #selector(actionButtonClose), for: .touchUpInside)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let linkAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.blue,
            NSAttributedString.Key.underlineColor: UIColor.lightGray
        ]

        if let files = commentsData[indexPath.row].files {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyWithImageCell", for: indexPath as IndexPath) as! ReplyWithImageCell
            let post = commentsData[indexPath.row]

            let exclusionPath: UIBezierPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: cell.imagePost.frame.width, height: cell.imagePost.frame.height))

            cell.tvComment.textContainer.exclusionPaths = [exclusionPath]

            cell.tvComment.linkTextAttributes = linkAttributes
            cell.tvComment.attributedText = post.modernComment
            cell.tvComment.delegate = self // for modify text leading anchor

            if let replies = post.repliesContent?.count {
                if replies == 0 {
                    cell.btnReplies.isHidden = true
                } else {
                    cell.btnReplies.setTitle(String(replies) + " replies", for: .normal)
                    cell.btnReplies.isHidden = false
                }
            }

            cell.labelNumberAndDate.text = "Num: " + post.num + ", " + post.date

            //load picture
            Utilities.WorkWithUI.loadAsynsImage(image: cell.imagePost, url: Constants.baseUrl + files[0].path, fade: false)

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyWithoutImageCell", for: indexPath as IndexPath) as! ReplyWithoutImageCell
            let post = commentsData[indexPath.row]

            cell.tvComment.linkTextAttributes = linkAttributes
            cell.tvComment.attributedText = post.modernComment
            cell.tvComment.delegate = self

            if let replies = post.repliesContent?.count {
                if replies == 0 {
                    cell.btnReplies.isHidden = true
                } else {
                    cell.btnReplies.setTitle(String(replies) + " replies", for: .normal)
                    cell.btnReplies.isHidden = false
                }
            }

            cell.labelNumberAndDate.text = "Num: " + post.num + ", " + post.date

            return cell
        }
    }

    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func updateData() {
        commentsData = ObserveReplyPages.instance.getCurrentPage()
        tableView.reloadData()
    }
}

//MARK: buttons action
extension ReplyController {
    @objc private func actionButtonBack() {

    }

    @objc private func actionButtonClose() {
        ObserveReplyPages.instance.clearPages()
        controllerClosable?.closeController()
    }
}
