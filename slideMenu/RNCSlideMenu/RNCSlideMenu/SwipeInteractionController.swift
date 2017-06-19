//
//  SwipeInteractionController.swift
//  GuessThePet
//
//  Created by Roman Litoshko on 5/19/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {
	
	var interactionInProgress = false
	private var shouldCompleteTransition = false
	private weak var viewController: UIViewController?
	
	
	func wireToViewController(viewController: UIViewController) {
		self.viewController = viewController
		prepareGestureRecognizerInView(view: viewController.view)
	}
	
	private func prepareGestureRecognizerInView(view: UIView) {
		let gesture =  UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:))) 
		view.addGestureRecognizer(gesture)
	}
	
	func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
		
		let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
		guard viewController != nil else {
			return
		}
		var progress = (translation.x / (viewController?.view.frame.width)!)
		progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
		
		switch gestureRecognizer.state {
	
			case .began:

					interactionInProgress = true
					if viewController != nil {
						viewController?.dismiss(animated: true, completion: nil)
					}
	
			case .changed:
					shouldCompleteTransition = progress > 0.5
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
