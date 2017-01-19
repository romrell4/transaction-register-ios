//
//  Category.swift
//  TransactionRegister
//
//  Created by Eric Romrell on 1/19/17.
//  Copyright © 2017 Eric Romrell. All rights reserved.
//

import Foundation

class BudgetCategory : NSObject {
	var categoryId : Int
	var name : String?
	var month : String?
	var amountSpent : Amount
	var amountLeft : Amount
	var amountBudgeted : Amount
	
	init(dict : Dictionary<String, Any>) {
		self.categoryId = dict["categoryId"] as! Int;
		self.name = dict["name"] as! String?
		self.month = dict["month"] as! String?
		self.amountSpent = Amount(value: dict["amountSpent"] as! Double)
		self.amountLeft = Amount(value: dict["amountLeft"] as! Double)
		self.amountBudgeted = Amount(value: dict["amountLeft"] as! Double)
	}
}
