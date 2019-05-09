//
//  Mp4Player.swift
//  Lennach
//
//  Created by Sergey Fominov on 09/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit
import AVFoundation

class Mp4Player: UIView {
    var mp4Url = "" {
        didSet { player = AVPlayer(url: URL(string: mp4Url)!) }
    }

    private var player: AVPlayer?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        print("player != nil")
       // guard let player = player else { return }
        
        let layer = AVPlayerLayer(player: player)
        self.layer.addSublayer(layer)
        layer.frame = self.frame
    }

    func playMp4() {
        player?.play()
    }
}
