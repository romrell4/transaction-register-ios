//
//  Category.m
//  TransactionRegister
//
//  Created by Eric Romrell on 9/4/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import "BudgetCategory.h"
#import "TransactionRegister-Swift.h"

@implementation BudgetCategory

+(BudgetCategory *)categoryWithDictionary:(NSDictionary *)dict {
	BudgetCategory *me = [[BudgetCategory alloc] init];
	me.categoryId = [dict[@"categoryId"] intValue];
	me.name = dict[@"name"];
	me.month = dict[@"month"];
	me.amountBudgeted = [[Amount alloc] initWithValue:[dict[@"amountBudgeted"] doubleValue]];
	me.amountSpent = [[Amount alloc] initWithValue:[dict[@"amountSpent"] doubleValue]];
	me.amountLeft = [[Amount alloc] initWithValue:[dict[@"amountLeft"] doubleValue]];
	return me;
}

@end
