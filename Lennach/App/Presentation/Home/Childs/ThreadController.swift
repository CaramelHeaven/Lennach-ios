//
//  ThreadController.swift
//  Lennach
//
//  Created by Sergey Fominov on 13/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit
import Toaster

protocol ThreadDelegate: class {
    func translateXState(threadX: CGFloat)

    func dragState(flag: Bool, lastValueX: CGFloat)
}

//Direction helper enum for scrolling button state
enum Direction {
    case up
    case down
}

class ThreadController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {

    @IBOutlet weak var progressAIV: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var skipToBottomBtn: UIButton!

    weak var threadDelegate: ThreadDelegate?

    private var animationWorking = false
    private var destinationPath: Direction = .down // destination path described which direction button can be moving. TRUE - button can move to BOTTOM

    private var panGesture: UIPanGestureRecognizer!
    private var dataThread: [Comment] = []
    var activateBoardGesture = false
    //private var answerView: AnswerViewContainer?
    private var videoContainer: VideoPlayerContainer!
    private var replyController: UIViewController?

    //for opening reply container
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0

        return view
    }()

    private let selectThreadLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Выберите пожалуйста обсуждение"
        view.textColor = .black
        view.font = UIFont(name: view.font.fontName, size: 14)
        view.isHidden=true
        
        return view
    }()

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

        //rounding buttons
        skipToBottomBtn.contentMode = .center
        skipToBottomBtn.imageView?.contentMode = .scaleAspectFit
        skipToBottomBtn.clipsToBounds = true

        skipToBottomBtn.layer.cornerRadius = skipToBottomBtn.frame.height / 2
        skipToBottomBtn.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) //resize image inside button

        favouriteBtn.contentMode = .center
        favouriteBtn.imageView?.contentMode = .scaleAspectFit
        favouriteBtn.clipsToBounds = true

        favouriteBtn.layer.cornerRadius = favouriteBtn.frame.height / 2
        favouriteBtn.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) //resize image inside button

        //set base values for animation future
        baseSkipButtonPosition = skipToBottomBtn.frame

        view.addSubview(selectThreadLabel)
        NSLayoutConstraint.activate([
            selectThreadLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectThreadLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            selectThreadLabel.widthAnchor.constraint(equalToConstant: 250),
            selectThreadLabel.heightAnchor.constraint(equalToConstant: 30),
            ])
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

    // we set a variable to hold the contentOffSet before scroll view scrolls
    var lastContentOffset: CGFloat = 0

    // this delegate is called when the scrollView (i.e your UITableView) will start scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }

    var baseSkipButtonPosition: CGRect!

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //for example if 24500(base 26000) <= 24512 - permission to animate scrollToBottomButton
        var minimumHeightForAnimation: CGFloat = 2000
        if scrollView.contentSize.height < 3000 { minimumHeightForAnimation = 500 }

        if scrollView.contentSize.height - minimumHeightForAnimation <= scrollView.contentOffset.y {
            if !animationWorking {
                if self.lastContentOffset < scrollView.contentOffset.y, destinationPath == .down {
                    destinationPath = .up
                    UIView.animate(withDuration: 0.3, animations: {
                        let initialFrame = self.skipToBottomBtn.frame
                        self.skipToBottomBtn.frame = CGRect(x: initialFrame.minX, y: initialFrame.minY - 20, width: initialFrame.width, height: initialFrame.height)

                        self.skipToBottomBtn.frame = CGRect(x: initialFrame.minX, y: initialFrame.minY + 100, width: initialFrame.width, height: initialFrame.height)
                    }) { _ in
                        self.animationWorking = false
                    }
                }
            }
        } else {
            if self.lastContentOffset > scrollView.contentOffset.y, destinationPath == .up {
                destinationPath = .down
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3, options: [.curveEaseIn], animations: {
                        let initialFrame = self.skipToBottomBtn.frame

                        self.skipToBottomBtn.frame = CGRect(x: initialFrame.minX, y: initialFrame.minY - 100, width: initialFrame.width, height: initialFrame.height)
                    }) { _ in
                    self.animationWorking = false
                }
            }
        }
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if let string = URL.scheme {
            if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) {
                let data = dataThread.filter { $0.num == string }

                ObserveReplyPages.instance.baseThreadComments = dataThread
                ObserveReplyPages.instance.addNewPage(comments: data)

                openReplyController()
            }
        }
        return false
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let linkAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.underlineColor: UIColor.black
        ]

        if let files = dataThread[indexPath.row].files {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostWithImageCell", for: indexPath as IndexPath) as! PostWithImageCell
            cell.gestureCompletable = self as! CellGestureCompletable
            let post = dataThread[indexPath.row]

            let exclusionPath: UIBezierPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: cell.imagePost.frame.width, height: cell.imagePost.frame.height))

            cell.tvComment.textContainer.exclusionPaths = [exclusionPath]

            cell.tvComment.linkTextAttributes = linkAttributes
            cell.tvComment.attributedText = post.modernComment
            cell.tvComment.textColor = .darkGray
            cell.tvComment.delegate = self

            if let replies = post.repliesContent?.count {
                if replies == 0 {
                    cell.btnReplies.isHidden = true
                } else {
                    cell.btnReplies.setTitle(String(replies) + " replies", for: .normal)
                    cell.btnReplies.isHidden = false
                }
            }

            cell.clickable = self
            cell.labelNumberAndDate.text = "№ " + post.num + ", " + post.date

            //IMAGE OR VIDEO CLICKABLE
            cell.imagePost.image = nil
            if post.files![0].path.contains(".webm") || post.files![0].path.contains(".mp4") {
                if post.files![0].path.contains(".mp4") {
                    DispatchQueue.global().async {
                        let asset = AVAsset(url: URL(string: "https://2channel.hk/" + post.files![0].path)!)
                        let assetImgGenerate: AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
                        assetImgGenerate.appliesPreferredTrackTransform = true
                        let time = CMTimeMake(value: 1, timescale: 2)
                        let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)

                        if img != nil {
                            let frameImg = UIImage(cgImage: img!)
                            DispatchQueue.main.async(execute: {
                                cell.imagePost.image = frameImg
                            })
                        }
                    }
                }
            } else {
                //load picture
                Utilities.WorkWithUI.loadAsynsImage(image: cell.imagePost, url: "https://2channel.hk/" + files[0].path, fade: false)
                cell.initVideoOrImageClicker(state: "image")

                cell.imageClicker = { [self] in
                    self.makeTransition(indexPath: indexPath, imageTapped: cell.imagePost)
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostWithoutImageCell", for: indexPath as IndexPath) as! PostWithoutImageCell
            cell.gestureCompletable = self as! CellGestureCompletable
            let post = dataThread[indexPath.row]

            cell.tvComment.linkTextAttributes = linkAttributes
            cell.tvComment.attributedText = post.modernComment
            cell.tvComment.textColor = .darkGray
            cell.tvComment.delegate = self

            if let replies = post.repliesContent?.count {
                if replies == 0 {
                    cell.btnReplies.isHidden = true
                } else {
                    cell.btnReplies.setTitle(String(replies) + " replies", for: .normal)
                    cell.btnReplies.isHidden = false
                }
            }

            cell.clickable = self
            cell.labelNumberAndDate.text = "№ " + post.num + ", " + post.date

            return cell
        }
    }

    var handlerDirectionGestureToThread = true

    private var blackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        view.alpha = 0

        return view
    }()

    private func videoTransition(indexPath path: IndexPath, videoName: String) {
        videoContainer = VideoPlayerContainer()

        videoContainer.currentVideoUrl = "https://2channel.hk/" + dataThread[path.row].files![0].path
        videoContainer.currentVideoName = dataThread[path.row].files![0].displayName

        videoContainer.showVideo()
    }

//MARK: image transition animation
    private func makeTransition(indexPath path: IndexPath, imageTapped: UIImageView) {
        guard let cell = tableView.cellForRow(at: path) as? PostWithImageCell else { return }

        let configuration = ImageViewerConfiguration { config in
            config.imageView = cell.imagePost
        }

        let controller = ImageController(configuration: configuration)
        controller.urlThumbnail = dataThread[path.row].files![0].path

        present(controller, animated: true, completion: nil)
    }
}

extension ThreadController: ReplyClickable {
    func click(cell: UITableViewCell) {

        switch cell {
        case let postWithImage as PostWithImageCell:

            if let index = tableView.indexPath(for: postWithImage) {
                _ = dataThread[index.row]
            }
            break
        case _ as PostWithoutImageCell:

            break
        default:
            print("lol")
        }
    }

    private func openReplyController() {
        view.addSubview(blackView)
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            blackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blackView.topAnchor.constraint(equalTo: view.topAnchor),
            blackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            ])


        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.alpha = 1
            self.blackView.alpha = 1
        }) { _ in
            self.replyController = self.storyboard?.instantiateViewController(withIdentifier: "ReplyController")

            if let controller = ((self.replyController) as? ReplyController) {
                self.addChild(controller)
                controller.view.translatesAutoresizingMaskIntoConstraints = false
                self.containerView.addSubview(controller.view)

                controller.updateData()
                controller.controllerClosable = self

                NSLayoutConstraint.activate([
                    controller.view.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
                    controller.view.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
                    controller.view.topAnchor.constraint(equalTo: self.containerView.topAnchor),
                    controller.view.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor)
                    ])

                controller.didMove(toParent: self)
            }
        }
    }
}

//MARK: Closing ReplyController via button
extension ThreadController: ReplyButtonClosable {
    func closeController() {
        UIView.animate(withDuration: 0.4, animations: {
            self.containerView.alpha = 0
            self.blackView.alpha = 0
        }) { _ in
            self.replyController?.removeFromParent()
            self.containerView.removeFromSuperview()
            self.blackView.removeFromSuperview()
        }
    }
}

//MARK: Disable enable background state view and handlering gesture on each cell
extension ThreadController: UIGestureRecognizerDelegate {

    /*
     Visible or not visible thread on user UI, if true - our thread view placed behind window
     @Arguments: isClosingThread - means that user closed thread - make disable gestures and change alpha channel on tableView, etc
     */
    func backgroundThreadState(isClosingThread: Bool, isNewThread: Bool = false) {
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
        MainRepository.instance.provideSavingThreadToFavourite(comments: dataThread) { result in
            if result {
                let toast = Toast(text: "Добавлено!", delay: 0, duration: Delay.short)
                toast.show()
            }
        }
    }

    @objc private func actionSkipToBottomBtn(_ sender: UIButton) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.dataThread.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

//MARK: Load comments from network
extension ThreadController {
    func callbackFromTapAction(board: String, numThread: String) {
        tableView.isHidden = true
        tableView.alpha == 0.5 ? tableView.alpha = 1: nil

        selectThreadLabel.isHidden = true
        progressAIV.isHidden = false
        progressAIV.startAnimating()

        dataThread.removeAll()
        self.tableView.reloadData()
        
        MainRepository.instance.provideMessagesByThread(board, numThread) { (result, objects, error) in
            self.progressAIV.isHidden = true
            self.progressAIV.stopAnimating()
            if result {
                self.dataThread = objects as! [Comment]
                self.tableView.reloadData()

                self.progressAIV.stopAnimating()
                self.progressAIV.isHidden = true
                self.tableView.isHidden = false

                //return button on initial place if it hidden
                if self.destinationPath == .up {
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3, options: [.curveEaseIn], animations: {
                            let initialFrame = self.skipToBottomBtn.frame

                            self.skipToBottomBtn.frame = CGRect(x: initialFrame.minX, y: initialFrame.minY - 100, width: initialFrame.width, height: initialFrame.height)
                        }) { _ in
                        self.destinationPath = .down
                    }
                }
            } else {
                print("fatal error")
            }
        }
    }
}
