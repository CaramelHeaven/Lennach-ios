//
//  VideoPlayerView.swift
//  Lennach
//
//  Created by Sergey Fominov on 09/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

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
