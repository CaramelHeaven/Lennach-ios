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

class Kek: UIView {

    var tableController: TableViewControllerTest? {
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

    //change constant for sheet background view
    var topDistance: CGFloat = 0 {
        didSet {
            print("topDistance: \(topDistance)")
            sheetBackgroundTopConstraint?.constant = topDistance
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
            sheetView!.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            sheetView!.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
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

class Lol {

    var tableController = TableViewControllerTest()
    let kek = Kek()
    private var blackView = UIView()

    init() {
        print("inited lol")
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
