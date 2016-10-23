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

-(void)setCategory:(Category *)category {
	self.nameLabel.text = category.name;
	self.amountSpentLabel.text = [category.amountSpent formattedValue];
	self.amountSpentLabel.textColor = category.amountSpent.value < 0 ? [UIColor redColor] : [UIColor darkGreenColor];
}

@end
