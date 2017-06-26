//
//  SideMenuPresentAnimation.swift
//  GuessThePet
//
//  Created by Roman Litoshko on 5/9/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

@objc public protocol RNCAnimateTransitionProtocol  {
	func viewForAnimate() -> UIView
	@objc optional
	func imageForNavigationBarButton() -> UIImage
}

class SideMenuPresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {

	let animateDuration = 0.8

	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return animateDuration
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		
		guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else {
			return
		}

		let containerView = transitionContext.containerView

		let rect = transitionContext.finalFrame(for: toVC)
	
		// set frame for moving menu
		let initialFromViewFrame = transitionContext.initialFrame(for: fromVC )
		var finalFromViewFrame = initialFromViewFrame
		finalFromViewFrame.origin.x -= rect.width/1.5
		
		let finalToViewFrame = CGRect(x: rect.width - rect.width/1.5, y: 0, width: rect.width/1.5, height: rect.height)
		var initialToViewFrame = finalToViewFrame

		initialToViewFrame.origin.x += finalToViewFrame.size.width;
		
		containerView.addSubview(toVC.view)
		containerView.addSubview(fromVC.view)

		fromVC.view.frame = initialFromViewFrame
		toVC.view.frame = initialToViewFrame
		
		//------------------------------
		// set frames for animating view
		let nav = fromVC as? UINavigationController
		guard let fvc = nav?.topViewController as? RNCAnimateTransitionProtocol, let tvc = toVC as? RNCAnimateTransitionProtocol else {
			return
		}
		
		let fromView = fvc.viewForAnimate()
		let toView = tvc.viewForAnimate()
		
		let fromOnScreen = fromView.convert((fromView.bounds), to: containerView)
		let toOnScreen = toView.convert((toView.bounds), to: containerView)
		
		let snapshotView = fromView.snapshotView(afterScreenUpdates: false)
		snapshotView?.frame.origin = CGPoint.init(x: fromOnScreen.origin.x, y: fromOnScreen.origin.y)
		
		// Making frame for snapshot in animation
		let snapshotFrameBeforeAnimation = CGRect.init(x: fromOnScreen.origin.x-toVC.view.frame.size.width, y: fromOnScreen.origin.y, width: fromOnScreen.size.width, height: fromOnScreen.size.height)
		
		let snapshotFrameAfterAnimation = CGRect.init(x: toOnScreen.origin.x-toVC.view.frame.size.width, y: toOnScreen.origin.y, width: toOnScreen.size.width, height: toOnScreen.size.height)
		//
		toView.isHidden = true
		
		UIView.animateKeyframes(withDuration: animateDuration, delay: 0.0, options: .allowUserInteraction, animations: {
			UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/2, animations: {
				fromView.isHidden = true
				snapshotView?.transform = UIView.transform(from: fromOnScreen, to: snapshotFrameBeforeAnimation)
				fromVC.view.frame = finalFromViewFrame
				toVC.view.frame = finalToViewFrame

							})
			UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: self.animateDuration/2, animations: {
				
				containerView.addSubview(snapshotView!)
				snapshotView?.transform = UIView.transform(from: fromOnScreen, to: snapshotFrameAfterAnimation)
			})
		}, completion:{ (success) in
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
			UIApplication.shared.keyWindow?.addSubview(fromVC.view)
			snapshotView?.removeFromSuperview()
			if transitionContext.transitionWasCancelled {
				fromView.isHidden = false
			}
			toView.isHidden = false
		})
	}
	
}

extension UIView {
	class func transform(from sourceRect: CGRect, to finalRect: CGRect) -> CGAffineTransform {
		var transform = CGAffineTransform.identity
		transform = transform.translatedBy(x: -(sourceRect.midX - finalRect.midX), y: -(sourceRect.midY - finalRect.midY))
		transform = transform.scaledBy(x: finalRect.size.width / sourceRect.size.width, y: finalRect.size.height / sourceRect.size.height)
		return transform
	}
}
