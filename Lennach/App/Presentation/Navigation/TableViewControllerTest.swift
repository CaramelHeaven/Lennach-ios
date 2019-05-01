//
//  TableViewControllerTest.swift
//  Lennach
//
//  Created by Sergey Fominov on 01/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

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
