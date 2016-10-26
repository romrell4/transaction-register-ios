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
	self.amountSpentLabel.textColor = category.amountSpent.value > category.amountBudgeted.value ? [UIColor redColor] : [UIColor darkGreenColor];
}

@end
