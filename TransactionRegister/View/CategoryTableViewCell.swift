//
//  CategoryTableViewCell.swift
//  TransactionRegister
//
//  Created by Eric Romrell on 1/20/17.
//  Copyright © 2017 Eric Romrell. All rights reserved.
//

import UIKit

enum CategoryProperty {
	case CATEGORY_NAME
	case MONTH
}

class CategoryTableViewCell: UITableViewCell {
	//TODO: Make all fields private that don't have to be public
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var amountSpentLabel: UILabel!
	
	func setup(category: BudgetCategory, mainProperty: CategoryProperty) -> Void {
		switch mainProperty {
			case .CATEGORY_NAME:
				self.nameLabel.text = category.name
				break;
			case .MONTH:
				self.nameLabel.text = category.month
				break;
		}
		
		self.amountSpentLabel.text = category.amountSpent.formattedValue()
		
		if category.amountBudgeted.value == 0 {
			self.amountSpentLabel.textColor = .black
		} else if category.amountSpent.value > category.amountBudgeted.value {
			self.amountSpentLabel.textColor = .red
		} else {
			self.amountSpentLabel.textColor = .darkGreen
		}
	}
}
