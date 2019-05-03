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
        view.layer.cornerRadius = 10
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
            parentController?.addChild(childController)

            UIView.animate(withDuration: 0.5) {
                self.blackView.alpha = 1
                self.backgroundView.alpha = 1

                print("background FRAME: \(self.backgroundView.frame)")
                //self.backgroundView.layer.cornerRadius = 8
            }

            UIView.animate(withDuration: 5, delay: 5, options: [], animations: {
                    self.blackView.alpha = 0
                    self.backgroundView.alpha = 0

                    self.childController.dismiss(animated: true, completion: nil)
                }) { _ in
                self.childController.removeFromParent()
            }
            //childController.dismiss(animated: true, completion: false)
        }
    }
}

class AllBoardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let myArray: NSArray = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17"]
    private var tableView: UITableView!
    private var containerHeightMax: CGFloat = 430 //FIXME: fix that

    private let btnAdd: RippleButton = {
        let btn = RippleButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Add", for: .normal)
        //btn.setTitle("fuck", for: .highlighted)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(btnAddAction), for: .touchUpInside)

        return btn
    }()

    private let btnCancel: RippleButton = {
        let btn = RippleButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(btnCancelAction), for: .touchUpInside)

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

        print("frame: \(view.frame)")
        tableView = UITableView(frame: CGRect(x: 0, y: 30, width: self.view.frame.width, height: 430)) // 568 - 36 - 36 - 30 (height menu bar) and esho - 30 for buttons

        tableView.register(ItemBoardCell.self, forCellReuseIdentifier: "MyCell")
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        // tableView.translatesAutoresizingMaskIntoConstraints = false
        //tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 30)

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

        //init buttons
        view.addSubview(btnAdd)
        NSLayoutConstraint.activate([
            btnAdd.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            btnAdd.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -52),
            btnAdd.widthAnchor.constraint(equalToConstant: 60),
            btnAdd.heightAnchor.constraint(equalToConstant: 36)
            ])

        view.addSubview(btnCancel)
        NSLayoutConstraint.activate([
            btnCancel.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            btnCancel.trailingAnchor.constraint(equalTo: btnAdd.leadingAnchor),
            btnCancel.widthAnchor.constraint(equalToConstant: 60),
            btnCancel.heightAnchor.constraint(equalToConstant: 36)
            ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath) as! ItemBoardCell
        //cell.textLabel!.text = "\(myArray[indexPath.row])"

        return cell
    }

    @objc private func btnAddAction(_ sender: UIButton) {
        print("action up")
    }

    @objc private func btnCancelAction(_ sender: UIButton) {

        print("cancel")
    }
}

//MARK: Item board cell for table view controller
class ItemBoardCell: UITableViewCell {

    fileprivate let idLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = label.font.withSize(14)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1

        label.text = "/an/ - Animals & Nature"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    fileprivate let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = label.font.withSize(11)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2

        label.text = "an - is 4chans imageboard for posting pictures of animals, pets, and nature"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    fileprivate let switchView: UISwitch = {
        let view = UISwitch()
        view.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(switchView)
        print("frame: \(frame)")
        NSLayoutConstraint.activate([
            switchView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            switchView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            switchView.widthAnchor.constraint(equalToConstant: 50)
            ])

        addSubview(idLabel)
        addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            //TODO: fix this -60
            idLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            idLabel.leadingAnchor.constraint(equalTo: switchView.trailingAnchor),
            idLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -52),

            descriptionLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: switchView.trailingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -52),
            ])
    }
}
