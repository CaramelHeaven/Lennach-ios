//
//  BottomSheetBackgroundView.swift
//  Lennach
//
//  Created by Sergey Fominov on 01/05/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

//this view coloring background table view to white
class BottomSheetBackgroundView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        layer.cornerRadius = 12
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        layer.bounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width + 1 * 2, height: bounds.size.height))
    }
}
