//
//  VideoPlayerView.swift
//  Lennach
//
//  Created by Sergey Fominov on 09/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

class VideoPlayerView: UIView, OGVPlayerDelegate {

    let webmUrl = "https://2ch.hk/b/src/196045640/15573831947890.webm"
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
            print("called setupViews")
            playerView = OGVPlayerView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
            addSubview(playerView)
            playerView.delegate = self
            playerView.sourceURL = NSURL(string: webmUrl) as URL?
        }
    }
}
