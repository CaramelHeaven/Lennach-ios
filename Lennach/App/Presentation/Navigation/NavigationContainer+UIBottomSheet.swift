//
//  Kek.swift
//  Lennach
//
//  Created by Sergey Fominov on 01/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

//protocol BottomSheetDelegate: AnyObject {
//    func bottomSheetScrolling(_ bottomSheet: BottomSheet, didScrollTO contentOffset: CGPoint)
//}
//
//protocol BottomSheet: AnyObject {
//    var bottomSheetDelegate: BottomSheetDelegate? { get set }
//}
protocol BottomSheetDelegate: AnyObject {
    func bottomSheetScrolling(_ bottomSheet: BottomSheet, didScrollTO contentOffset: CGPoint)
}

protocol BottomSheet: AnyObject {
    var bottomSheetDelegate: BottomSheetDelegate? { get set }
}

class MainUIBottomSheet: UIView {

    var tableController: NavigationCollectionView? {
        didSet {
            sheetView = tableController!.view
        }
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
        menu.backgroundColor = .blue

        return menu
    }()

    private let sheetBackground: BottomSheetBackgroundView = {
        let view = BottomSheetBackgroundView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private var sheetView: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)

        print("kek")
    }

    //Distance between top sheetBackground and sheet view. We set 36 because on the top we have a menuBar
    var topDistance: CGFloat = 0 {
        didSet {
            print("topDistance: \(topDistance)")
            sheetBackgroundTopConstraint?.constant = topDistance - 30
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
        print("black view: \(blackView.frame)")
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissNavigation)))

        addSubview(sheetBackground)


        let topConstraint = sheetBackground.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        print("check: \(topConstraint.constant)")
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
        print("memu: \(menuBar.frame)")
    }


    override func layoutSubviews() {
        super.layoutSubviews()

        print("SHEET FUCK YOU: \(sheetBackground.frame)")
        menuBar.frame = CGRect(x: 0, y: sheetBackground.frame.minY, width: sheetBackground.frame.width, height: 30)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if sheetBackground.bounds.contains(sheetBackground.convert(point, from: self)) {
            print("sheetView")
            return sheetView!.hitTest(sheetView!.convert(point, from: self), with: event)
        }
        print("blackView")
        return blackView.hitTest(blackView.convert(point, from: self), with: event)
    }

    @objc func dismissNavigation() {
        UIView.animate(withDuration: 0.3) {
            self.blackView.alpha = 0
            self.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.sheetBackground.frame = CGRect(x: 0, y: window.frame.height, width: self.sheetBackground.frame.width, height: self.sheetBackground.frame.height)
            }
        }
    }
}

class NavigationContainer: NSObject, UICollectionViewDelegateFlowLayout {

    let kek = MainUIBottomSheet()
    var tableController: NavigationCollectionView?
    private var blackView = UIView()

    override init() {
        super.init()
        
        let layout = UICollectionViewFlowLayout()
        tableController = NavigationCollectionView(collectionViewLayout: layout)
        kek.tableController = tableController
        //kek
    }

    func showLayout() {
        print("show")
        if let window = UIApplication.shared.keyWindow {

            window.addSubview(kek)
            kek.frame = window.frame

            kek.setupViews()
        }
    }
}
