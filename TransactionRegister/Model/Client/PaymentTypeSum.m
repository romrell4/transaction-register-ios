//
//  PaymentTypeSum.m
//  TransactionRegister
//
//  Created by Eric Romrell on 10/31/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import "PaymentTypeSum.h"

@implementation PaymentTypeSum

+(PaymentTypeSum *)sumWithDictionary:(NSDictionary *)dict {
	PaymentTypeSum *me = [[self alloc] init];
	me.paymentType = [PaymentType typeWithRealType:dict[@"paymentType"]];
	me.total = [Amount amountWithDouble:[dict[@"total"] doubleValue]];
	return me;
}

+(PaymentTypeSum *)sumWithAmount:(double)amount {
	PaymentTypeSum *me = [[self alloc] init];
	me.total = [Amount amountWithDouble:amount];
	return me;
}

-(NSString *)description {
	return [NSString stringWithFormat:@"%@: %@", self.paymentType, self.total.formattedValue];
}

@end
