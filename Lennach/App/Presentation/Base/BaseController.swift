//
//  BaseController.swift
//  Lennach
//
//  Created by Sergey Fominov on 17/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

class BaesController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func tabBar(_ tabBar: UITabBar, willEndCustomizing items: [UITabBarItem], changed: Bool) {
        print("tabBar: \(selectedIndex)")
        
    }

}
