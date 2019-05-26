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
        let linkAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.underlineColor: UIColor.black
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

            cell.labelNumberAndDate.text = "№ " + post.num + ", " + post.date
            cell.clickable = self

            //load picture
            cell.imagePost.image = nil
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

            cell.labelNumberAndDate.text = "№ " + post.num + ", " + post.date
            cell.clickable = self

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
        print("LOAD DATA: \(ObserveReplyPages.instance.currentPage)")
        commentsData.removeAll()
        
        commentsData = ObserveReplyPages.instance.getCurrentPage()
        tableView.reloadData()
    }


    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if let string = URL.scheme {
            if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) {
                let data = (ObserveReplyPages.instance.baseThreadComments.filter { $0.num == string })

                ObserveReplyPages.instance.addNewPage(comments: data)

                updateData()
            }
        }
        return false
    }

    private func closeReplyController() {
        ObserveReplyPages.instance.clearPages()
        controllerClosable?.closeController()
    }

    private func grabNewComments(parentComment: Comment) {
        let posts = parentComment.repliesContent!.map { reply -> Comment in
            return ObserveReplyPages.instance.baseThreadComments.first(where: { $0.num == reply })!
        }

        ObserveReplyPages.instance.addNewPage(comments: posts)
        updateData()
    }
}

//MARK: buttons action
extension ReplyController: ReplyClickable {
    @objc private func actionButtonBack() {
        ObserveReplyPages.instance.backToPage() ? updateData() : closeReplyController()
    }

    @objc private func actionButtonClose() {
        closeReplyController()
    }

    func click(cell: UITableViewCell) {
        switch cell {
        case let replyWithImage as ReplyWithImageCell:
            if let index = tableView.indexPath(for: replyWithImage) {
                grabNewComments(parentComment: commentsData[index.row])
            }
            break
        case let replyWithoutImage as ReplyWithoutImageCell:
            if let index = tableView.indexPath(for: replyWithoutImage) {
                grabNewComments(parentComment: commentsData[index.row])
            }
            break
        default:
            print("lol")
        }
    }
}
