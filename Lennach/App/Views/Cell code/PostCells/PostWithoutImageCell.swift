//
//  PostWithoutImageCell.swift
//  Lennach
//
//  Created by Sergey Fominov on 13/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

//This protocol used for action button handler, also used inside PostWithImageCell
protocol ReplyClickable {
    func click(cell: UITableViewCell)
}

//DEPRECATED 2 protocols
//This protocol used on both post classes cell inside our folder
protocol AnswerGestureGrantable {
    var originalCenter: CGPoint { get set }
    var returnToBoard: Bool { get set }

    func initAnswerGesture()
}

//This protocol used inside ThreadController for showing AnswerView
protocol CellGestureCompletable {
    func showingAnswerView(cell: UITableViewCell)
}

class PostWithoutImageCell: UITableViewCell, AnswerGestureGrantable {

    var originalCenter = CGPoint()
    var returnToBoard = false

    @IBOutlet weak var labelNumberAndDate: UILabel!
    @IBOutlet weak var tvComment: UITextView!
    @IBOutlet weak var btnReplies: UIButton!

    var gestureCompletable: CellGestureCompletable?
    var clickable: ReplyClickable?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        initAnswerGesture()

        btnReplies.addTarget(self, action: #selector(actionRepliesClick), for: .touchUpInside)
    }

    @objc func actionRepliesClick() {
        clickable?.click(cell: self)
    }

    //For future. In the current release, we make this app read only
    func initAnswerGesture() {
        print("inited answer gesture")
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
    }
}
