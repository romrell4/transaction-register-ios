//
//  TXError.swift
//  TransactionRegister
//
//  Created by Eric Romrell on 1/20/17.
//  Copyright © 2017 Eric Romrell. All rights reserved.
//

import Foundation

class TXError : CustomStringConvertible, Error {
	var error : Error?
	var readableMessage : String
	var debugMessage : String?
	
	init(error:Error?, readableMessage:String, debugMessage:String?) {
		self.error = error
		self.readableMessage = readableMessage
		self.debugMessage = debugMessage
	}
	
	public var description: String {
		return "Error: \(self.error)\nReadable Message: \(self.readableMessage)\nDebug Message: \(self.debugMessage ?? "nil")";
	}
}
