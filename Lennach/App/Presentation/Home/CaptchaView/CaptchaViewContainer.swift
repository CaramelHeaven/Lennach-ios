//
//  CaptchaViewContainer.swift
//  Lennach
//
//  Created by Sergey Fominov on 08/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

class CaptchaViewContainer: NSObject {

    override init() {
        super.init()
    }

    deinit {
        print("captchaViewContainer deINit")
    }

    private let captchaView: CaptchaView = {
        let view = CaptchaView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4

        return view
    }()

    private let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.alpha = 0

        return view
    }()

    func showCaptcha() {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(blackView)
            blackView.frame = window.frame

            blackView.addSubview(captchaView)
            captchaView.frame = CGRect(x: 0, y: 0, width: blackView.bounds.width - (22 * 2), height: 130)
            captchaView.center = blackView.center

            UIView.animate(withDuration: 0.3) {
                self.blackView.alpha = 1
            }

            print("black view: \(blackView)")
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
        }
    }

    @objc func dismissView() {
        print("dismiss")
        UIView.animate(withDuration: 0.3, animations: {
            self.blackView.alpha = 0
        }) { _ in
            print("completed")
            self.blackView.removeFromSuperview()
        }
    }
}
