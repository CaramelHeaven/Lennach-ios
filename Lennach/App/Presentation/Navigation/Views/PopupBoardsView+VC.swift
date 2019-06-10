//
//  PopupView.swift
//  Lennach
//
//  Created by Sergey Fominov on 02/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

protocol ButtonsClickable {
    func btnClicked(data: Any?) // if data exists - that's mean user add some boards to own navigation
}

class PopupBoardView: NSObject, ButtonsClickable {

    private let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.alpha = 0

        return view
    }()

    //this need for correcting scroll work inside table view
    var parentController: NavigationCollectionViewController?

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
            childController.btnClickable = self

            UIView.animate(withDuration: 0.3) {
                self.blackView.alpha = 1
                self.backgroundView.alpha = 1
            }
        }
    }


    func btnClicked(data: Any?) {
        if data != nil {
            LocalRepository.instance.provideSaveBoardNavigation(array: data as! [BoardDescription]) { (result) in
                if result {
                    self.hidePopupViewController()
                }
            }
        } else {
            hidePopupViewController()
        }
    }

    private func hidePopupViewController() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                self.blackView.alpha = 0
                self.backgroundView.alpha = 0

                self.childController.dismiss(animated: true, completion: nil)
            }) { _ in
            self.parentController?.popupClosed()
            self.childController.removeFromParent()
        }
    }
}

class AllBoardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    private var baseData: [BoardDescription] = []
    private var filteringData: [BoardDescription] = []
    private var tableView: UITableView!
    private var containerHeightMax: CGFloat = 430 //FIXME: fix that
    fileprivate var btnClickable: ButtonsClickable?
    private var addedBoards: [BoardDescription] = [] //boards for added from user

    private let btnAdd: RippleButton = {
        let btn = RippleButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Добавить", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(btnAddAction), for: .touchUpInside)

        return btn
    }()

    private let btnCancel: RippleButton = {
        let btn = RippleButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Назад", for: .normal)
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

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = "Поиск тематики"
        searchBar.sizeToFit()
        // searchBar.isTranslucent = false
        //searchBar.backgroundImage = UIImage()
        searchBar.delegate = self

        return searchBar
    }()

    deinit {
        print("viewController table deINIT")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: 400)) // 568 - 36 - 36 - 30 (height menu bar) and esho - 30 for buttons

        tableView.register(ItemBoardCell.self, forCellReuseIdentifier: "MyCell")
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)

        // tableView.translatesAutoresizingMaskIntoConstraints = false
        //tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 30)

        self.view.addSubview(menuBar)
        self.view.addSubview(searchBar)

        NSLayoutConstraint.activate([
            menuBar.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            menuBar.topAnchor.constraint(equalTo: view.topAnchor),
            menuBar.heightAnchor.constraint(equalToConstant: CGFloat(30)),

            searchBar.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: -10),
            searchBar.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: menuBar.bottomAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 30)
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
            btnAdd.widthAnchor.constraint(equalToConstant: 90),
            btnAdd.heightAnchor.constraint(equalToConstant: 36)
            ])

        view.addSubview(btnCancel)
        NSLayoutConstraint.activate([
            btnCancel.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            btnCancel.trailingAnchor.constraint(equalTo: btnAdd.leadingAnchor),
            btnCancel.widthAnchor.constraint(equalToConstant: 60),
            btnCancel.heightAnchor.constraint(equalToConstant: 36)
            ])

        //request to data from network
        MainRepository.instance.provideAllBoards { (result, data) in
            if result {
                self.baseData = data as! [BoardDescription]
                self.filteringData = self.baseData

                self.tableView.reloadData()
            }
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteringData = baseData
            tableView.reloadData()
        } else {
            filteringData = baseData.filter { $0.id.contains(searchText.lowercased()) }
            tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteringData.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath) as! ItemBoardCell
        let index = indexPath.row

        cell.idLabel.text = "/" + filteringData[index].id
        cell.descriptionLabel.text = filteringData[index].name
        cell.switchView.setOn(filteringData[index].isSelected, animated: false)

        cell.switchView.addTarget(self, action: #selector(switchListener(_:)), for: UIControl.Event.valueChanged)

        return cell
    }

    @objc private func btnAddAction(_ sender: UIButton) {
        btnClickable?.btnClicked(data: addedBoards)
    }

    @objc private func btnCancelAction(_ sender: UIButton) {
        btnClickable?.btnClicked(data: nil)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isOn = !filteringData[indexPath.row].isSelected
        filteringData[indexPath.row].isSelected = isOn
        (tableView.cellForRow(at: indexPath) as! ItemBoardCell).switchView.setOn(filteringData[indexPath.row].isSelected, animated: true)

        if let index = baseData.firstIndex(where: { $0.id == filteringData[indexPath.row].id }) {
            baseData[index].isSelected = isOn
        }

        addOrRemoveObjectFromAddedBoards(flag: isOn, index: indexPath)
    }

    @objc private func switchListener(_ sender: UISwitch) {
        let index = tableView.indexPath(for: sender.superview as! ItemBoardCell)!

        if let innerIndex = baseData.firstIndex(where: { $0.id == filteringData[index.row].id }) {
            baseData[innerIndex].isSelected = sender.isOn
            filteringData[index.row].isSelected = baseData[innerIndex].isSelected
        }

        addOrRemoveObjectFromAddedBoards(flag: sender.isOn, index: index)
    }

    private func addOrRemoveObjectFromAddedBoards(flag: Bool, index: IndexPath) {
        if flag {
            addedBoards.append(filteringData[index.row])
        } else {
            addedBoards.removeAll(where: { $0.id == (baseData.filter { $0.id == filteringData[index.row].id })[0].id })
        }
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
        view.transform = CGAffineTransform(scaleX: 0.55, y: 0.55)
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
