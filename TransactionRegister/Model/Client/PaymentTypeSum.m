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
	PaymentTypeSum *me = [[PaymentTypeSum alloc] init];
	me.paymentType = [PaymentType typeWithRealType:dict[@"paymentType"]];
	me.total = [Amount amountWithDouble:[dict[@"total"] doubleValue]];
	return me;
}

@end
