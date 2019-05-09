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
        }
    }
}

class Mp4Player: UIView {
    var mp4Url = "https://2ch.hk/b/src/196071060/15574310086630.mp4"

    override init(frame: CGRect) {
        super.init(frame: frame)

        let player = AVPlayer(url: URL(string: mp4Url)!)
        
        let avLayer = AVPlayerLayer(player: player)
        self.layer.addSublayer(avLayer)
        avLayer.frame = self.frame
        
        player.play()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
