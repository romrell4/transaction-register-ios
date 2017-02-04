//
//  TransactionsViewController.swift
//  TransactionRegister
//
//  Created by Eric Romrell on 1/20/17.
//  Copyright © 2017 Eric Romrell. All rights reserved.
//

import UIKit

class TransactionsViewController: TXViewController, UITableViewDataSource, UITableViewDelegate, PopUpDelegate {
	@IBOutlet weak private var spinner: UIActivityIndicatorView!
	@IBOutlet weak private var tableView: TXTableView!
	
	private let ADD_TX_ID = "addTransaction"
	private let EDIT_TX_ID = "editTransaction"
	private let refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
		return refreshControl
	}()
	private var transactions: [Transaction] = []
	private var sums: [PaymentTypeSum] = []
	private var navBarShade: UIView?
	private var backgroundShade: UIView?
	private var countdown: Int = 0
	private var currentFilter: PaymentType?

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.tableView.addSubview(refreshControl)
		self.loadData()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTransaction))
		self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filter))
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == ADD_TX_ID {
			let vc = segue.destination as! AddTransactionPopUpViewController
			vc.delegate = self
			vc.defaultPaymentType = self.currentFilter
		} else if segue.identifier == EDIT_TX_ID {
			let vc = segue.destination as! AddTransactionPopUpViewController
			vc.delegate = self
			vc.transaction = self.transactions[self.tableView.indexPath(for: sender as! UITableViewCell)!.row]
		}
	}
	
	//MARK: UITableViewDataSource/Delegate callbacks
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = Bundle.main.loadNibNamed("SectionHeaderView", owner: self, options: nil)![0] as! SectionHeaderView
		header.textLabel.text = self.currentFilter?.prettyType ?? "All"
		var sumStr: String?
		for sum in self.sums {
			if sum.paymentType?.realType == self.currentFilter?.realType {
				sumStr = sum.total.formattedValue()
			}
		}
		header.detailTextLabel.text = sumStr
		return header;
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 30
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.transactions.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let tx = self.transactions[indexPath.row]
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TransactionTableViewCell
		cell.transaction = tx
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	//MARK: PopUpDelegate callback
	
	func popUpDismissed(changes: Bool) {
		self.navBarShade?.removeFromSuperview()
		self.backgroundShade?.removeFromSuperview()
		
		if changes {
			self.loadData()
		}
	}
	
	//MARK: Listeners
	
	func filter() {
		let alert = UIAlertController(title: "What ccount would you like to filter by?", message: nil, preferredStyle: .actionSheet)
		for sum in self.sums {
			let title = sum.paymentType != nil ? sum.paymentType!.prettyType : "All"
			alert.addAction(UIAlertAction(title: title, style: .default, handler: { (_) in
				self.currentFilter = sum.paymentType
				self.loadData()
			}))
		}
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		self.present(alert, animated: true, completion: nil)
	}
	
	func addTransaction() {
		//Make main navBar faded
		self.navBarShade = UIView(frame: CGRect(x: 0, y: -20, width: (self.navigationController?.navigationBar.frame.size.width)!, height: (self.navigationController?.navigationBar.frame.size.height)! + 20))
		self.navBarShade!.backgroundColor = UIColor.black
		self.navBarShade!.alpha = 0.5;
		self.navigationController?.navigationBar.addSubview(self.navBarShade!);
		
		//Make main view faded
		self.backgroundShade = UIView(frame: self.view.frame)
		self.backgroundShade!.backgroundColor = UIColor.black
		self.backgroundShade!.alpha = 0.5
		self.view.addSubview(self.backgroundShade!)
		
		self.performSegue(withIdentifier: ADD_TX_ID, sender: nil)
	}
	
	func loadData() {
		self.tabBarController?.navigationItem.leftBarButtonItem?.isEnabled = false
		self.tabBarController?.navigationItem.rightBarButtonItem?.isEnabled = false
		self.spinner.startAnimating()
		
		self.loadTransactions(date: Date())
		self.loadSums()
	}
	
	//MARK: Custom Functions
	
	private func loadTransactions(date: Date) {
		self.countdown += 1
		Client.getAllTransactions(date: date, paymentType: self.currentFilter) { (transactions, error) in
			if error != nil {
				self.showError(error: error!)
			} else {
				if transactions!.count == 0 {
					//TODO: Instead, load whenever the bottom is hit
					
					//Load the next month's transactions
					var comp = DateComponents()
					comp.month = -1
					let newDate = Calendar.current.date(byAdding: comp, to: date)
					
					//NOTE: This will go into an infinite loop if no transactions are ever found
					self.loadTransactions(date: newDate!)
				} else {
					self.transactions = transactions!
				}
			}
			self.decrementCountdown()
		}
	}
	
	private func loadSums() {
		self.countdown += 1
		Client.getPaymentTypeSums { (sums, error) in
			if error != nil {
				self.showError(error: error!)
			} else {
				var mutableSums = sums!
				var total = 0.0
				for sum in mutableSums {
					total += sum.total.value
				}
				mutableSums.append(PaymentTypeSum(amount: total))
				self.sums = mutableSums
			}
			self.decrementCountdown()
		}
	}
	
	private func decrementCountdown() {
		self.countdown -= 1
		if (self.countdown == 0) {
			self.spinner.stopAnimating()
			self.refreshControl.endRefreshing()
			self.tabBarController?.navigationItem.leftBarButtonItem?.isEnabled = true
			self.tabBarController?.navigationItem.rightBarButtonItem?.isEnabled = true
			self.tableView.reloadData()
		}
	}
}
