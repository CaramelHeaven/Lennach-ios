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

class ItemCellAdd: UICollectionViewCell {

    fileprivate let btnAddBoard: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.red
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 4

        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(btnAddBoard)

        // btnBoard.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        btnAddBoard.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        btnAddBoard.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        btnAddBoard.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2).isActive = true
        btnAddBoard.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8).isActive = true
    }
}

class NavigationCollectionViewController: UICollectionViewController, BottomSheet, UICollectionViewDelegateFlowLayout {
    var bottomSheetDelegate: BottomSheetDelegate?
    private let maxVisibleContentHeight: CGFloat = 400
    private var boardsData = Array<BoardNavigatable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(ItemCellAdd.self, forCellWithReuseIdentifier: "itemCellAdd")
        collectionView.contentInset.top = maxVisibleContentHeight

        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false

        showBoardsFromDb()
    }

    private func showBoardsFromDb() {
        LocalRepository.instance.provideReadUserSavedBoards { (data) in
            if let objects = data as? [BoardDescription] {
                self.boardsData += objects
                self.boardsData.append(AddBoard())

                (1...45).forEach { _ in self.boardsData.append(EmtpyBoard()) } // add empty data

                self.collectionView.reloadData()
            }
        }
    }

    //plus 1 because we show all users added board and the last item - btn add board - provided list of all board which user can be add any of it
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boardsData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("indexPath: \(indexPath.item)")
        switch boardsData[indexPath.item] {
        case let board as BoardDescription:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCell
            cell.backgroundColor = .clear
            cell.labelBoardName.text = board.id
            cell.btnBoard.addTarget(self, action: #selector(selectingCurrentBoard(_:)), for: .touchUpInside)

            return cell
        case _ as AddBoard:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCellAdd", for: indexPath) as! ItemCellAdd
            cell.backgroundColor = .clear
            cell.btnAddBoard.addTarget(self, action: #selector(addMoreBoards), for: .touchUpInside)

            return cell
        case _ as EmtpyBoard:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCellAdd", for: indexPath) as! ItemCellAdd
            cell.backgroundColor = .clear
            cell.btnAddBoard.backgroundColor = .clear

            return cell
        default:
            return UICollectionViewCell()
        }
    }

    @objc func addMoreBoards(_ sender: UIButton) {
        let popupBoards = PopupBoardView()
        popupBoards.parentController = self
        popupBoards.showPopup()
    }

    @objc func selectingCurrentBoard(_ sender: UIButton) {
        let indexPath = collectionView.indexPath(for: (sender.superview) as! ItemCell)
        
        print("clicked: \(indexPath!.row)")
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

    func popupClosed() {
        showBoardsFromDb()
    }
}

