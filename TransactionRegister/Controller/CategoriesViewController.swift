//
//  NewCategoriesViewController.swift
//  TransactionRegister
//
//  Created by Eric Romrell on 1/20/17.
//  Copyright © 2017 Eric Romrell. All rights reserved.
//

import UIKit

class CategoriesViewController: TXViewController, UITableViewDataSource, UITableViewDelegate {
	private static let MONTHS_TO_SHOW = 6

	@IBOutlet weak var spinner: UIActivityIndicatorView!
	@IBOutlet weak var tableView: UITableView!
	
	var categories : [BudgetCategory] = []
	var filterDates : [Date] = []
	var currentFilterDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        let calendar = Calendar.current
		var comp = DateComponents()
		for i in 0..<CategoriesViewController.MONTHS_TO_SHOW {
			comp.month = -i
			self.filterDates.append(calendar.date(byAdding: comp, to: self.currentFilterDate)!)
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filter))
		self.tabBarController?.navigationItem.rightBarButtonItem = nil
		
		if self.tableView.indexPathForSelectedRow != nil {
			self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
		}
		
		//Load the data, even when they are just coming back from the other tab
		loadData(date: currentFilterDate)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "category" {
			let vc = segue.destination as! CategoryViewController
			vc.category = self.categories[self.tableView.indexPath(for: sender as! UITableViewCell)!.row]
		}
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let dateFormat = DateFormatter()
		dateFormat.dateFormat = "MMM yyyy"
		return String(format: "Budget - %@", dateFormat.string(from: self.currentFilterDate))
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.categories.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryTableViewCell
		cell.setup(category: self.categories[indexPath.row], mainProperty: .CATEGORY_NAME)
		return cell
	}
	
	func filter() {
		let format = DateFormatter()
		format.dateFormat = "MMMM yyyy"
		
		let alert = UIAlertController(title: "Select Month", message: nil, preferredStyle: .actionSheet)
		for date in self.filterDates {
			alert.addAction(UIAlertAction(title: format.string(from: date), style: UIAlertActionStyle.default, handler: { (action) in
				self.loadData(date: date)
			}))
		}
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	
	func loadData(date:Date) {
		self.spinner.startAnimating()
		Client.getBudget(date: date) { (categories, error) in
			self.spinner.stopAnimating()
			if error != nil {
				self.showError(error: error!)
			} else {
				self.currentFilterDate = date
				self.categories = categories!
				self.tableView.reloadData()
			}
		}
	}
}
