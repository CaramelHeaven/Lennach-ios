//
//  ImageController.swift
//  Lennach
//
//  Created by Sergey Fominov on 24/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import UIKit

import AVFoundation
import UIKit

class ImageController: UIViewController {

    @IBOutlet var imageThread: UIImageView!
    @IBOutlet var scrollView: UIScrollView!

    private var transitionHandler: ImageViewerTransitioningHandler?
    private let configuration: ImageViewerConfiguration?

    var urlThumbnail = ""

    public init(configuration: ImageViewerConfiguration?) {
        self.configuration = configuration
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))

        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        modalPresentationCapturesStatusBarAppearance = true
    }
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        imageThread.image = configuration?.imageView?.image ?? configuration?.image
        
        print("image thread frame: \(imageThread.frame)")

        Utilities.loadAsynsImage(image: imageThread, url: Constants.baseUrl + urlThumbnail, fade: false)

        setupScrollView()
        setupGestureRecognizers()
        setupTransitions()
    }
}

extension ImageController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageThread
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard let image = imageThread.image else { return }
        let imageViewSize = Utilities.aspectFitRect(forSize: image.size, insideRect: imageThread.frame)
        let verticalInsets = -(scrollView.contentSize.height - max(imageViewSize.height, scrollView.bounds.height)) / 2
        let horizontalInsets = -(scrollView.contentSize.width - max(imageViewSize.width, scrollView.bounds.width)) / 2
        scrollView.contentInset = UIEdgeInsets(top: verticalInsets, left: horizontalInsets, bottom: verticalInsets, right: horizontalInsets)
    }
}

extension ImageController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return scrollView.zoomScale == scrollView.minimumZoomScale
    }
}

private extension ImageController {
    func setupScrollView() {
        scrollView.decelerationRate = UIScrollView.DecelerationRate.fast
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = true
    }

    func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.numberOfTapsRequired = 2
        tapGestureRecognizer.addTarget(self, action: #selector(imageViewDoubleTapped))
        imageThread.addGestureRecognizer(tapGestureRecognizer)

        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addTarget(self, action: #selector(imageViewPanned(_:)))
        panGestureRecognizer.delegate = self
        imageThread.addGestureRecognizer(panGestureRecognizer)
    }

    func setupTransitions() {
        guard let imageView = configuration?.imageView else { return }

        transitionHandler = ImageViewerTransitioningHandler(fromImageView: imageView, toImageView: self.imageThread)
        transitioningDelegate = transitionHandler
    }

    @IBAction func closeButtonPressed() {
        dismiss(animated: true)
    }

    @objc func imageViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
            var zoomRect = CGRect.zero
            zoomRect.size.height = imageThread.frame.size.height / scale
            zoomRect.size.width = imageThread.frame.size.width / scale

            let newCenter = scrollView.convert(center, from: imageThread)
            zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
            zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)

            return zoomRect
        }

        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        }
    }

    @objc func imageViewPanned(_ recognizer: UIPanGestureRecognizer) {
        guard transitionHandler != nil else { return }

        let translation = recognizer.translation(in: imageThread)
        let velocity = recognizer.velocity(in: imageThread)

        switch recognizer.state {
        case .began:
            transitionHandler?.dismissInteractively = true
            dismiss(animated: true)
        case .changed:
            let percentage = abs(translation.y) / imageThread.bounds.height
            transitionHandler?.dismissalInteractor.update(percentage: percentage)
            transitionHandler?.dismissalInteractor.update(transform: CGAffineTransform(translationX: translation.x, y: translation.y))
        case .ended, .cancelled:
            transitionHandler?.dismissInteractively = false
            let percentage = abs(translation.y + velocity.y) / imageThread.bounds.height
            if percentage > 0.25 {
                transitionHandler?.dismissalInteractor.finish()
            } else {
                transitionHandler?.dismissalInteractor.cancel()
            }
        default: break
        }
    }
}


