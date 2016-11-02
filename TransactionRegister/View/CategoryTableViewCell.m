//
//  CategoryTableViewCell.m
//  TransactionRegister
//
//  Created by Eric Romrell on 9/4/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import "CategoryTableViewCell.h"
#import "UIColor+colors.h"

@interface CategoryTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountSpentLabel;

@end

@implementation CategoryTableViewCell

-(void)setCategory:(Category *)category withMainProperty:(CategoryProperty)mainProperty {
	switch (mainProperty) {
		case CATEGORY_NAME:
			self.nameLabel.text = category.name;
			break;
		case MONTH:
			self.nameLabel.text = category.month;
			break;
	}
	
	self.amountSpentLabel.text = [category.amountSpent formattedValue];
	
	if (!category.amountBudgeted.value) {
		self.amountSpentLabel.textColor = [UIColor blackColor];
	} else if (category.amountSpent.value > category.amountBudgeted.value) {
		self.amountSpentLabel.textColor = [UIColor redColor];
	} else {
		self.amountSpentLabel.textColor = [UIColor darkGreenColor];
	}
}

@end
