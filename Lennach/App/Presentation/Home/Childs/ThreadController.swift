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

    @IBOutlet weak var selectThreadLabel: UILabel!
    @IBOutlet weak var progressAIV: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var skipToBottomBtn: UIButton!

    weak var threadDelegate: ThreadDelegate?

    private var panGesture: UIPanGestureRecognizer!
    private var dataThread: [Comment] = []
    var activateBoardGesture = false
    private var answerView: AnswerViewContainer?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()

        progressAIV.isHidden = true

        //provide buttons listener
        favouriteBtn.addTarget(self, action: #selector(actionFavouriteBtn(_:)), for: .touchUpInside)
        skipToBottomBtn.addTarget(self, action: #selector(actionSkipToBottomBtn(_:)), for: .touchUpInside)

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(onDragController))
        panGesture.delegate = self
        self.view.addGestureRecognizer(panGesture)
    }

    @objc func onDragController(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)

        //compute X
        var updateX: CGFloat = 0

        if let view = recognizer.view {
            updateX = view.frame.origin.x + translation.x
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
        print("provding table view cell data")
        if let files = dataThread[indexPath.row].files {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostWithImageCell", for: indexPath as IndexPath) as! PostWithImageCell
            cell.gestureCompletable = self
            let post = dataThread[indexPath.row]

            let exclusionPath: UIBezierPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: cell.imagePost.frame.width, height: cell.imagePost.frame.height))

            cell.tvComment.textContainer.exclusionPaths = [exclusionPath]

            if let text = Utilities.WorkWithUI.textHtmlConvert(text: post.comment) {
                cell.tvComment.attributedText = text
            } else {
                cell.tvComment.text = post.comment
            }

            //load picture
            Utilities.WorkWithUI.loadAsynsImage(image: cell.imagePost, url: Constants.baseUrl + files[0].path, fade: false)

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostWithoutImageCell", for: indexPath as IndexPath) as! PostWithoutImageCell
            cell.gestureCompletable = self
            // cell.initAnswerGesture()
            let post = dataThread[indexPath.row]

            if let text = Utilities.WorkWithUI.textHtmlConvert(text: post.comment) {
                cell.tvComment.attributedText = text
            } else {
                cell.tvComment.text = post.comment
            }

            return cell
        }
    }

    var handlerDirectionGestureToThread = true
}

extension ThreadController: CellGestureCompletable {
    func showingAnswerView(cell: UITableViewCell) {
        if answerView == nil {
            answerView = AnswerViewContainer()
        }
        answerView!.bindNumberPost = (dataThread[tableView.indexPath(for: cell)!.row]).num
        answerView!.showAnswerView(mainView: self.view)
    }
}

//MARK: Disable enable background state view and handlering gesture on each cell
extension ThreadController: UIGestureRecognizerDelegate {

    /*
     Visible or not visible thread on user UI, if true - our thread view placed behind window
     @Argumets: isClosingThread - means that user closed thread - make disable gestures and change alpha channel on tableView, etc
     */
    func backgroundThreadState(isClosingThread: Bool, isNewThread: Bool = false) {
        print("is closing thread: \(isClosingThread), isNewThread: \(isNewThread)")
        if isClosingThread {
            tableView.alpha = 0.5
            tableView.isScrollEnabled = false
        } else {
            tableView.alpha = 1
            tableView.isScrollEnabled = true
        }
    }
}

//MARK: Favourite and scroll to bottom buttons action
extension ThreadController {
    @objc private func actionFavouriteBtn(_ sender: UIButton) {
        print("favourite btn")
    }

    @objc private func actionSkipToBottomBtn(_ sender: UIButton) {
        print("skip to bottom")
    }
}

//MARK: Load comments from network
extension ThreadController {
    func callbackFromTapAction(numThread: String) {
        tableView.isHidden = true
        tableView.alpha == 0.5 ? tableView.alpha = 1: nil

        selectThreadLabel.isHidden = true

        progressAIV.isHidden = false
        progressAIV.startAnimating()

        dataThread.removeAll()
        self.tableView.reloadData()
        MainRepository.instance.provideMessagesByThread(numThread) { (result, objects, error) in
            self.progressAIV.isHidden = true
            self.progressAIV.stopAnimating()
            if result {
                self.dataThread = objects as! [Comment]
                self.tableView.reloadData()

                self.progressAIV.stopAnimating()
                self.progressAIV.isHidden = true
                self.tableView.isHidden = false
            } else {
                print("fatal error")
                // fatalError()
            }
        }
    }
}
