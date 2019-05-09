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
    private var homeVC: HomeController?
    private var bottomSheetNavigation: NavigationContainer?
    // private let navigationBoard = NavigationExpandView()

    //FIXME: find answer in this bug
//    public override var prefersStatusBarHidden: Bool {
//        return true
//    }

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let homeVC as HomeController:
            self.homeVC = homeVC
            break
        case let favouriteVC as FavouriteController:
            print("favouriteVC")
            break
        default:
            break
        }
    }
}

extension BaseController: BottomListenable {
    func selectedItem(_ position: Int) {
        switch position {
        case 0:
            bottomSheetNavigation = NavigationContainer()
            bottomSheetNavigation!.tableController!.didMove(toParent: self)
            bottomSheetNavigation!.tableController!.bottomSheetDelegate = self
            bottomSheetNavigation?.mainUIBottomSheet!.navigationClosed = self

            bottomSheetNavigation!.showLayout()
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
    }
}

extension BaseController: BottomSheetDelegate {
    func bottomSheetScrolling(_ bottomSheet: BottomSheet, didScrollTO contentOffset: CGPoint) {
        print("contentOffset: \(contentOffset.y)")
        bottomSheetNavigation?.mainUIBottomSheet?.topDistance = max(30, -contentOffset.y)
    }
}

extension BaseController: NavigationContainerClosable {
    func closed(boardName: String?) {
        if let board = boardName { homeVC?.loadNewPageOfBoard(boardName: board) }
    }
}
