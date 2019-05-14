//
//  VideoPlayerView.swift
//  Lennach
//
//  Created by Sergey Fominov on 09/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit
import AVFoundation

class WebmVideoPlayer: UIView, OGVPlayerDelegate {

    var webmUrl = ""
    var playerView: OGVPlayerView!

    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }

    func ogvPlayerDidPlay(_ sender: OGVPlayerView!) {
        print("play")
    }
    func ogvPlayerDidPause(_ sender: OGVPlayerView!) {
        print("playse")
        playerView.pause()
    }

    func setupViews() {
        if playerView == nil {
            playerView = OGVPlayerView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
            addSubview(playerView)
            playerView.delegate = self
            playerView.sourceURL = NSURL(string: webmUrl) as URL?
        } else {
            playerView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        }
    }
}

class Mp4Player: UIView {
    var mp4Url = ""
    private var avLayer: AVPlayerLayer!
    private var player: AVPlayer?
    var isStopPlaying = false // bool value for control button state

    let handlerButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "IconStop"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(handlerPauseAndPlayButton), for: .touchUpInside)

        return view
    }()

    private let progressIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .whiteLarge)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startAnimating()

        return view
    }()

    //for opened mp4 player, first of all, we show user black screen
    private let blackControlView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)

        return view
    }()

    @objc func handlerPauseAndPlayButton() {
        isStopPlaying = !isStopPlaying

        if isStopPlaying {
            player?.pause()
        } else {
            player?.play()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(blackControlView)
        blackControlView.frame = frame
        blackControlView.addSubview(progressIndicatorView)

        progressIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        progressIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        blackControlView.addSubview(handlerButton)
        handlerButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        handlerButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        handlerButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        handlerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        handlerButton.isHidden = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if avLayer != nil {
            avLayer.frame = self.frame
        }
    }

    func initPlayer() {
        player = AVPlayer(url: URL(string: mp4Url)!)

        avLayer = AVPlayerLayer(player: player)
        self.layer.addSublayer(avLayer)
        avLayer.frame = self.frame

        player?.play()
        player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            progressIndicatorView.stopAnimating()
            blackControlView.backgroundColor = .clear

            handlerButton.isHidden = false
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
