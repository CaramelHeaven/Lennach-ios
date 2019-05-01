//
//  TableViewControllerTest.swift
//  Lennach
//
//  Created by Sergey Fominov on 01/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {

    fileprivate let btnBoard: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.lightGray
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 4

        return btn
    }()

    fileprivate let labelBoardName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.red

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(btnBoard)
        addSubview(labelBoardName)

        // btnBoard.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        btnBoard.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        btnBoard.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        btnBoard.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2).isActive = true
        btnBoard.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8).isActive = true

        addConstraint(NSLayoutConstraint(item: labelBoardName, attribute: .centerX, relatedBy: .equal, toItem: btnBoard, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: labelBoardName, attribute: .centerY, relatedBy: .equal, toItem: btnBoard, attribute: .centerY, multiplier: 1, constant: 0))
    }
}

class Kekable: UICollectionViewController, BottomSheet, UICollectionViewDelegateFlowLayout {
    var bottomSheetDelegate: BottomSheetDelegate?
    private let maxVisibleContentHeight: CGFloat = 400

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.contentInset.top = maxVisibleContentHeight

        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
    }

    private let countries = Locale.isoRegionCodes.prefix(490).map(Locale.current.localizedString(forRegionCode:))

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countries.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCell
        cell.backgroundColor = .clear
        cell.labelBoardName.text = "/b"

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayout: \(collectionView.contentOffset)")
        bottomSheetDelegate?.bottomSheetScrolling(self, didScrollTO: collectionView!.contentOffset)
        print("collection view: \(collectionView.contentSize), bounds height: \(collectionView.bounds.height)")
        if collectionView!.contentSize.height < collectionView!.bounds.height {
            collectionView!.contentSize.height = collectionView!.bounds.height
        }
    }
}

