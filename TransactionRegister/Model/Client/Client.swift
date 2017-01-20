//
//  Client.swift
//  TransactionRegister
//
//  Created by Eric Romrell on 1/20/17.
//  Copyright © 2017 Eric Romrell. All rights reserved.
//

import Foundation

class Client : NSObject {
	private static let BASE_URL = "https://transaction-register.herokuapp.com"
	private static let DEFAULT_ERROR_MESSAGE = "There was an error loading the data from the service. Please talk to your husband about it. :)"
	
	static func getBudget(date:Date, callback:@escaping ([BudgetCategory]?, TXError?) -> Void) {
		let request = URLRequest(url: URL(string:String(format: "%@/categories?%@", BASE_URL, monthAndYearQueryString(date: date)))!)
		sendRequest(request: request) { (response) in
			if response.failed() {
				callback(nil, response.error)
			} else {
				callback(parseCategories(response: response), nil)
			}
		}
	}
	
	static func getAllActiveCategories(callback:@escaping ([BudgetCategory]?, TXError?) -> Void) {
		let request = URLRequest(url: URL(string: String(format: "%@/categories/active", BASE_URL))!)
		sendRequest(request: request) { (response) in
			if response.failed() {
				callback(nil, response.error)
			} else {
				callback(parseCategories(response: response), nil)
			}
		}
	}
	
	static func getHistory(categoryId:Int, callback:@escaping ([BudgetCategory]?, TXError?) -> Void) {
		let request = URLRequest(url: URL(string: String(format: "%@/categories/categoryId=%i", BASE_URL, categoryId))!)
		sendRequest(request: request) { (response) in
			if response.failed() {
				callback(nil, response.error)
			} else {
				callback(parseCategories(response: response), nil)
			}
		}
	}
	
	static func getAllTransactions(date:Date, paymentType:PaymentType?, callback:@escaping([Transaction]?, TXError?) -> Void) {
		let paymentTypeParam = paymentType != nil ? String(format: "&type=%@", paymentType!.realType) : ""
		let request = URLRequest(url: URL(string: String(format: "%@/transactions?%@%@", BASE_URL, monthAndYearQueryString(date: date), paymentTypeParam))!)
		sendRequest(request: request) { (response) in
			if response.failed() {
				callback(nil, response.error)
			} else {
				guard let transactionsJson = response.getDataJson() as? [Dictionary<String, Any>] else {
					callback([], nil)
					return
				}
				
				var transactions = [Transaction]()
				for dict in transactionsJson {
					transactions.append(Transaction(dict: dict))
				}
				callback(transactions, nil)
			}
		}
	}
	
	static func getPaymentTypeSums(callback:@escaping ([PaymentTypeSum]?, TXError?) -> Void) {
		let request = URLRequest(url: URL(string: String(format: "%@/transactions/sums", BASE_URL))!)
		sendRequest(request: request) { (response) in
			if response.failed() {
				callback(nil, response.error)
			} else {
				guard let sumsJson = response.getDataJson() as? [Dictionary<String, Any>] else {
					callback([], nil)
					return
				}
				
				var sums = [PaymentTypeSum]()
				for dict in sumsJson {
					sums.append(PaymentTypeSum(dict: dict))
				}
				sums.sort(by: { (sum1, sum2) -> Bool in
					sum1.paymentType!.orderIndex() < sum2.paymentType!.orderIndex()
				})
				callback(sums, nil)
			}
		}
	}
	
	static func createTransaction(tx:Transaction, callback:@escaping (Transaction?, TXError?) -> Void) {
		var request = URLRequest(url: URL(string: String(format: "%@/transactions", BASE_URL))!);
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = try? JSONSerialization.data(withJSONObject: tx.toDictionary(), options: [])
		sendRequest(request: request) { (response) in
			if response.failed() {
				callback(nil, response.error)
			} else {
				callback(Transaction(dict: response.getDataJson() as! Dictionary<String, Any>), nil)
			}
		}
	}
	
	static func editTransaction(txId:Int, tx:Transaction, callback:@escaping (Transaction?, TXError?) -> Void) {
		var request = URLRequest(url: URL(string: String(format: "%@/transactions/%i", BASE_URL, txId))!);
		request.httpMethod = "PUT"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = try? JSONSerialization.data(withJSONObject: tx.toDictionary(), options: [])
		sendRequest(request: request) { (response) in
			if response.failed() {
				callback(nil, response.error)
			} else {
				callback(Transaction(dict: response.getDataJson() as! Dictionary<String, Any>), nil)
			}
		}
	}
	
	private static func parseCategories(response:TXResponse) -> [BudgetCategory] {
		guard let categoriesJson = response.getDataJson() as? [Dictionary<String, Any>] else {
			return []
		}
		
		var categories = [BudgetCategory]()
		for dict in categoriesJson {
			categories.append(BudgetCategory(dict: dict))
		}
		return categories
	}
	
	private static func sendRequest(request:URLRequest, callback:@escaping ((TXResponse) -> Void)) {
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			OperationQueue.main.addOperation({ 
				let txResponse = TXResponse.response(data: data, response: response as? HTTPURLResponse, error: error)
				if txResponse.failed() {
					txResponse.logError()
				}
				
				callback(txResponse)
			})
		}.resume()
	}
	
	private static func monthAndYearQueryString(date:Date) -> String {
		let format = DateFormatter()
		format.dateFormat = "'month='MM'&year='YYYY'";
		return format.string(from: date)
	}
}
