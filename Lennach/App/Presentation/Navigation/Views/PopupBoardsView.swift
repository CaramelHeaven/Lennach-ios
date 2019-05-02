//
//  PopupView.swift
//  Lennach
//
//  Created by Sergey Fominov on 02/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

class PopupBoardView: NSObject {

    private let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.alpha = 0

        return view
    }()

    //this need for correcting scroll work inside table view
    var parentController: NavigationCollectionView?

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true

        return view
    }()

    private let menuBar: UIView = {
        let menu = UIView()
        menu.translatesAutoresizingMaskIntoConstraints = false
        //menu.layer.cornerRadius = 8
        menu.backgroundColor = .red

        return menu
    }()

    private let titleInMenu: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0

        return label
    }()

    private let childController = AllBoardsViewController()

    override init() {
        super.init()
    }

    public func showPopup() {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(blackView)
            blackView.frame = window.frame

            window.addSubview(backgroundView)
            NSLayoutConstraint.activate([
                backgroundView.leadingAnchor.constraint(equalTo: blackView.leadingAnchor, constant: 26),
                backgroundView.trailingAnchor.constraint(equalTo: blackView.trailingAnchor, constant: -26),
                backgroundView.topAnchor.constraint(equalTo: blackView.topAnchor, constant: 36),
                backgroundView.bottomAnchor.constraint(equalTo: blackView.bottomAnchor, constant: -36)
                ])

            backgroundView.addSubview(childController.view)
            print("child controller frame: \(childController.view.bounds)")
            parentController?.addChild(childController)

            //tableView.frame = CGRect(x: backgroundView.frame.minX, y: backgroundView.frame.minY, width: backgroundView.frame.width, height: backgroundView.frame.height)
            //print("tableView frame: \(tableView.frame), back: \(backgroundView.frame)")
            UIView.animate(withDuration: 0.5) {
                self.blackView.alpha = 1
                self.backgroundView.alpha = 1
                //self.backgroundView.layer.cornerRadius = 8
            }
        }
    }

}

class ItemBoardCell: UICollectionViewCell {

    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = .green

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
        addSubview(view)

        view.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - 4)
    }
}

class AllBoardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let myArray: NSArray = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17"]
    private var tableView: UITableView!

    private let btnAdd: UIButton = {
        let btn = UIButton()

        return btn
    }()

    private let btnCancel: UIButton = {
        let btn = UIButton()

        return btn
    }()

    private let menuBar: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let titleMenuLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Boards"
        // label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    deinit {
        print("viewController table deINIT")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //view.addSubview(titleMenuLabel)


        //  titleMenuLabel.addConstraint(NSLayoutConstraint(item: titleMenuLabel, attribute: .centerY, relatedBy: .equal, toItem: menuBar, attribute: .centerY, multiplier: 1, constant: 0))
        //  titleMenuLabel.addConstraint(NSLayoutConstraint(item: titleMenuLabel, attribute: .centerX, relatedBy: .equal, toItem: menuBar, attribute: .centerX, multiplier: 1, constant: 0))

        //-100 it's hardcode)
        tableView = UITableView(frame: CGRect(x: 0, y: 30, width: self.view.frame.width, height: self.view.frame.height - 100))

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)

        self.view.addSubview(menuBar)
        NSLayoutConstraint.activate([
            menuBar.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            menuBar.topAnchor.constraint(equalTo: view.topAnchor),
            menuBar.heightAnchor.constraint(equalToConstant: CGFloat(30))
            ])

        view.addSubview(titleMenuLabel)
        NSLayoutConstraint.activate([
            titleMenuLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor, constant: -26),
            titleMenuLabel.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor)
            ])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(myArray[indexPath.row])")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(myArray[indexPath.row])"
        return cell
    }
}
