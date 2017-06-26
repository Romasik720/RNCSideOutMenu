//
//  SecondViewController.swift
//  GuessThePet
//
//  Created by Roman Litoshko on 5/9/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, RNCAnimateTransitionProtocol {
	
	@IBOutlet var avaView:UIButton!

//	var customtransitionDelegate:RNCTransitionDelegate = RNCTransitionDelegate()
	
	static func getViewController () -> SecondViewController? {
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		if let vc = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController {
			return vc
		}
		return nil
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
	
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction fileprivate func dismissPressed(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}

	
    // MARK: - RNCAnimateTransitionProtocol
	
	func viewForAnimate() -> UIView {
		return self.avaView
	}



}
