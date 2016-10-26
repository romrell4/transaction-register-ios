//
//  TransactionTableViewCell.h
//  TransactionRegister
//
//  Created by Eric Romrell on 10/25/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transaction.h"

@interface TransactionTableViewCell : UITableViewCell

@property (nonatomic) Transaction *transaction;

@end
