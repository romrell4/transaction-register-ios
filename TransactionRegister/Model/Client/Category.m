//
//  Category.m
//  TransactionRegister
//
//  Created by Eric Romrell on 9/4/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import "Category.h"

@implementation Category

+(Category *)categoryWithDictionary:(NSDictionary *)dict {
	Category *me = [[Category alloc] init];
	me.categoryId = [dict[@"categoryId"] intValue];
	me.name = dict[@"name"];
	me.month = dict[@"month"];
	me.amountBudgeted = [Amount amountWithDouble:[dict[@"amountBudgeted"] doubleValue]];
	me.amountSpent = [Amount amountWithDouble:[dict[@"amountSpent"] doubleValue]];
	me.amountLeft = [Amount amountWithDouble:[dict[@"amountLeft"] doubleValue]];
	return me;
}

@end
