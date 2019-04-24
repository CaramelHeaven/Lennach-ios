//
//  ImageViewerDismissallInteractor.swift
//  Lennach
//
//  Created by Sergey Fominov on 24/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

final class ImageViewerDismissalInteractor: NSObject, UIViewControllerInteractiveTransitioning {
    fileprivate let transition: ImageViewerDismissalTransition
    
    init(transition: ImageViewerDismissalTransition) {
        self.transition = transition
        super.init()
    }
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        transition.start(transitionContext)
    }
    
    func update(transform: CGAffineTransform) {
        transition.update(transform: transform)
    }
    
    func update(percentage: CGFloat) {
        transition.update(percentage: percentage)
    }
    
    func cancel() {
        transition.cancel()
    }
    
    func finish() {
        transition.finish()
    }
}
