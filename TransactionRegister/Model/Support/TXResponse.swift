//
//  TXResponse.swift
//  TransactionRegister
//
//  Created by Eric Romrell on 1/20/17.
//  Copyright © 2017 Eric Romrell. All rights reserved.
//

import Foundation

class TXResponse {
	private static let DEFAULT_PATH_TO_READABLE_ERROR = "message"
	private static let DEFAULT_ERROR_MESSAGE = "The server encountered an error. Please try again later."
	var data : Data?
	var response : HTTPURLResponse?
	var error : TXError?
	
	static func response(data:Data?, response:HTTPURLResponse?, error:Error?) -> TXResponse {
		let me = TXResponse()
		me.data = data
		me.response = response
		me.error = me.getError(error:error)
		return me
	}
	
	init() {}
	
	init(error:TXError) {
		self.error = error
	}
	
	func failed() -> Bool {
		return self.error != nil || (self.response != nil && self.response!.statusCode >= 300)
	}
	
	func getDataString() -> String? {
		return self.data != nil ? String(data: self.data!, encoding: String.Encoding.utf8) : nil
	}
	
	func getDataJson() -> Any? {
		guard self.data != nil else {
			return nil
		}
		return try? JSONSerialization.jsonObject(with: self.data!, options: [])
	}
	
	func logError() {
		print(self.error!)
	}
	
	private func getError(error:Error?) -> TXError? {
		if failed() {
			let readableMessage = getReadableMessage()
			if readableMessage != nil {
				return TXError(error: error, readableMessage: readableMessage!, debugMessage: nil);
			} else {
				return TXError(error: error, readableMessage: TXResponse.DEFAULT_ERROR_MESSAGE, debugMessage: getDataString())
			}
		}
		return nil
	}
	
	private func getReadableMessage() -> String? {
		let json = getDataJson()
		if let json = json as? [String: Any] {
			let value = json[TXResponse.DEFAULT_PATH_TO_READABLE_ERROR]
			
			if let value = value as? String {
				return value
			}
		}
		return nil
	}
}
