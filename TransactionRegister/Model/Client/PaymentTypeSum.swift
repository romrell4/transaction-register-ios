//
//  PaymentTypeSum.swift
//  TransactionRegister
//
//  Created by Eric Romrell on 1/19/17.
//  Copyright © 2017 Eric Romrell. All rights reserved.
//

import Foundation

class PaymentTypeSum : NSObject {
	var paymentType : PaymentType?
	var total : Amount
	
	init(dict:Dictionary<String, Any>) {
		//TODO: Understand what this is doing
		self.paymentType = PaymentType(realType: (dict["paymentType"] as! String?)!)
		self.total = Amount(value: dict["total"] as! Double)
	}
	
	init(amount:Double) {
		self.total = Amount(value: amount)
	}
}
