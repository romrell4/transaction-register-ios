//
//  PaymentType.swift
//  TransactionRegister
//
//  Created by Eric Romrell on 1/19/17.
//  Copyright © 2017 Eric Romrell. All rights reserved.
//

import Foundation

class PaymentType : NSObject, Comparable {
	private static let PAYMENT_TYPES = [
		PaymentType(realType: "CREDIT"),
		PaymentType(realType: "DEBIT"),
		PaymentType(realType: "SAVINGS"),
		PaymentType(realType: "PERMANENT_SAVINGS")
	];
	var realType : String
	var prettyType : String?
	
	init(realType : String) {
		self.realType = realType
	}
	
	static func paymentType(index : Int) -> PaymentType {
		return PAYMENT_TYPES[index]
	}
	
	func orderIndex() -> Int {
		guard let temp = PaymentType.PAYMENT_TYPES.index(of: self) else {
			print("Invalid payment type: ", self.realType)
			return -1
		}

		return temp;
	}
	
	static func <(lhs: PaymentType, rhs: PaymentType) -> Bool {
		return lhs.orderIndex() < rhs.orderIndex()
	}
	
	static func ==(lhs: PaymentType, rhs: PaymentType) -> Bool {
		return lhs.realType == rhs.realType
	}
}
