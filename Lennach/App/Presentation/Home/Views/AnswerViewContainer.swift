//
//  AnswerView.swift
//  Lennach
//
//  Created by Sergey Fominov on 07/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

class AnswerViewContainer: NSObject {

    override init() {
        print("inited answer view")
        super.init()
    }

    deinit {
        print("deInit answerViewContainer")
    }

    private var heightAnswerView: NSLayoutConstraint!

    private let answerView: AnswerView = {
        let view = AnswerView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.alpha = 0

        return view
    }()

    func showAnswerView() {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(blackView)
            blackView.frame = window.frame

            print("black view: \(blackView.frame)")
            blackView.addSubview(answerView)
            heightAnswerView = answerView.heightAnchor.constraint(equalToConstant: 130)
            NSLayoutConstraint.activate([
                answerView.leadingAnchor.constraint(equalTo: blackView.leadingAnchor),
                answerView.trailingAnchor.constraint(equalTo: blackView.trailingAnchor),
                answerView.topAnchor.constraint(equalTo: blackView.topAnchor),
                heightAnswerView
                ])

            answerView.expandableView = self

            UIView.animate(withDuration: 0.3) {
                self.blackView.alpha = 1
            }
        }
    }
}

extension AnswerViewContainer: AnswerViewExpandable {
    func expandingView(flag: Bool) {
        let boundsHeight = self.answerView.bounds.height
        let boundsWidth = self.answerView.bounds.width

        if flag {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                    self.answerView.frame = CGRect(x: 0, y: 0, width: self.blackView.bounds.width, height: self.blackView.bounds.height)
                }) { (result) in
                if result {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.answerView.enterNameTextField.isHidden = false
                        self.answerView.enterNameTextField.alpha = 1
                        self.answerView.counterLabel.frame = CGRect(x: 4, y: 34, width: boundsWidth - 42, height: 10)
                        self.answerView.enteringTextField.frame = CGRect(x: 4, y: 48, width: boundsWidth - 38, height: boundsHeight + 100)
                    })
                }
            }
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                    self.answerView.enterNameTextField.alpha = 0
                    self.answerView.counterLabel.frame = CGRect(x: 4, y: 10, width: boundsWidth - 42, height: 10)
                    self.answerView.enteringTextField.frame = CGRect(x: 4, y: 22, width: boundsWidth - 38, height: 102)

                }) { (result) in
                if result {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.answerView.enterNameTextField.isHidden = true
                        self.answerView.frame = CGRect(x: 0, y: 0, width: self.blackView.bounds.width, height: 130)
                    })
                }
            }
        }
    }
}
