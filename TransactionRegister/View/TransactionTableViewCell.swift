//
//  TransactionTableViewCell.swift
//  TransactionRegister
//
//  Created by Eric Romrell on 1/20/17.
//  Copyright © 2017 Eric Romrell. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
	private static let dateFormat: DateFormatter = {
		let format = DateFormatter()
		format.dateFormat = "MMM dd, yyyy"
		return format
	}()

	@IBOutlet weak private var businessLabel: UILabel!
	@IBOutlet weak private var dateLabel: UILabel!
	@IBOutlet weak private var amountLabel: UILabel!
	@IBOutlet weak private var categoryLabel: UILabel!
	
	var transaction: Transaction? {
		didSet {
			guard let transaction = transaction else {
				return
			}
			
			//TODO: Fix formatting to enable amount to fit more
			
			self.businessLabel.text = transaction.business
			self.dateLabel.text = TransactionTableViewCell.dateFormat.string(from: transaction.purchaseDate!)
			self.amountLabel.text = transaction.amount?.formattedValue()
			self.categoryLabel.text = transaction.categoryName
			
			if transaction.desc != nil && transaction.desc!.hasPrefix("?") {
				self.backgroundColor = UIColor.warningColor
			} else {
				self.backgroundColor = nil
			}
		}
	}
}
