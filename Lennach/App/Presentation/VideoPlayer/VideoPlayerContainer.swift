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

    private let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        view.alpha = 0

        return view
    }()

    private let webmPlayer: WebmVideoPlayer = {
        let view = WebmVideoPlayer()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    var lol = ""

    var currentVideoUrl = "" {
        didSet {
            if currentVideoUrl.contains(".webm") { webmPlayer.webmUrl = currentVideoUrl } else { lol = currentVideoUrl }
        }
    }

    func showVideo() {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(blackView)
            blackView.frame = window.frame
            blackView.backgroundColor = .white

            if currentVideoUrl.contains(".webm") {
                blackView.addSubview(webmPlayer)
                print("videoPlayerView added")
                NSLayoutConstraint.activate([
                    webmPlayer.centerXAnchor.constraint(equalTo: blackView.centerXAnchor),
                    webmPlayer.centerYAnchor.constraint(equalTo: blackView.centerYAnchor),
                    webmPlayer.heightAnchor.constraint(equalToConstant: blackView.bounds.height / 3),
                    webmPlayer.widthAnchor.constraint(equalToConstant: blackView.bounds.width - 10)
                    ])

                UIView.animate(withDuration: 0.3, animations: {
                    self.blackView.alpha = 1
                }) { _ in
                    self.webmPlayer.playerView.play()
                }
            } else if currentVideoUrl.contains(".mp4") {
                let mp4Player = Mp4Player(frame: CGRect(x: 0, y: 0, width: blackView.frame.width - 20, height: blackView.frame.height / 3))
                mp4Player.mp4Url = lol
               // mp4Player.backgroundColor = .clear

                blackView.addSubview(mp4Player)
                mp4Player.center = blackView.center
                print("checking mp4Frame: \(mp4Player.frame)")

                UIView.animate(withDuration: 0.3, animations: {
                    self.blackView.alpha = 1
                }) { _ in
                    mp4Player.playMp4()
                }
            }
            print("showVideo")


            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))



        }
    }

    @objc func dismissView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.blackView.alpha = 0
        }) { _ in
            self.blackView.removeFromSuperview()
        }
    }
}
