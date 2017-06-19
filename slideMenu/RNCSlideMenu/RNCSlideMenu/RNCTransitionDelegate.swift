//
//  RNCTransitionDelegate.swift
//  RNCSlideMenu
//
//  Created by Roman Litoshko on 5/25/17.
//  Copyright © 2017 Roll'n'Code. All rights reserved.
//

import UIKit

private let sideMenuPresentAnimation = SideMenuPresentAnimation()
private let sideMenuDismissAnimation = SideMenuDismissAnimation()
private let swipeInteractionController = SwipeInteractionController()
private let swipePresentInteractionController = SwipePresentInteractionController()

class RNCTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

	func addInteractionPresentFor(presented:UIViewController, presenting:UIViewController) {
		presenting.transitioningDelegate = self
		swipePresentInteractionController.wireToViewController(viewController: presented, destinationViewController: presenting)
	}
	
	func addIneractionDissmissFor(presenting:UIViewController) {
		swipeInteractionController.wireToViewController(viewController: presenting)
	}

	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return sideMenuPresentAnimation
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return sideMenuDismissAnimation
	}
	
	func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		
  return swipeInteractionController.interactionInProgress ? swipeInteractionController : nil
	}
	
	func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		return swipePresentInteractionController.interactionInProgress ? swipePresentInteractionController : nil
	}
	
	

}
