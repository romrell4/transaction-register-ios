//
//  CategoryTableViewCell.h
//  TransactionRegister
//
//  Created by Eric Romrell on 9/4/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BudgetCategory;

typedef enum {
	CATEGORY_NAME,
	MONTH
} CategoryProperty;

@interface CategoryTableViewCell : UITableViewCell

@property (nonatomic, readonly) BudgetCategory *category;

-(void)setCategory:(BudgetCategory *)category withMainProperty:(CategoryProperty)mainProperty;

@end
