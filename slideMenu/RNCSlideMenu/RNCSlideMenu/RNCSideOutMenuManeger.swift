//
//  RNCSideOutMenuManeger.swift
//  RNCSlideMenu
//
//  Created by Roman Litoshko on 6/15/17.
//  Copyright © 2017 Roll'n'Code. All rights reserved.
//

import UIKit

open class RNCSideOutMenuManeger {
	
	var customtransitionDelegate:RNCTransitionDelegate = RNCTransitionDelegate()
	
	var frontViewController : UIViewController
	
	var menuViewController : UIViewController
	
	public init<F:UIViewController, M: UIViewController>(withFrontViewController frontVC:F, andMenuViewController menuVC:M) where F:RNCAnimateTransitionProtocol, M:RNCAnimateTransitionProtocol{
		
		self.frontViewController = frontVC
		self.menuViewController = menuVC
		self.customtransitionDelegate.addInteractionPresentFor(presented: self.frontViewController, presenting: self.menuViewController)
		self.menuViewController.transitioningDelegate = self.customtransitionDelegate
		self.customtransitionDelegate.addIneractionDissmissFor(presenting: self.menuViewController)
		self.setNavigationBarButton()
		
	}
	
	func setNavigationBarButton() {
		
		let fvc = self.frontViewController as? RNCAnimateTransitionProtocol
		let icon = fvc?.imageForNavigationBarButton!()
		let iconSize = CGRect(origin: CGPoint.zero, size: (icon?.size)!)
		let iconButton = UIButton(frame: iconSize)
		iconButton.setBackgroundImage(icon, for: .normal)
		iconButton.addTarget(self, action: #selector(itemPressed) , for: .touchUpInside)
		self.frontViewController.navigationItem.rightBarButtonItem?.customView = iconButton
	}
	
	
	@objc func itemPressed() {
			self.customtransitionDelegate.addIneractionDissmissFor(presenting: self.menuViewController)
			self.frontViewController.navigationController?.present(self.menuViewController, animated: true, completion: nil)
	}
	
}
