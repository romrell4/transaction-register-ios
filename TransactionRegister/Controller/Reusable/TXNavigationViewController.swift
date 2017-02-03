//
//  TXNavigationViewController.swift
//  TransactionRegister
//
//  Created by Eric Romrell on 1/20/17.
//  Copyright © 2017 Eric Romrell. All rights reserved.
//

import UIKit

class TXNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

		self.navigationBar.isTranslucent = false
		self.navigationBar.barTintColor = .darkGreen
		self.navigationBar.tintColor = .lightGreen
		self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
}
