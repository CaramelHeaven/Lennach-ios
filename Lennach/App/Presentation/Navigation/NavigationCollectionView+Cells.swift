//
//  TableViewControllerTest.swift
//  Lennach
//
//  Created by Sergey Fominov on 01/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

protocol BoardNavigationSelectable: class {
    func selectedBoard (boardName: String)
}

class ItemCell: UICollectionViewCell {

    var isShakingView = false

    fileprivate let btnBoard: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.layer.cornerRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 4
        view.backgroundColor = UIColor(displayP3Red: 214, green: 214, blue: 214, alpha: 1)
        view.layer.masksToBounds = false
        //add view and put this btn inside created view for shadow making
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.shadowColor = UIColor.lightGray.cgColor

        return view
    }()

    fileprivate let labelBoardName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.numberOfLines = 1

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

        NSLayoutConstraint.activate([
            btnBoard.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            btnBoard.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            btnBoard.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            btnBoard.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8),
            ])

        addConstraint(NSLayoutConstraint(item: labelBoardName, attribute: .centerX, relatedBy: .equal, toItem: btnBoard, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: labelBoardName, attribute: .centerY, relatedBy: .equal, toItem: btnBoard, attribute: .centerY, multiplier: 1, constant: 0))
    }

    func shakeItem(_ flag: Bool) {
        if flag {
            let animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.duration = 0.30
            animation.repeatCount = Float.infinity
            animation.autoreverses = true
            animation.fromValue = -1 * 0.2
            animation.toValue = 0.2

            self.layer.add(animation, forKey: "position")
        } else {
            self.layer.removeAllAnimations()
        }
    }
}

class ItemEmptyCell: UICollectionViewCell {

}

class ItemCellAdd: UICollectionViewCell {

    fileprivate let btnAddBoard: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.setImage(UIImage(named: "IconAdd"), for: .normal)
        view.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        view.layer.cornerRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 4
        view.backgroundColor = UIColor(displayP3Red: 214, green: 214, blue: 214, alpha: 1)
        view.layer.masksToBounds = false

        view.layer.borderColor = UIColor.white.cgColor
        view.layer.shadowColor = UIColor.lightGray.cgColor

        return view
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

        btnAddBoard.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        btnAddBoard.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
        btnAddBoard.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
        btnAddBoard.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8).isActive = true
    }
}

class NavigationCollectionViewController: UICollectionViewController, BottomSheet, UICollectionViewDelegateFlowLayout {
    var bottomSheetDelegate: BottomSheetDelegate?
    private let maxVisibleContentHeight: CGFloat = 280
    private var boardsData = Array<BoardNavigatable>()
    private var isShakingAnimationCellsWorking = false

    weak var boardSelectable: BoardNavigationSelectable?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(ItemCellAdd.self, forCellWithReuseIdentifier: "itemCellAdd")
        collectionView.register(ItemEmptyCell.self, forCellWithReuseIdentifier: "ItemEmptyCell")
        collectionView.contentInset.top = maxVisibleContentHeight

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 2, left: 10, bottom: 0, right: 10)
        collectionView!.collectionViewLayout = layout

        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showBoardsFromDb()
        }
    }

    private func showBoardsFromDb() {
        LocalRepository.instance.provideReadUserSavedBoards { (data) in
            if let objects = data as? [BoardDescription] {
                self.boardsData = objects
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
        switch boardsData[indexPath.item] {
        case let board as BoardDescription:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCell
            cell.backgroundColor = .clear
            cell.labelBoardName.text = "/" + board.id
            cell.btnBoard.addTarget(self, action: #selector(selectingCurrentBoard(_:)), for: .touchUpInside)

            let gesture = UILongPressGestureRecognizer(target: self, action: #selector(removeCurrentBoard(_:)))
            cell.btnBoard.addGestureRecognizer(gesture)

            return cell
        case _ as AddBoard:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCellAdd", for: indexPath) as! ItemCellAdd
            cell.btnAddBoard.addTarget(self, action: #selector(addMoreBoards), for: .touchUpInside)

            return cell
        case _ as EmtpyBoard:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemEmptyCell", for: indexPath) as! ItemEmptyCell
            cell.backgroundColor = .clear

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

    @objc private func removeCurrentBoard(_ gesture: UILongPressGestureRecognizer) {
        if !isShakingAnimationCellsWorking {
            isShakingAnimationCellsWorking = true
            enableShaskingInCollectionView(flag: true)
        }
    }

    @objc private func selectingCurrentBoard(_ sender: UIButton) {
        if isShakingAnimationCellsWorking {
            isShakingAnimationCellsWorking = false
            enableShaskingInCollectionView(flag: false)

            collectionView.performBatchUpdates({
                let index = collectionView.indexPath(for: sender.superview as! ItemCell)!
                let boardId = (boardsData[index.row] as! BoardDescription).id
                
                boardsData.remove(at: index.row)
                self.collectionView.deleteItems(at: [index])
                
                MainRepository.instance.provideDeleteBoardFromNavigation(boardId, completion: { result in
                    print("REMOVED BOARD: \(result)")
                })
            })
        } else {
            let indexPath = collectionView.indexPath(for: (sender.superview) as! ItemCell)
            boardSelectable?.selectedBoard(boardName: (boardsData[indexPath!.row] as! BoardDescription).id)
        }
    }

    private func enableShaskingInCollectionView(flag: Bool) {
        for indexPath in collectionView.indexPathsForVisibleItems {
            if let cell = collectionView.cellForItem(at: indexPath) as? ItemCell {
                cell.shakeItem(flag)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 62, height: 54)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomSheetDelegate?.bottomSheetScrolling(self, didScrollTO: collectionView!.contentOffset)

        if collectionView!.contentSize.height < collectionView!.bounds.height {
            collectionView!.contentSize.height = collectionView!.bounds.height
        }
    }

    func popupClosed() {
        showBoardsFromDb()
    }

    deinit {
        print("NavigationCollectionViewController deInit")
    }
}

