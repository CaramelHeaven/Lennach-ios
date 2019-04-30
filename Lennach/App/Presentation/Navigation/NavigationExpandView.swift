//
//  NavigationExpandView.swift
//  Lennach
//
//  Created by Sergey Fominov on 30/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

class NavigationExpandView: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIGestureRecognizerDelegate {

    private var blackView = UIView()
    private var cellHeight: CGFloat = 50
    private let cellId = "cellId"
    private var boards = ["/pop", "/he", "/pa", "/pr", "/b"]

    lazy private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.white

        return cv
    }()

    private var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()

    override init() {
        super.init()
        print("init navigation")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }

    //MARK: expanding navigation
    func showNavigation() {
        if let window = UIApplication.shared.keyWindow {
            //init blacking alpha view
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            window.addSubview(blackView)

            blackView.frame = window.frame
            blackView.alpha = 0

            UIView.animate(withDuration: 0.5) {
                self.blackView.alpha = 1
            }


            window.addSubview(scrollView)
            self.scrollView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)

            scrollView.addSubview(collectionView)

            //set collectionView
            self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 0)
//-1 * (self.cellHeight * CGFloat(self.boards.count))

            let controlVisibleHeight: CGFloat = 420

            print("view black: \(self.blackView.frame)")
            UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.collectionView.frame = CGRect(x: 0, y: controlVisibleHeight, width: self.collectionView.frame.width, height: (self.blackView.frame.height - controlVisibleHeight) + controlVisibleHeight)
            }, completion: nil)

            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: self.blackView.frame.height + controlVisibleHeight)
        }

//        //init gestures
//        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(test))
//        swipeUp.direction = .up
//        swipeUp.delegate = self
        //scrollView.addGestureRecognizer(swipeUp)
        print("scrollView: \(scrollView.frame.height), col: \(collectionView.frame.height)")


        _ = UITapGestureRecognizer(target: self, action: #selector(test))
        //  blackView.addGestureRecognizer(tapGesture)
        //blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissNavigation)))
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc func test(_ sender: UITapGestureRecognizer) {

        print("State: \(sender.state.rawValue)")
    }

    //MARK: dismissing navigation
    @objc private func dismissNavigation() {
        UIView.animate(withDuration: 0.3) {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                print("window: \(window.frame.height), \(self.collectionView.frame.width), \(self.collectionView.frame.height)")
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boards.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .green

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellHeight, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
