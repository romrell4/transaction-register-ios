//
//  PaymentType.m
//  TransactionRegister
//
//  Created by Eric Romrell on 11/1/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import "PaymentType.h"

@implementation PaymentType

+(NSArray<PaymentType *> *)paymentTypes {
	return @[
			 [PaymentType typeWithRealType:@"CREDIT"],
			 [PaymentType typeWithRealType:@"DEBIT"],
			 [PaymentType typeWithRealType:@"SAVINGS"],
			 [PaymentType typeWithRealType:@"PERMANENT_SAVINGS"]
			 ];
}

+(PaymentType *)typeWithRealType:(NSString *)realType {
	PaymentType *me = [[self alloc] init];
	me.realType = [realType uppercaseString];
	me.prettyType = [[me.realType stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalizedString];
	return me;
}

+(PaymentType *)typeFromIndex:(int)index {
	return [PaymentType paymentTypes][index];
}

-(int)orderIndex {
	return (int) [[PaymentType paymentTypes] indexOfObject:self];
}

-(BOOL)isEqual:(id)object {
	return [object isKindOfClass:[PaymentType class]] && [((PaymentType *) object).realType isEqualToString:self.realType];
}

-(NSComparisonResult)compare:(id)object {
	if ([object isKindOfClass:[PaymentType class]]) {
		PaymentType *type = object;
		if (self.orderIndex > type.orderIndex) {
			return NSOrderedDescending;
		} else if (self.orderIndex < type.orderIndex) {
			return NSOrderedAscending;
		} else {
			return NSOrderedSame;
		}
	}
	return NSOrderedSame;
}

@end
