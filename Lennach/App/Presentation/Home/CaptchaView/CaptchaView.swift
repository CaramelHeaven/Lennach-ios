//
//  CaptchaView.swift
//  Lennach
//
//  Created by Sergey Fominov on 08/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit
import Kingfisher

class CaptchaView: UIView {

    let captchaImage: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .purple
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    let testText: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }

    private func setupViews() {
        addSubview(captchaImage)
        addSubview(testText)

        NSLayoutConstraint.activate([
            captchaImage.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            captchaImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            captchaImage.widthAnchor.constraint(equalToConstant: bounds.width - (22 * 2)),
            captchaImage.heightAnchor.constraint(equalToConstant: 80),

            testText.topAnchor.constraint(equalTo: captchaImage.bottomAnchor, constant: 8),
            testText.leadingAnchor.constraint(equalTo: leadingAnchor),
            testText.trailingAnchor.constraint(equalTo: trailingAnchor),
            testText.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 4)
            ])
    }
}
