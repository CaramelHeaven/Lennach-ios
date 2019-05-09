//
//  AnswerView.swift
//  Lennach
//
//  Created by Sergey Fominov on 07/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

protocol AnswerViewExpandable: class {
    func expandingView(flag: Bool)
}

class AnswerView: UIView, UITextFieldDelegate {

    var expandableView: AnswerViewExpandable?
    private let captchaViewContainer = CaptchaViewContainer()

    deinit {
        print("answer view deInit")
    }

    lazy var enterNameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Name"
        view.alpha = 0
        view.isHidden = true
        view.font = UIFont.systemFont(ofSize: 14)
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 4
        view.delegate = self

        return view
    }()

    let enteringTextField: UITextView = {
        let view = UITextView()
        view.font = UIFont.systemFont(ofSize: 14)
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8

        return view
    }()

    let counterLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.text = "20/2000"
        view.font = UIFont.systemFont(ofSize: 10)

        return view
    }()

    let expandedButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(actionExpandView), for: .touchUpInside)

        return view
    }()

    let addImageButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(actionAddImageToPost), for: .touchUpInside)

        return view
    }()

    let sendButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(actionSendPost), for: .touchUpInside)

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
        addSubview(enteringTextField)
        addSubview(counterLabel)
        addSubview(expandedButton)
        addSubview(addImageButton)
        addSubview(sendButton)
        addSubview(enterNameTextField)

        //hidesViews
        enterNameTextField.frame = CGRect(x: 4, y: 8, width: bounds.width - 42, height: 20)
        
        //base views for animating
        counterLabel.frame = CGRect(x: 4, y: 10, width: bounds.width - 42, height: 10)
        enteringTextField.frame = CGRect(x: 4, y: 22, width: bounds.width - 38, height: 102)

        NSLayoutConstraint.activate([
            expandedButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            expandedButton.widthAnchor.constraint(equalToConstant: 26),
            expandedButton.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            expandedButton.heightAnchor.constraint(equalToConstant: 26),

            addImageButton.topAnchor.constraint(equalTo: expandedButton.bottomAnchor, constant: 8),
            addImageButton.widthAnchor.constraint(equalToConstant: 26),
            addImageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            addImageButton.heightAnchor.constraint(equalToConstant: 26),

            sendButton.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: 8),
            sendButton.widthAnchor.constraint(equalToConstant: 26),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            sendButton.heightAnchor.constraint(equalToConstant: 26),
            ])
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 15
    }

    var isExpand: Bool = false

    @objc func actionExpandView() {
        isExpand = !isExpand
        print("isExpand: \(isExpand)")
        expandableView?.expandingView(flag: isExpand)
        print("1")
    }

    @objc func actionAddImageToPost() {
        print("2")
    }

    @objc func actionSendPost() {
        captchaViewContainer.showCaptcha()
    }
}
