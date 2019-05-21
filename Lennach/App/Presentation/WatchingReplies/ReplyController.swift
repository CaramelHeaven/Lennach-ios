//
//  ReplyController.swift
//  Lennach
//
//  Created by Sergey Fominov on 21/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

class ReplyController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var commentsData = [Comment]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()

        backBtn.addTarget(self, action: #selector(actionButtonBack), for: .touchUpInside)
        closeBtn.addTarget(self, action: #selector(actionButtonClose), for: .touchUpInside)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func updateData(data: [Comment]) {
        self.commentsData = data
    }
}

//MARK: buttons action
extension ReplyController {
    @objc private func actionButtonBack() {

    }

    @objc private func actionButtonClose() {

    }
}
