//
//  BaseController.swift
//  Lennach
//
//  Created by Sergey Fominov on 17/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

class BaseController: UIViewController {
    
    let bottomMenu: BottomMenuView = {
        let menu = BottomMenuView()
        menu.translatesAutoresizingMaskIntoConstraints = false
        
        return menu
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bottomMenu)
        
        bottomMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomMenu.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomMenu.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        bottomMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
