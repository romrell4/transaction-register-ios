//
//  Transaction.swift
//  TransactionRegister
//
//  Created by Eric Romrell on 1/19/17.
//  Copyright © 2017 Eric Romrell. All rights reserved.
//

import Foundation

class Transaction {
	private static let dateFormat : DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
		return formatter
	}()
	
	var transactionId : Int = -1
	var paymentType : PaymentType?
	var purchaseDate : Date?
	var business : String?
	var amount : Amount?
	var categoryId : Int = -1
	var categoryName : String?
	var desc : String?
	
	init() {}
	
	init(dict : Dictionary<String, Any>) {
		self.transactionId = dict["transactionId"] as! Int
		self.paymentType = PaymentType(realType: dict["paymentType"] as! String)
		self.purchaseDate = Transaction.dateFormat.date(from: dict["purchaseDate"] as! String)
		self.business = dict["business"] as! String?
		self.amount = Amount(value: dict["amount"] as! Double)
		self.categoryId = dict["categoryId"] as! Int
		self.categoryName = dict["categoryName"] as! String?
		self.desc = dict["description"] as! String?
	}
	
	func toDictionary() -> Dictionary<String, Any> {
		var dict = Dictionary<String, Any>()
		
		if self.transactionId != -1 {
			dict["transactionId"] = self.transactionId
		}
		dict["paymentType"] = self.paymentType?.realType
		dict["purchaseDate"] = Transaction.dateFormat.string(from: self.purchaseDate!)
		dict["business"] = self.business
		dict["amount"] = self.amount?.value
		dict["categoryId"] = self.categoryId
		if self.desc != nil {
			dict["description"] = self.desc
		}
		return dict
	}
}
