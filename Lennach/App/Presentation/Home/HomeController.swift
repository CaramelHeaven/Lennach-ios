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

    private var draggingStateX: CGFloat = 0
    private var initialThreadX: CGFloat = 0, initialBoardX: CGFloat = 0

    //from board controlle
    private var firstValue = false
    private var initialX: CGFloat = 0, lastX: CGFloat = 0
    private var controllingStateX: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        savedPositionsX()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepeare")
        if let threadController = segue.destination as? ThreadController {
            threadController.threadDelegate = self
        }

        print("destination: \(segue.destination)")
    }

    func savedPositionsX() {
        initialBoardX = boardContainer.frame.origin.x
        initialThreadX = threadContainer.frame.origin.x
    }
}

extension HomeController: ThreadDelegate {
    func dragState(flag: Bool, lastValueX: CGFloat) {
        print("Drag ended, draggin: \(draggingStateX), lastValue: \(lastValueX)")
        print("frame board: \(boardContainer.frame.origin.x), thread: \(threadContainer.frame.origin.x)")
        savedPositionsX()

        // if true - user opened thread, else - not
        if draggingStateX < lastValueX || draggingStateX == lastValueX {
            UIView.animate(withDuration: 0.5) {
                self.boardContainer.frame.origin.x = -315
                self.threadContainer.frame.origin.x = 0
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.boardContainer.frame.origin.x = 0
                self.threadContainer.frame.origin.x = 260
            }
        }
        print("AFTER ANIMATION frame board: \(boardContainer.frame.origin.x), thread: \(threadContainer.frame.origin.x)")
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
