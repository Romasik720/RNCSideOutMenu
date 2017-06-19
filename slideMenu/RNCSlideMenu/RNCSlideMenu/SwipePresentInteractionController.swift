//
//  SwipePresentInteractionController.swift
//  RNCSlideMenu
//
//  Created by Roman Litoshko on 5/24/17.
//  Copyright © 2017 Roll'n'Code. All rights reserved.
//

import UIKit

class SwipePresentInteractionController: UIPercentDrivenInteractiveTransition {
	
	var interactionInProgress = false
	private var shouldCompleteTransition = false
	private weak var viewController: UIViewController!
	private  var destinationViewController: UIViewController!
	
	
	func wireToViewController(viewController: UIViewController!, destinationViewController: UIViewController!) {
		self.viewController = viewController
		self.destinationViewController = destinationViewController
		prepareGestureRecognizerInView(view: viewController.view)
	}
	
	private func prepareGestureRecognizerInView(view: UIView) {
		let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture))
				gesture.edges = UIRectEdge.right
		view.addGestureRecognizer(gesture)
	}
	
	func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
		
			let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
			var progress = fabs(translation.x / self.destinationViewController.view.frame.size.width )
			progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
		
			switch gestureRecognizer.state {
			case .began:
				interactionInProgress = true
				viewController.present(destinationViewController, animated: true, completion: nil)
				
			case .changed:
					shouldCompleteTransition = progress > 0.5
					print(progress)
					update(progress)
				
			case .cancelled:
				interactionInProgress = false
				cancel()
				
			case .ended:
				interactionInProgress = false
				
				if !shouldCompleteTransition {
					cancel()
				} else {
					finish()
				}
			default:
				print("Unsupported")
			}
	}
	
}
