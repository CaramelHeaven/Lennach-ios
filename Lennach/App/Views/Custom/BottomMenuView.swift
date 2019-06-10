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
    let data = ["IconNavigation", "IconHome", "IconFavourite"]

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
        
        layer.shadowOffset = CGSize(width: 0, height: -1)
        layer.shadowRadius = 1
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.lightGray.cgColor
        
        collectionView.backgroundColor = UIColor.black
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BottomItemCell
        cell.imageView.image = UIImage(named: data[indexPath.row])

        return cell

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 3, height: frame.height)
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

    let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
    
    override var isHighlighted: Bool {
        didSet {
            print("IS HIGHLIGHTED: \(isHighlighted)")
            self.backgroundColor = isHighlighted ? .lightGray : .white
        }
    }

    func setupViews() {
        addSubview(imageView)

        imageView.heightAnchor.constraint(equalToConstant: CGFloat(24)).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: CGFloat(24)).isActive = true
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
