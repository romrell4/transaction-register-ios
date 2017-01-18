//
//  CategoryTableViewCell.h
//  TransactionRegister
//
//  Created by Eric Romrell on 9/4/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXCategory.h"

typedef enum {
	CATEGORY_NAME,
	MONTH
} CategoryProperty;

@interface CategoryTableViewCell : UITableViewCell

@property (nonatomic, readonly) TXCategory *category;

-(void)setCategory:(TXCategory *)category withMainProperty:(CategoryProperty)mainProperty;

@end
