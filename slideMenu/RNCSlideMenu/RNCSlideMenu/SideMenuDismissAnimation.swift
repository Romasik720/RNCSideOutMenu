//
//  SideMenuDismissAnimation.swift
//  GuessThePet
//
//  Created by Roman Litoshko on 5/9/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class SideMenuDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.8
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		
		guard let fromViewController = transitionContext.viewController(forKey: .from), let toViewController = transitionContext.viewController(forKey: .to) else {
			return
		}
		let containerView = transitionContext.containerView

		// set frame for moving menu
		let initialFrameForFromView = transitionContext.initialFrame(for: fromViewController)
		var finalRectForFromView = initialFrameForFromView
		finalRectForFromView.origin.x += finalRectForFromView.size.width
		
		let finalFrameForToView = CGRect(x: 0, y: 0, width: toViewController.view.frame.width, height: toViewController.view.frame.height)
		
		containerView.addSubview(fromViewController.view)
		containerView.addSubview(toViewController.view)

		fromViewController.view.frame = initialFrameForFromView
		toViewController.view.frame = toViewController.view.frame

		// set frames for animating view
		
		let nav = toViewController as? UINavigationController
		guard let tvc = nav?.topViewController as? RNCAnimateTransitionProtocol, let fvc = fromViewController as? RNCAnimateTransitionProtocol else {
			return
		}
		
		let fromView = fvc.viewForAnimate()
		let toView = tvc.viewForAnimate()
		
		
		let fromOnScreen = fromView.convert((fromView.bounds), to: containerView)
		let toOnScreen = toView.convert((toView.bounds), to: containerView)
		
		let snapshotView = fromView.snapshotView(afterScreenUpdates: false)
		snapshotView?.frame.origin = CGPoint.init(x: fromOnScreen.origin.x, y: fromOnScreen.origin.y)
		let snapshotFrameAfterAnimation = CGRect.init(x: toOnScreen.origin.x+fromViewController.view.frame.size.width, y: toOnScreen.origin.y, width: toOnScreen.size.width, height: toOnScreen.size.height)

		UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: .allowUserInteraction, animations: { 
			UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/2, animations: { 
				containerView.addSubview(snapshotView!)
				fromView.isHidden = true
				snapshotView?.transform = UIView.transform(from: fromOnScreen, to: toOnScreen)
			})
			
			UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2, animations: {

				fromViewController.view.frame = finalRectForFromView
				toViewController.view.frame = finalFrameForToView
				snapshotView?.transform = UIView.transform(from: fromOnScreen, to: snapshotFrameAfterAnimation )
			})
			
		}) { (success) in
			
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
			UIApplication.shared.keyWindow?.addSubview(toViewController.view)
			if !transitionContext.transitionWasCancelled {
				toView.isHidden = false
			}
			fromView.isHidden = false
			snapshotView?.removeFromSuperview()
		}
	}
	
}
