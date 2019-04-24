//
//  BaseController.swift
//  Lennach
//
//  Created by Sergey Fominov on 17/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

class BaseController: UIViewController {

    @IBOutlet weak var homeContainer: UIView!
    @IBOutlet weak var favouriteContainer: UIView!
    @IBOutlet weak var settingsContainer: UIView!

    private var arrayContainers: [UIView]?

    let bottomMenu: BottomMenuView = {
        let menu = BottomMenuView()
        menu.translatesAutoresizingMaskIntoConstraints = false

        return menu
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        arrayContainers = [homeContainer, favouriteContainer, settingsContainer]

        bottomMenu.bottomListenable = self

        view.addSubview(bottomMenu)

        bottomMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomMenu.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomMenu.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        bottomMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    func manageStateContainer(currentShowContainer container: UIView) {
        container.isHidden = false
        for item in arrayContainers! {
            if item != container {
                item.isHidden = true
            }
        }
    }
}

extension BaseController: BottomListenable {
    func selectedItem(_ position: Int) {
        switch position {
        case 0:
            manageStateContainer(currentShowContainer: settingsContainer)
            break
        case 1:
            manageStateContainer(currentShowContainer: homeContainer)
            break
        case 2:
            manageStateContainer(currentShowContainer: favouriteContainer)
            break
        default:
            print("error")
        }
        print("item: \(position)")
    }
}