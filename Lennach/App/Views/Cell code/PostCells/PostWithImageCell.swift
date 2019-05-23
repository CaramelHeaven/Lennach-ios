//
//  PostWithImageCell.swift
//  Lennach
//
//  Created by Sergey Fominov on 26/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

class PostWithImageCell: UITableViewCell, AnswerGestureGrantable {

    var originalCenter = CGPoint()
    var returnToBoard: Bool = false

    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var labelNumberAndDate: UILabel!
    @IBOutlet weak var tvComment: UITextView!
    @IBOutlet weak var btnReplies: UIButton!

    var gestureCompletable: CellGestureCompletable?
    var clickable: ReplyClickable?
    
    //MARK: image click listener
    var imageClicker: (() -> Void)? = nil
    var videoClicker: (() -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        imagePost.layer.cornerRadius = 8
        btnReplies.addTarget(self, action: #selector(actionReplyClick), for: .touchUpInside)
    }
    
    func initVideoOrImageClicker(state: String) {
        if state == "video" {
            imagePost.isUserInteractionEnabled = true
            imagePost.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapVideo)))
        } else if state == "image" {
            imagePost.isUserInteractionEnabled = true
            imagePost.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImage)))
        }
    }
    
    @objc private func tapImage() {
        imageClicker?()
    }
    
    @objc private func tapVideo() {
        videoClicker?()
    }

    @objc func actionReplyClick() {
        clickable?.click(cell: self)
    }

    //For future. In the current release, we make this app read only
    func initAnswerGesture() {
        let answerGesture = UIPanGestureRecognizer(target: self, action: #selector(answerToPostGesture(_:)))
        addGestureRecognizer(answerGesture)

        answerGesture.delegate = self
        self.selectionStyle = .none
    }

    @objc private func answerToPostGesture(_ sender: UIPanGestureRecognizer) {
        if !returnToBoard {
            switch sender.state {
            case .began:
                originalCenter = center
                break
            case .changed:
                let translation = sender.translation(in: self)

                if frame.origin.x > -frame.size.width / 3 {
                    center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
                    //TODO: make vibration
                }
                //allowToAnswer = frame.origin.x < -frame.size.width / 3
                break
            case .ended:
                let originalFrame = CGRect(x: 0, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)

                UIView.animate(withDuration: 0.3, animations: {
                    self.frame = originalFrame
                }) { _ in
                    self.gestureCompletable?.showingAnswerView(cell: self)
                }
                break
            default:
                print("nothing")
            }
        }
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gesture = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = gesture.translation(in: superview!)
            if abs(translation.x) > abs(translation.y) && translation.x < 0 {
                return true
            }
            return false
        }
        return false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
