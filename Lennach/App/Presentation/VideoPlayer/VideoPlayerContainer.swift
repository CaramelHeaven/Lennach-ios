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
    }

    private let backgroundContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let videoButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red

        return view
    }()

    private let videoLengthLabel: UILabel = {
        let view = UILabel()
        view.text = "00:00"
        view.textColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.boldSystemFont(ofSize: 12)
        view.textAlignment = .right

        return view
    }()

    private let currentLengthLabel: UILabel = {
        let view = UILabel()
        view.text = "00:00"
        view.textColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.boldSystemFont(ofSize: 12)
        view.textAlignment = .right

        return view
    }()

    private let videoSlider: UISlider = {
        let view = UISlider()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.minimumTrackTintColor = .cyan
        view.maximumTrackTintColor = .white

        return view
    }()

    private let containerForMp4Player: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let toolbarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)

        return view
    }()

    private let toolbarTitleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white

        return view
    }()

    func showVideo() {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(backgroundBlackView)
            window.addSubview(blackView)

            blackView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
            backgroundBlackView.frame = CGRect(x: 0, y: 0, width: window.frame.width * 3, height: window.frame.height * 3)

            //added toolbar
            blackView.addSubview(toolbarView)
            NSLayoutConstraint.activate([
                toolbarView.topAnchor.constraint(equalTo: blackView.topAnchor),
                toolbarView.leadingAnchor.constraint(equalTo: blackView.leadingAnchor),
                toolbarView.trailingAnchor.constraint(equalTo: blackView.trailingAnchor),
                toolbarView.heightAnchor.constraint(equalToConstant: 40)
                ])

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

                //blackView.addSubview(mp4Player)

                blackView.addSubview(containerForMp4Player)

                NSLayoutConstraint.activate([
                    containerForMp4Player.centerXAnchor.constraint(equalTo: blackView.centerXAnchor),
                    containerForMp4Player.centerYAnchor.constraint(equalTo: blackView.centerYAnchor),
                    containerForMp4Player.heightAnchor.constraint(equalToConstant: blackView.bounds.height / 2),
                    containerForMp4Player.widthAnchor.constraint(equalToConstant: blackView.bounds.width - 10)
                    ])

                mp4Player = Mp4Player(frame: CGRect(x: 0, y: 0, width: blackView.frame.width - 10, height: blackView.frame.height / 2))
                containerForMp4Player.addSubview(mp4Player)

                mp4Player.mp4Delegate = self

                UIView.animate(withDuration: 0.3, animations: {
                    self.blackView.alpha = 1
                    self.backgroundBlackView.alpha = 1
                }) { _ in
                    self.mp4Player.mp4Url = self.currentVideoUrl
                    self.mp4Player.initPlayer()

                    //init background content
                    self.containerForMp4Player.addSubview(self.backgroundContentView)

                    NSLayoutConstraint.activate([
                        self.backgroundContentView.trailingAnchor.constraint(equalTo: self.containerForMp4Player.trailingAnchor),
                        self.backgroundContentView.leadingAnchor.constraint(equalTo: self.containerForMp4Player.leadingAnchor),
                        self.backgroundContentView.heightAnchor.constraint(equalToConstant: 40),
                        self.backgroundContentView.bottomAnchor.constraint(equalTo: self.containerForMp4Player.bottomAnchor),
                        ])

                    self.backgroundContentView.addSubview(self.videoLengthLabel)
                    self.backgroundContentView.addSubview(self.videoButton)
                    self.backgroundContentView.addSubview(self.currentLengthLabel)
                    self.backgroundContentView.addSubview(self.videoSlider)

                    NSLayoutConstraint.activate([
                        self.videoLengthLabel.trailingAnchor.constraint(equalTo: self.backgroundContentView.trailingAnchor, constant: -4),
                        self.videoLengthLabel.centerYAnchor.constraint(equalTo: self.backgroundContentView.centerYAnchor),
                        self.videoLengthLabel.widthAnchor.constraint(equalToConstant: 40),
                        self.videoLengthLabel.heightAnchor.constraint(equalToConstant: 30),

                        self.videoButton.leadingAnchor.constraint(equalTo: self.backgroundContentView.leadingAnchor, constant: 4),
                        self.videoButton.centerYAnchor.constraint(equalTo: self.backgroundContentView.centerYAnchor),
                        self.videoButton.widthAnchor.constraint(equalToConstant: 30),
                        self.videoButton.heightAnchor.constraint(equalToConstant: 30),

                        self.currentLengthLabel.leadingAnchor.constraint(equalTo: self.videoButton.trailingAnchor),
                        self.currentLengthLabel.centerYAnchor.constraint(equalTo: self.backgroundContentView.centerYAnchor),
                        self.currentLengthLabel.widthAnchor.constraint(equalToConstant: 40),
                        self.currentLengthLabel.heightAnchor.constraint(equalToConstant: 30),

                        self.videoSlider.leadingAnchor.constraint(equalTo: self.currentLengthLabel.trailingAnchor, constant: 4),
                        self.videoSlider.trailingAnchor.constraint(equalTo: self.videoLengthLabel.leadingAnchor),
                        self.videoSlider.centerYAnchor.constraint(equalTo: self.backgroundContentView.centerYAnchor),
                        self.videoSlider.heightAnchor.constraint(equalToConstant: 30),
                        ])

                    //just did it
                    self.videoButton.addTarget(self, action: #selector(self.buttonStopOrPlay), for: .touchUpInside)
                    self.videoSlider.addTarget(self, action: #selector(self.handlerVideoSlider), for: .valueChanged)
                }
            }
        }
    }

    @objc func handlerVideoSlider() {
        if let duration = mp4Player.player!.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoSlider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)

            mp4Player.player!.seek(to: seekTime) { _ in
                //kek
            }
        }
    }

    @objc func buttonStopOrPlay() {
        mp4Player?.handlerButtonClick()

        //TODO: change button image
        if mp4Player.isStopPlaying {

        } else {

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

extension VideoPlayerContainer: Mp4PlayerViewsUpdater {
    func videoSliderUpdate(value: Float) {
        videoSlider.value = value
    }

    func videoCurrentTime(seconds: String, minutes: String) {
        currentLengthLabel.text = "\(minutes):\(seconds)"
    }

    func videoCommonLength(seconds: String, minutes: String) {
        videoLengthLabel.text = "\(minutes):\(seconds)"
    }
}
