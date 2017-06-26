//
//  FirstViewController.swift
//  GuessThePet
//
//  Created by Roman Litoshko on 5/9/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, RNCAnimateTransitionProtocol {
	
	var sideOutMenuManager:RNCSideOutMenuManeger!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		if let sVC = SecondViewController.getViewController() {
			self.sideOutMenuManager = RNCSideOutMenuManeger(withFrontViewController:self, andMenuViewController:sVC )
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	//MARK: - RNCAnimateTransitionProtocol
	
	func viewForAnimate() -> UIView {
		let view = self.navigationItem.rightBarButtonItem?.customView
		return view ?? UIView()
	}
	
	func imageForNavigationBarButton() -> UIImage {
		let image = UIImage.init(named: "jobss")
		return image!
	}
	
}

