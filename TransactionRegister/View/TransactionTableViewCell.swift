//
//  TransactionTableViewCell.swift
//  TransactionRegister
//
//  Created by Eric Romrell on 1/20/17.
//  Copyright © 2017 Eric Romrell. All rights reserved.
//

import UIKit

private let DATE_FORMAT = DateFormatter(format: "MMM dd, yyyy")

class TransactionTableViewCell: UITableViewCell {
	@IBOutlet private weak var businessLabel: UILabel!
	@IBOutlet private weak var dateLabel: UILabel!
	@IBOutlet private weak var amountLabel: UILabel!
	@IBOutlet private weak var categoryLabel: UILabel!
	
	var transaction: Transaction? {
		didSet {
			guard let transaction = transaction else {
				return
			}
			
			self.businessLabel.text = transaction.business
			self.dateLabel.text = DATE_FORMAT.string(from: transaction.purchaseDate!)
			self.amountLabel.text = transaction.amount?.formattedValue()
			self.categoryLabel.text = transaction.categoryName
			
            if let tmp = transaction.desc, tmp.hasPrefix("?") {
				self.backgroundColor = UIColor.warningColor
			} else {
				self.backgroundColor = nil
			}
		}
	}
}
