//
//  TableViewControllerTest.swift
//  Lennach
//
//  Created by Sergey Fominov on 01/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

class Tap: UICollectionViewCell {

    private let test: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue

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
        addSubview(test)

        NSLayoutConstraint.activate([
            test.heightAnchor.constraint(equalToConstant: 30),
            test.widthAnchor.constraint(equalToConstant: 30),
            test.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            test.topAnchor.constraint(equalTo: topAnchor, constant: 8)
            ])
    }
}

class Kekable: UICollectionViewController, BottomSheet {
    var bottomSheetDelegate: BottomSheetDelegate?
    private let maxVisibleContentHeight: CGFloat = 400

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(Tap.self, forCellWithReuseIdentifier: "cell")
        collectionView.contentInset.top = maxVisibleContentHeight

        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
    }

    private let countries = Locale.isoRegionCodes.prefix(490).map(Locale.current.localizedString(forRegionCode:))

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countries.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Tap
        cell.backgroundColor = .clear

        return cell
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayout: \(collectionView.contentOffset)")
        bottomSheetDelegate?.bottomSheetScrolling(self, didScrollTO: collectionView!.contentOffset)

        if collectionView!.contentSize.height < collectionView!.bounds.height {
            collectionView!.contentSize.height = collectionView!.bounds.height
        }
    }

}

class TableViewControllerTest: UITableViewController, BottomSheet {

    private let reuseIdentifier = "cell"
    private let countries = Locale.isoRegionCodes.prefix(40).map(Locale.current.localizedString(forRegionCode:))
    private let maxVisibleContentHeight: CGFloat = 400

    var bottomSheetDelegate: BottomSheetDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

        tableView.contentInset.top = maxVisibleContentHeight
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)!
        cell.textLabel?.text = countries[indexPath.row]
        cell.backgroundColor = .clear

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

//    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let targetOffset = targetContentOffset.pointee.y
//        let pulledUpOffset: CGFloat = 0
//        let pulledDownOffset: CGFloat = -maxVisibleContentHeight
//
//        if (pulledDownOffset...pulledUpOffset).contains(targetOffset) {
//            if velocity.y < 0 {
//                targetContentOffset.pointee.y = pulledDownOffset
//            } else {
//                targetContentOffset.pointee.y = pulledUpOffset
//            }
//        }
//    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomSheetDelegate?.bottomSheetScrolling(self, didScrollTO: tableView.contentOffset)

        if tableView.contentSize.height < tableView.bounds.height {
            tableView.contentSize.height = tableView.bounds.height
        }
    }
}
