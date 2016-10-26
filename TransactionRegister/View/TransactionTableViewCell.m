//
//  TransactionTableViewCell.m
//  TransactionRegister
//
//  Created by Eric Romrell on 10/25/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import "TransactionTableViewCell.h"

@interface TransactionTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *businessLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end

@implementation TransactionTableViewCell

-(void)setTransaction:(Transaction *)transaction {
	_transaction = transaction;
	
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MMM dd, yyyy"];
	
	self.businessLabel.text = transaction.business;
	self.dateLabel.text = [format stringFromDate:transaction.purchaseDate];
	self.amountLabel.text = [transaction.amount formattedValue];
	self.categoryLabel.text = transaction.categoryName;
}

@end
