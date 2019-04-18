//
//  BottomNavigationView.swift
//  Lennach
//
//  Created by Sergey Fominov on 18/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

protocol BottomListenable {
    func selectedItem(_ position: Int)
}

class BottomMenuView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    let cellId = "cellId"
    let data = ["1", "2", "3", "4", "5"]

    var bottomListenable: BottomListenable?

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)

        cv.backgroundColor = UIColor.white
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self

        return cv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(collectionView)

        collectionView.register(BottomItemCell.self, forCellWithReuseIdentifier: cellId)

        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        let selectedItem = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedItem, animated: false, scrollPosition: [])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BottomItemCell

        cell.label.text = data[indexPath.row]

        return cell

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("frame width: \(frame.width) cal: \(frame.width / 5), heiglt: \(frame.height)")
        return CGSize(width: frame.width / 5, height: frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        bottomListenable?.selectedItem(indexPath.row)
    }
}

@IBDesignable
class BottomItemCell: UICollectionViewCell {

    let view: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.red
        v.translatesAutoresizingMaskIntoConstraints = false

        return v
    }()

    let label: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false

        return l
    }()

    func setupViews() {
        addSubview(label)
        addSubview(view)

        //view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true

        //view.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 10).isActive = true
        //view.trailingAnchor.constrain
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        // view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        //view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true

        view.heightAnchor.constraint(equalToConstant: 4).isActive = true
        view.widthAnchor.constraint(equalToConstant: 10).isActive = true

        label.heightAnchor.constraint(equalToConstant: CGFloat(14)).isActive = true
        label.widthAnchor.constraint(equalToConstant: CGFloat(14)).isActive = true
        addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            //print("kek")
            //label.tintColor = isHighlighted ? UIColor.white : UIColor.init(red: 91 / 255, green: 14 / 255, blue: 13 / 255, alpha: 1)
            //view.backgroundColor = isHighlighted ? UIColor.red : UIColor.white

        }
    }

    override var isSelected: Bool {
        didSet {
            //label.tintColor = isHighlighted ? UIColor.white : UIColor.init(red: 91 / 255, green: 14 / 255, blue: 13 / 255, alpha: 1)
            //view.backgroundColor = isSelected ? UIColor.red : UIColor.white
        }
    }


}
