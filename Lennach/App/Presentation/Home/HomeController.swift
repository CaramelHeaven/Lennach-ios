//
//  HomeController.swift
//  Lennach
//
//  Created by Sergey Fominov on 13/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    @IBOutlet weak var boardContainer: UIView!
    @IBOutlet weak var threadContainer: UIView!

    private weak var threadController: ThreadController?
    private weak var boardController: BoardController?

    private var draggingStateX: CGFloat = 0
    private var initialThreadX: CGFloat = 0, initialBoardX: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        savedPositionsX()

        //set shadow on thread view
        threadContainer.layer.shadowOffset = CGSize(width: -2, height: 0)
        threadContainer.layer.shadowRadius = 1
        threadContainer.layer.shadowOpacity = 1
        threadContainer.layer.shadowColor = UIColor.lightGray.cgColor
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let threadVC = segue.destination as? ThreadController {
            threadVC.threadDelegate = self

            self.threadController = threadVC
        }

        if let boardController = segue.destination as? BoardController {
            boardController.boardDelegatable = self

            self.boardController = boardController
        }

        print("destination: \(segue.destination)")
    }

    func savedPositionsX() {
        initialBoardX = boardContainer.frame.origin.x
        initialThreadX = threadContainer.frame.origin.x
    }

    func loadNewPageOfBoard(boardName: String) {
        boardController?.startedNewBoard(boardName: boardName)
    }
}

//Swap from board to thread and send callback for load data from network
extension HomeController: BoardTapDelegatable {
    func itemTapped(numThread: String) {

        UIView.animate(withDuration: 0.3) {
            self.boardContainer.frame.origin.x = -315
            self.threadContainer.frame.origin.x = 0

            self.threadController?.callbackFromTapAction(numThread: numThread)
        }
    }
}

extension HomeController: ThreadDelegate {
    func dragState(flag: Bool, lastValueX: CGFloat) {
        savedPositionsX()

        // if true - user opened thread, else - not
        if draggingStateX < lastValueX || draggingStateX == lastValueX {
            UIView.animate(withDuration: 0.3) {
                self.boardContainer.frame.origin.x = -315
                self.threadContainer.frame.origin.x = 0

                self.threadController?.handlerDirectionGestureToThread = false
                self.threadController?.backgroundThreadState(isClosingThread: false, isNewThread: self.boardController!.isOpeningNewThread)
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.boardContainer.frame.origin.x = 0
                self.threadContainer.frame.origin.x = 280

                self.threadController?.handlerDirectionGestureToThread = true
                self.threadController?.backgroundThreadState(isClosingThread: true)
            }
        }
    }

    func translateXState(threadX: CGFloat) {
        draggingStateX = threadX
        //update threadContainer
        threadContainer.frame.origin.x = threadContainer.frame.origin.x + threadX
        boardContainer.frame.origin.x = boardContainer.frame.origin.x + threadX

//        print("x: \(threadX)")
//
//        if !firstValue {
//            initialX = threadX
//            firstValue = !firstValue
//        }
//        lastX = threadX
//
//        if threadX < initialX {
//            let stateX = -1 * (initialX - lastX)
//            print("stateX: \(stateX), boardContainer: \(boardContainer.frame.origin.x)")
//            boardContainer.frame.origin.x = boardContainer.frame.origin.x + threadX
//        }
    }
}
