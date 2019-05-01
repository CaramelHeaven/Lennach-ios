////
////  NavigationExpandView.swift
////  Lennach
////
////  Created by Sergey Fominov on 30/04/2019.
////  Copyright © 2019 CaramelHeaven. All rights reserved.
////
//
//import UIKit
//
//protocol NavigationButtonClickProvider {
//    func pressedOnItem(boardName: String)
//}
//
//class NavigationExpandView: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
//
//    private var blackView = UIView()
//    private var cellHeight: CGFloat = 50
//    private let cellId = "cellId"
//    private var boards = ["/pop", "/he", "/pa", "/pr", "/b", "/pop", "/he", "/pa", "/pr", "/b", "/pop", "/he", "/pa", "/pr", "/b", "/pop", "/he", "/pa", "/pr", "/b", "/pop", "/he", "/pa", "/pr", "/b", "/pop", "/he", "/pa", "/pr", "/b", "/pop", "/he", "/pa", "/pr", "/b", "/pop", "/he", "/pa", "/pr", "/b", "/pop", "/he", "/pa", "/pr", "/b", "/pop", "/he", "/pa", "/pr", "/b", "/pop", "/he", "/pa", "/pr", "/b", "/pop", "/he", "/pa", "/pr", "/b", "/pop", "/he", "/pa", "/pr", "/b", "/pop", "/he", "/pa", "/pr", "/b"] // from database
//    private let controlVisibleHeight: CGFloat = 420 // control visible height collection view
//    var btnClickProvider: NavigationButtonClickProvider?
//
//    lazy private var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.translatesAutoresizingMaskIntoConstraints = false
//        cv.backgroundColor = .lightGray
//        cv.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//        cv.backgroundColor = UIColor.white
//
//        return cv
//    }()
//
//    private var scrollView: UIScrollView = {
//        let scroll = UIScrollView()
//        return scroll
//    }()
//
//    override init() {
//        super.init()
//        print("init navigation")
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.register(NavigationBoardCell.self, forCellWithReuseIdentifier: cellId)
//    }
//
//    //MARK: expanding navigation
//    func showNavigation() {
//        if let window = UIApplication.shared.keyWindow {
//            //init blacking alpha view
//            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
//            window.addSubview(blackView)
//
//            blackView.frame = window.frame
//            blackView.alpha = 0
//
//            UIView.animate(withDuration: 0.5) {
//                self.blackView.alpha = 1
//            }
//
//            window.addSubview(scrollView)
//            self.scrollView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
//
//            scrollView.addSubview(collectionView)
//
//
//            //set collectionView
//            self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 0)
//            // self.collectionView.isScrollEnabled = false
//            //   collectionView.contentOffset
//            scrollView.delegate = self
//
//            UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//                self.collectionView.frame = CGRect(x: 0, y: self.controlVisibleHeight, width: self.collectionView.frame.width, height: (self.blackView.frame.height - self.controlVisibleHeight) + self.controlVisibleHeight)
//            }, completion: nil)
//
//            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: self.blackView.frame.height + controlVisibleHeight)
//
//            scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissNavigation)))
//        }
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        //scrollView.isColl
//        if self.scrollView.contentOffset.y > 120 {
//            self.blackView.insertSubview(collectionView, at: 0)
//        }
////        self.scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
////        if self.scrollView.contentOffset.y > 420 {
////
////
////        }
//        //  scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
//        print("col: \(collectionView.contentOffset), scrollView: \(scrollView.contentOffset)")
//    }
//
//    //MARK: dismissing navigation
//    @objc private func dismissNavigation() {
//        UIView.animate(withDuration: 0.3) {
//            self.blackView.alpha = 0
//            if let window = UIApplication.shared.keyWindow {
//                print("window: \(window.frame.height), \(self.collectionView.frame.width), \(self.collectionView.frame.height)")
//                self.scrollView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
//                //self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
//            }
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return boards.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NavigationBoardCell
//        cell.labelBoardName.text = "q"
//        cell.btnBoard.addTarget(self, action: #selector(kek), for: .touchUpInside)
//
//
//        return cell
//    }
//
//    @objc private func kek(_ sender: UIButton) {
//        if let pos = collectionView.indexPath(for: sender.superview! as! NavigationBoardCell)?.item {
//            btnClickProvider?.pressedOnItem(boardName: boards[pos])
//
//            dismissNavigation()
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: cellHeight, height: cellHeight)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("idnexpath: \(indexPath.item)")
//
//    }
//
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
////        return 0
////    }
//}
//
//class NavigationBoardCell: UICollectionViewCell {
//
//    fileprivate let btnBoard: UIButton = {
//        let btn = UIButton()
//        btn.backgroundColor = UIColor.lightGray
//        btn.layer.cornerRadius = 4
//
//        return btn
//    }()
//
//    fileprivate let labelBoardName: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = UIColor.red
//
//        return label
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupViews() {
//        addSubview(btnBoard)
//        addSubview(labelBoardName)
//
//        btnBoard.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
//
//        addConstraint(NSLayoutConstraint(item: labelBoardName, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
//        addConstraint(NSLayoutConstraint(item: labelBoardName, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
//    }
//}
