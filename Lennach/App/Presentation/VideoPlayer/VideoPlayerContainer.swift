//
//  VideoPlayerContainer.swift
//  Lennach
//
//  Created by Sergey Fominov on 09/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

class VideoPlayerContainer: NSObject {

    override init() {
        super.init()
    }

    deinit {
        print("VideoPlayerContainer deInit")
    }

    private let backgroundBlackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        view.alpha = 0

        return view
    }()

    private let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0)
        view.alpha = 0

        return view
    }()

    private let webmPlayer: WebmVideoPlayer = {
        let view = WebmVideoPlayer()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private var mp4Player: Mp4Player!

    var currentVideoUrl = "" {
        didSet {
            if currentVideoUrl.contains(".webm") {
                webmPlayer.webmUrl = currentVideoUrl
            }
        }
    }

    func redrawingVideoViews(currentSize: CGSize) {
        blackView.frame = CGRect(x: 0, y: 0, width: currentSize.width, height: currentSize.height)
        if currentVideoUrl.contains(".mp4") {
            mp4Player.frame = blackView.frame
            mp4Player.center = blackView.center
        } else {

        }
    }

    func showVideo() {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(backgroundBlackView)
            window.addSubview(blackView)

            blackView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
            backgroundBlackView.frame = CGRect(x: 0, y: 0, width: window.frame.width * 3, height: window.frame.height * 3)

            if currentVideoUrl.contains(".webm") {
                blackView.addSubview(webmPlayer)
                print("videoPlayerView added: \(currentVideoUrl)")
                NSLayoutConstraint.activate([
                    webmPlayer.centerXAnchor.constraint(equalTo: blackView.centerXAnchor),
                    webmPlayer.centerYAnchor.constraint(equalTo: blackView.centerYAnchor),
                    webmPlayer.heightAnchor.constraint(equalToConstant: blackView.bounds.height / 3),
                    webmPlayer.widthAnchor.constraint(equalToConstant: blackView.bounds.width - 10)
                    ])

                UIView.animate(withDuration: 0.3, animations: {
                    self.blackView.alpha = 1
                    self.backgroundBlackView.alpha = 1
                }) { _ in
                    self.webmPlayer.playerView.play()
                }
            } else if currentVideoUrl.contains(".mp4") {
                mp4Player = Mp4Player(frame: CGRect(x: 0, y: 0, width: blackView.frame.width, height: blackView.frame.height))
                blackView.addSubview(mp4Player)

                UIView.animate(withDuration: 0.3, animations: {
                    self.blackView.alpha = 1
                    self.backgroundBlackView.alpha = 1
                }) { _ in
                    self.mp4Player.mp4Url = self.currentVideoUrl
                    self.mp4Player.initPlayer()
                    print("black view center: \(self.blackView.center)")
                    self.mp4Player.center = self.blackView.center
                }
            }
            print("showVideo")

           // blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
        }
    }

    @objc func dismissView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.blackView.alpha = 0
            self.backgroundBlackView.alpha = 0
        }) { _ in
            self.blackView.removeFromSuperview()
            self.backgroundBlackView.removeFromSuperview()
        }
    }
}
