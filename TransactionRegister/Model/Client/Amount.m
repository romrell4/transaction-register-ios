//
//  Amount.m
//  TransactionRegister
//
//  Created by Eric Romrell on 9/4/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import "Amount.h"

@implementation Amount

+(Amount *)amountWithDouble:(double)value {
	Amount *me = [[Amount alloc] init];
	me.value = value;
	return me;
}

-(NSString *)formattedValue {
	NSNumberFormatter *format = [NSNumberFormatter new];
	//TODO: Figure out if you like this
//	[format setNumberStyle:NSNumberFormatterCurrencyAccountingStyle];
	[format setNumberStyle:NSNumberFormatterCurrencyStyle];
	return [format stringFromNumber:[NSNumber numberWithDouble:self.value]];
	return [NSString stringWithFormat:@"$%.02f", self.value];
}

@end
