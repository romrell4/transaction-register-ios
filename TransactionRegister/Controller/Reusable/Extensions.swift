//
//  Extensions.swift
//  TransactionRegister
//
//  Created by Eric Romrell on 5/6/17.
//  Copyright © 2017 Eric Romrell. All rights reserved.
//

import UIKit
import Foundation

extension DateFormatter {
    convenience init(format: String) {
        self.init()
        self.dateFormat = format
        self.locale = Locale(identifier: "US")
    }
}
