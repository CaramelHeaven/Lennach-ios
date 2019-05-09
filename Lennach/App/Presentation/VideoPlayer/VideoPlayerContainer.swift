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
        view.backgroundColor = UIColor(white: 0, alpha: 0.9)
        view.alpha = 0

        return view
    }()

    private let videoPlayerView: VideoPlayerView = {
        let view = VideoPlayerView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    func showVideo() {
        if let window = UIApplication.shared.keyWindow {
            print("showVideo")
            window.addSubview(blackView)
            blackView.frame = window.frame

            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))

            blackView.addSubview(videoPlayerView)
            print("videoPlayerView added")
            NSLayoutConstraint.activate([
                videoPlayerView.centerXAnchor.constraint(equalTo: blackView.centerXAnchor),
                videoPlayerView.centerYAnchor.constraint(equalTo: blackView.centerYAnchor),
                videoPlayerView.heightAnchor.constraint(equalToConstant: blackView.bounds.height / 3),
                videoPlayerView.widthAnchor.constraint(equalToConstant: blackView.bounds.width - 10)
                ])

            UIView.animate(withDuration: 0.3, animations: {
                self.blackView.alpha = 1
            }) { _ in
                self.videoPlayerView.playerView.play()
            }
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
