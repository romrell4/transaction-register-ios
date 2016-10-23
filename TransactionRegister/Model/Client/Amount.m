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
	return [NSString stringWithFormat:@"$%.02f", self.value];
}

@end
