//
//  AddTransactionPopUpViewController.swift
//  TransactionRegister
//
//  Created by Eric Romrell on 1/20/17.
//  Copyright © 2017 Eric Romrell. All rights reserved.
//

import UIKit

protocol PopUpDelegate {
	func popUpDismissed(changes: Bool)
}

class AddTransactionPopUpViewController: TXViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
	var delegate: PopUpDelegate?
	var defaultPaymentType: PaymentType?
	var transaction: Transaction?
	
	@IBOutlet weak private var spinner: UIActivityIndicatorView!
	@IBOutlet weak private var bottomConstraint: NSLayoutConstraint!
	@IBOutlet weak private var paymentTypeControl: UISegmentedControl!
	@IBOutlet weak private var businessField: UITextField!
	@IBOutlet weak private var dateField: UITextField!
	@IBOutlet weak private var amountField: UITextField!
	@IBOutlet weak private var categoryField: UITextField!
	@IBOutlet weak private var descriptionField: UITextField!

	private let TOOLBAR_HEIGHT: CGFloat = 44.0
	private let dateFormat: DateFormatter = {
		let dateFormat = DateFormatter()
		dateFormat.dateFormat = "MM/dd/yyyy"
		return dateFormat
	}()
	private var categories = [BudgetCategory]()
	private var selectedCategoryId = -1
	private var purchaseDate: Date?
	private var selectedField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()

		//Load the data if we're editing an existing transaction
		if let transaction = self.transaction {
			self.paymentTypeControl.selectedSegmentIndex = transaction.paymentType!.orderIndex()
			self.businessField.text = transaction.business
			self.dateField.text = dateFormat.string(from: transaction.purchaseDate!)
			self.purchaseDate = transaction.purchaseDate
			self.amountField.text = String(format: "%.2f", transaction.amount!.value)
			self.categoryField.text = transaction.categoryName
			self.selectedCategoryId = transaction.categoryId
			self.descriptionField.text = transaction.desc
		} else {
			//If there is a default, select it. Otherwise, default to the first one
			self.paymentTypeControl.selectedSegmentIndex = self.defaultPaymentType != nil ? self.defaultPaymentType!.orderIndex() : 0
		}
		
		//Listen for when the keyboard enters and exists the screen
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
		
		//Setup a special date picker for the keyboard
		let datePicker = UIDatePicker()
		datePicker.datePickerMode = .date
		datePicker.addTarget(self, action: #selector(dateUpdated(picker:)), for: .valueChanged)
		self.dateField.inputView = datePicker
		
		//Setup a custom picker view for the categories
		let categoryPicker = UIPickerView()
		categoryPicker.delegate = self
		categoryPicker.dataSource = self
		self.categoryField.inputView = categoryPicker
		
		//Put toolbars on top of each of the non keyboard fields
		let toolbar = self.createNextToolbarWithNegative(negative: false)
		self.dateField.inputAccessoryView = toolbar
		self.categoryField.inputAccessoryView = toolbar
		
		let amountToolbar = self.createNextToolbarWithNegative(negative: true)
		self.amountField.inputAccessoryView = amountToolbar
		
		//Load the picker values up from the web service
		Client.getAllActiveCategories { (categories, error) in
			if error != nil {
				self.showError(error: error!)
			} else {
				self.categories = categories!
				(self.categoryField.inputView as! UIPickerView).reloadAllComponents()
			}
		}
    }
	
	//MARK: UITextFieldDelegate callbacks
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		self.selectedField = textField
		
		if textField == self.dateField && self.dateField.text == "" {
            let now = Date()
			self.purchaseDate = now
			textField.text = dateFormat.string(from: now)
		} else if textField == self.categoryField {
            //Get the index of the category
            let categoryIndex = self.categories.index(where: { return $0.categoryId == selectedCategoryId }) ?? 0
            
			self.selectedCategoryId = self.categories[categoryIndex].categoryId
			textField.text = self.categories[categoryIndex].name
		}
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField.text == "" && textField != self.descriptionField {
			textField.layer.borderColor = UIColor.red.cgColor
			textField.layer.borderWidth = 1
		} else {
			textField.layer.borderWidth = 0
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		let nextTag = textField.tag + 1;
		
		if let nextResponder = textField.superview?.viewWithTag(nextTag) {
			nextResponder.becomeFirstResponder()
		} else {
			textField.resignFirstResponder()
			self.saveTapped(self)
		}
		return false
	}
	
	//MARK: UIPickerViewDataSource/Delegate callbacks

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return self.categories.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return self.categories[row].name;
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		self.selectedCategoryId = self.categories[row].categoryId
		self.categoryField.text = self.categories[row].name
	}
	
	//MARK: Listeners
	
	@IBAction func saveTapped(_ sender: Any) {
		do {
			let newTx = try self.getTransactionIfValid()
			self.spinner.startAnimating()
			
			func callback(transaction: Transaction?, error: TXError?) {
				self.spinner.stopAnimating()
				if error == nil {
					self.dismissPopUp(changes: true)
				} else {
					self.showError(error: error!)
				}
			}
			
			if let transaction = self.transaction {
				Client.editTransaction(txId: transaction.transactionId, tx: newTx, callback: callback)
			} else {
				Client.createTransaction(tx: newTx, callback: callback)
			}
		} catch let error {
			let errorFields = (error as! TXFieldError).textFields;
			for field: UITextField in errorFields {
				field.layer.borderColor = UIColor.red.cgColor
				field.layer.borderWidth = 1
			}
		}
	}
	
	@IBAction func cancelTapped(_ sender: Any) {
		self.dismissPopUp(changes: false)
	}
	
	func nextTapped() {
		_ = self.textFieldShouldReturn(self.selectedField!)
	}
	
	func dateUpdated(picker: UIDatePicker) {
		self.purchaseDate = picker.date
		self.dateField.text = dateFormat.string(from: picker.date)
	}
	
	func togglePositiveNegative() {
		guard let amountText = self.amountField.text else {
			return
		}
		
		if amountText.hasPrefix("-") {
			self.amountField.text = String(amountText.characters.dropFirst())
		} else {
			self.amountField.text = "-" + amountText
		}
	}
	
	func keyboardWillShow(notification: NSNotification) {
		self.bottomConstraint.constant = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size.height
	}
	
	func keyboardWillHide(notification: NSNotification) {
		self.bottomConstraint.constant = 0
	}
	
	//MARK: Custom Functions
	
	private func createNextToolbarWithNegative(negative: Bool) -> UIToolbar {
		let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: TOOLBAR_HEIGHT))
		let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))
		toolbar.backgroundColor = UIColor.gray
		if negative {
			let plusMinusButton = UIBarButtonItem(title: "+/-", style: .plain, target: self, action: #selector(togglePositiveNegative))
			toolbar.items = [plusMinusButton, flexSpace, nextButton]
		} else {
			toolbar.items = [flexSpace, nextButton]
		}
		return toolbar
	}
	
	private func getTransactionIfValid() throws -> Transaction {
		var errorFields = [UITextField]()
		
		let tx = Transaction()
		tx.paymentType = PaymentType.paymentType(index: self.paymentTypeControl.selectedSegmentIndex)
		if self.businessField.text != "" {
			tx.business = self.businessField.text
		} else {
			errorFields.append(self.businessField)
		}
		
		if self.purchaseDate != nil {
			tx.purchaseDate = self.purchaseDate
		} else {
			errorFields.append(self.dateField)
		}
		
		if self.amountField.text != "" {
			tx.amount = Amount(value: Double(self.amountField.text!)!)
		} else {
			errorFields.append(self.amountField)
		}
		
		if self.selectedCategoryId != -1 {
			tx.categoryId = self.selectedCategoryId
		} else {
			errorFields.append(self.categoryField)
		}
		
		tx.desc = self.descriptionField.text
		
		if errorFields.count > 0 {
			throw TXFieldError(textFields: errorFields)
		}
		return tx
	}
	
	private func dismissPopUp(changes: Bool) {
		self.delegate?.popUpDismissed(changes: changes)
		self.dismiss(animated: true, completion: nil)
	}
}

class TXFieldError : Error {
	var textFields: [UITextField]
	
	init(textFields: [UITextField]) {
		self.textFields = textFields
	}
}
