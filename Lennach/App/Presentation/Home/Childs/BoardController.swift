//
//  BoardController.swift
//  Lennach
//
//  Created by Sergey Fominov on 13/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//
import UIKit
import Kingfisher
import AVFoundation

protocol BoardTapDelegatable: class {
    func itemTapped(numThread: String)
}

class BoardController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressAIV: UIActivityIndicatorView!

    private var present = true
    private var boardData = Board()

    var isOpeningNewThread = false
    var currentThread = "" { willSet { isOpeningNewThread = newValue == currentThread } } //used inside HomeController for determinate - is new thread opening or not

    let videoContainer = VideoPlayerContainer()

    weak var boardDelegatable: BoardTapDelegatable?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        tableView.tableFooterView = UIView()

        //TODO: Make load this from cache
        loadBoard(board: "b")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boardData.usenets.count
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardTableViewCell", for: indexPath!) as! BoardTableViewCell
        cell.threadImage!.kf.cancelDownloadTask()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardTableViewCell", for: indexPath as IndexPath) as! BoardTableViewCell

        let usenet = boardData.usenets[indexPath.row]
        cell.labelDate?.text = usenet.date

        if usenet.thumbnail.contains(".webm") || usenet.thumbnail.contains(".mp4") {
            cell.initVideoOrImageClicker(state: "video")
            cell.threadImage!.image = nil

            cell.videoClicker = { [self] in
                self.videoTransition(indexPath: indexPath, videoName: usenet.thumbnailName)
            }

            //set thumbnail from first frame
            if usenet.thumbnail.contains(".mp4") {
                DispatchQueue.global().async {
                    let asset = AVAsset(url: URL(string: Constants.baseUrl + usenet.thumbnail)!)
                    let assetImgGenerate: AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
                    assetImgGenerate.appliesPreferredTrackTransform = true
                    let time = CMTimeMake(value: 1, timescale: 2)
                    let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                    if img != nil {
                        let frameImg = UIImage(cgImage: img!)
                        DispatchQueue.main.async(execute: {
                            cell.threadImage!.image = frameImg
                        })
                    }
                }
            }
        } else {
            Utilities.WorkWithUI.loadAsynsImage(image: cell.threadImage!, url: Constants.baseUrl + usenet.thumbnail, fade: true)
            cell.initVideoOrImageClicker(state: "image")

            cell.imageClicker = { [self] in
                self.makeTransition(indexPath: indexPath, imageTapped: cell.imageView)
            }
        }
        
        let lol = usenet.threadMsg.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)

        if let kek = Utilities.WorkWithUI.textHtmlConvert(text: lol) {
            cell.threadLabel?.attributedText = kek
        } else {
            cell.threadLabel?.text = lol
        }

        return cell
    }

    //MARK: Load thread from board
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentThread = boardData.usenets[indexPath.row].threadNum
        boardDelegatable?.itemTapped(numThread: currentThread)
    }

    func videoTransition(indexPath path: IndexPath, videoName: String) {
        videoContainer.currentVideoUrl = Constants.baseUrl + boardData.usenets[path.row].thumbnail
        
        
        videoContainer.showVideo()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        videoContainer.redrawingVideoViews(currentSize: size)
    }

    //MARK: make image transition animation
    func makeTransition(indexPath path: IndexPath, imageTapped: UIImageView?) {
        guard let cell = tableView.cellForRow(at: path) as? BoardTableViewCell else { return }

        let configuration = ImageViewerConfiguration { config in
            config.imageView = cell.threadImage!
        }

        let controller = ImageController(configuration: configuration)
        controller.urlThumbnail = boardData.usenets[path.row].thumbnail

        present(controller, animated: true, completion: nil)
    }

    //MARK: load board data
    private func loadBoard(board: String) {
        MainRepository.instance.provideThreadsByBoard(board: board) { (state, data, error) in
            if state {
                //print("data: \(data)")
                self.boardData = data as! Board

                self.tableView.reloadData()

                self.tableView.alpha = 1
                self.progressAIV.stopAnimating()
            } else {
                //print("error: \(error)")
            }

        }
    }

    public func startedNewBoard(boardName: String) {
        tableView.alpha = 0.5
        progressAIV.startAnimating()

        loadBoard(board: boardName)
    }
}
