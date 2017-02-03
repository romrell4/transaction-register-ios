//
//  TXTableView.swift
//  TransactionRegister
//
//  Created by Eric Romrell on 1/20/17.
//  Copyright © 2017 Eric Romrell. All rights reserved.
//

import UIKit

class TXTableView: UITableView {

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		if self.tableFooterView == nil {
			self.tableFooterView = UIView()
		}
	}

}
