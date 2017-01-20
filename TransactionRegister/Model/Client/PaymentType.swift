//
//  PaymentType.swift
//  TransactionRegister
//
//  Created by Eric Romrell on 1/19/17.
//  Copyright © 2017 Eric Romrell. All rights reserved.
//

import Foundation

class PaymentType : NSObject {
	private static let PAYMENT_TYPES = [
		PaymentType(realType: "CREDIT"),
		PaymentType(realType: "DEBIT"),
		PaymentType(realType: "SAVINGS"),
		PaymentType(realType: "PERMANENT_SAVINGS")
	];
	var realType : String
	var prettyType : String
	
	init(realType : String) {
		self.realType = realType
		self.prettyType = realType.replacingOccurrences(of: "_", with: " ").capitalized
	}
	
	static func paymentType(index : Int) -> PaymentType {
		return PAYMENT_TYPES[index]
	}
	
	func orderIndex() -> Int {
		let index = PaymentType.PAYMENT_TYPES.index { (paymentType) -> Bool in
			return paymentType.realType == self.realType
		}
		guard let temp = index else {
			print("Invalid payment type: ", self.realType)
			return -1
		}

		return temp;
	}
}
