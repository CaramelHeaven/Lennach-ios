//
//  ImageViewerPresentationTransition.swift
//  Lennach
//
//  Created by Sergey Fominov on 24/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

final class ImageViewerPresentationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private let fromImageView: UIImageView

    init(fromImageView: UIImageView) {
        self.fromImageView = fromImageView
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let fromParentView = fromImageView.superview!
        // (8.0, 228.0, 70.0, 70.0)
        let imageView = AnimatableImageView()
        imageView.image = fromImageView.image
        imageView.frame = fromParentView.convert(fromImageView.frame, to: nil)
        print("image frame rect: \(imageView.frame)")
        imageView.contentMode = fromImageView.contentMode

        let fadeView = UIView(frame: containerView.bounds)
        fadeView.backgroundColor = .black
        fadeView.alpha = 0.0

        toView.frame = containerView.bounds
        toView.isHidden = true
        fromImageView.isHidden = true

        containerView.addSubview(toView)
        containerView.addSubview(fadeView)
        containerView.addSubview(imageView)


        //containerView.frame.minY += 20
        //containerView.frame = CGRect(x: 0, y: 4, width: containerView.frame.width, height: containerView.frame.height)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                imageView.contentMode = .scaleAspectFit
                imageView.frame = containerView.frame
                fadeView.alpha = 1.0
            }) { _ in
            toView.isHidden = false
            fadeView.removeFromSuperview()
            imageView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
