//
//  Kek.swift
//  Lennach
//
//  Created by Sergey Fominov on 01/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

protocol BottomSheetDelegate: AnyObject {
    func bottomSheetScrolling(_ bottomSheet: BottomSheet, didScrollTO contentOffset: CGPoint)
}

protocol BottomSheet: AnyObject {
    var bottomSheetDelegate: BottomSheetDelegate? { get set }
}

protocol NavigationContainerClosable {
    func closed(boardName: String?)
}

extension MainUIBottomSheet: BoardNavigationSelectable {
    func selectedBoard(boardName: String) {
        boardSelected = boardName

        dismissNavigation()
    }
}

class MainUIBottomSheet: UIView {

    fileprivate var boardSelected: String?
    var navigationClosed: NavigationContainerClosable?
    weak var btnRemovingPressed: ButtonRemovingStateControl?

    var tableController: NavigationCollectionViewController? {
        didSet {
            sheetView = tableController?.view
            btnRemovingPressed = tableController
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    fileprivate func initBoardNavigationSelectable() {
        tableController?.boardSelectable = self
    }

    private var sheetBackgroundTopConstraint: NSLayoutConstraint?

    fileprivate let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0

        return view
    }()

    private let menuBar: UIView = {
        let menu = UIView()
        menu.translatesAutoresizingMaskIntoConstraints = false
        menu.backgroundColor = .black

        return menu
    }()

    private let menuText: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor.white
        view.text = "Навигация"
        view.font = UIFont(name: view.font.fontName, size: 13)

        return view
    }()

    private let sheetBackground: BottomSheetBackgroundView = {
        let view = BottomSheetBackgroundView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let btnCancelRemovingItems: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Отменить", for: .normal)
        view.titleLabel?.font = UIFont(name: view.titleLabel!.font.fontName, size: 12)
        //set state
        view.isHidden = true

        return view
    }()

    private var sheetView: UIView?

    //Distance between top sheetBackground and sheet view. We set 36 because on the top we have a menuBar
    var topDistance: CGFloat = 0 {
        didSet {
            print("topDistance: \(topDistance)")
            sheetBackgroundTopConstraint?.constant = topDistance - 50
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupViews() {
        addSubview(blackView)

        blackView.frame = self.frame

        UIView.animate(withDuration: 0.3) {
            self.blackView.alpha = 1
        }
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissNavigation)))

        addSubview(sheetBackground)

        let topConstraint = sheetBackground.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        NSLayoutConstraint.activate([
            topConstraint,
            sheetBackground.heightAnchor.constraint(equalTo: heightAnchor),
            sheetBackground.leftAnchor.constraint(equalTo: leftAnchor),
            sheetBackground.rightAnchor.constraint(equalTo: rightAnchor)
            ])

        sheetBackgroundTopConstraint = topConstraint

        //the sheet table veiw
        addSubview(sheetView!)

        NSLayoutConstraint.activate([
            sheetView!.leftAnchor.constraint(equalTo: leftAnchor),
            sheetView!.rightAnchor.constraint(equalTo: rightAnchor),
            sheetView!.topAnchor.constraint(equalTo: topAnchor),
            sheetView!.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])

        addSubview(menuBar)
        NSLayoutConstraint.activate([
            topConstraint,
            menuBar.heightAnchor.constraint(equalToConstant: 30),
            menuBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])

        menuBar.addSubview(menuText)
        menuBar.addSubview(btnCancelRemovingItems)

        NSLayoutConstraint.activate([
            menuText.centerXAnchor.constraint(equalTo: menuBar.centerXAnchor),
            menuText.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            menuText.widthAnchor.constraint(equalToConstant: 70),
            menuText.heightAnchor.constraint(equalToConstant: 20),

            btnCancelRemovingItems.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor),
            btnCancelRemovingItems.trailingAnchor.constraint(equalTo: menuBar.trailingAnchor, constant: -16),
            btnCancelRemovingItems.heightAnchor.constraint(equalToConstant: 20),
            btnCancelRemovingItems.widthAnchor.constraint(equalToConstant: 60),
            ])
        // cell.btnAddBoard.addTarget(self, action: #selector(addMoreBoards), for: .touchUpInside)

        if let window = UIApplication.shared.keyWindow {
            sheetBackground.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: window.frame.height)
            menuBar.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: window.frame.height)
        }

        UIView.animate(withDuration: 0.2, animations: {
            if let window = UIApplication.shared.keyWindow {
                self.sheetBackground.frame = CGRect(x: 0, y: 340, width: window.frame.width, height: window.frame.height)
                self.menuBar.frame = CGRect(x: 0, y: 340, width: window.frame.width, height: window.frame.height)
            }
        }) { _ in
            self.btnCancelRemovingItems.addTarget(self, action: #selector(self.actionBtnRemovingItems(_:)), for: .touchUpInside)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        menuBar.frame = CGRect(x: 0, y: sheetBackground.frame.minY, width: sheetBackground.frame.width, height: 30)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if btnCancelRemovingItems.bounds.contains(btnCancelRemovingItems.convert(point, from: self)) {
            return btnCancelRemovingItems.hitTest(btnCancelRemovingItems.convert(point, from: self), with: event)
        } else if sheetBackground.bounds.contains(sheetBackground.convert(point, from: self)) {
            return sheetView!.hitTest(sheetView!.convert(point, from: self), with: event)
        }
        return blackView.hitTest(blackView.convert(point, from: self), with: event)
    }

    @objc func dismissNavigation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.blackView.alpha = 0
            self.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.sheetBackground.frame = CGRect(x: 0, y: window.frame.height, width: self.sheetBackground.frame.width, height: 0)
                self.menuBar.frame = CGRect(x: 0, y: window.frame.height, width: self.menuBar.frame.width, height: 0)
            }
            self.tableController!.dismiss(animated: false, completion: nil)
        }) { _ in
            self.removeFromSuperview()
            self.navigationClosed?.closed(boardName: self.boardSelected)
        }
    }

    @objc func actionBtnRemovingItems(_ sender: UIButton) {
        btnRemovingPressed?.pressed()
    }

    deinit {
        print("MainUIBottomSheet deInit")
    }
}

class NavigationContainer: NSObject, UICollectionViewDelegateFlowLayout {

    var mainUIBottomSheet: MainUIBottomSheet?
    var tableController: NavigationCollectionViewController?
    private var blackView = UIView()

    override init() {
        super.init()

        let layout = UICollectionViewFlowLayout()
        tableController = NavigationCollectionViewController(collectionViewLayout: layout)

        mainUIBottomSheet = MainUIBottomSheet()
        mainUIBottomSheet?.tableController = tableController

        mainUIBottomSheet?.initBoardNavigationSelectable()
        //kek
    }

    func showLayout() {
        if let window = UIApplication.shared.keyWindow {

            window.addSubview(mainUIBottomSheet!)
            mainUIBottomSheet!.frame = window.frame

            mainUIBottomSheet!.setupViews()
        }
    }

    deinit {
        print("NavigationContainer deInit")
    }
}
