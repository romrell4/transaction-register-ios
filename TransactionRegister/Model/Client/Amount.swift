//
//  NewAmount.swift
//  TransactionRegister
//
//  Created by Eric Romrell on 1/18/17.
//  Copyright © 2017 Eric Romrell. All rights reserved.
//

import Foundation

class Amount : CustomStringConvertible {
	var value : Double
	
	init(value: Double) {
		self.value = value;
	}
	
	func formattedValue() -> String? {
		let format = NumberFormatter()
		format.numberStyle = .currency
		return format.string(from: NSNumber(floatLiteral: self.value))
	}
	
	public var description: String {
		return "\(self.value)"
	}
}
