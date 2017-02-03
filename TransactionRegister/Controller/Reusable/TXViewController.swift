//
//  TXViewController.swift
//  TransactionRegister
//
//  Created by Eric Romrell on 1/20/17.
//  Copyright © 2017 Eric Romrell. All rights reserved.
//

import UIKit

class TXViewController: UIViewController {
	func showError(error: TXError) {
		showError(error: error, callback:{ (_) in
			_ = self.navigationController?.popViewController(animated: true)
		})
	}
	
	func showError(error: TXError, callback:@escaping (UIAlertAction) -> Void) {
		let alert = UIAlertController(title: "Error", message: error.readableMessage, preferredStyle: .alert)
		
		
		alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: callback))
		self.present(alert, animated: true, completion: nil)
	}
}
