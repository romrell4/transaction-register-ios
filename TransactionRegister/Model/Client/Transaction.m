//
//  Transaction.m
//  TransactionRegister
//
//  Created by Eric Romrell on 10/24/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import "Transaction.h"

@implementation Transaction

+(Transaction *)transactionWithDictionary:(NSDictionary *)dict {
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MM/dd/yyyy HH:mm:ss"];

	Transaction *me = [[self alloc] init];
	me.transactionId = [dict[@"transationId"] intValue];
	me.paymentType = [self paymentTypeFromString:dict[@"paymentType"]];
	me.purchaseDate = [format dateFromString:dict[@"purchaseDate"]];
	me.business = dict[@"business"];
	me.amount = [Amount amountWithDouble:[dict[@"amount"] doubleValue]];
	me.categoryId = [dict[@"categoryId"] intValue];
	me.categoryName = dict[@"categoryName"];
	me.desc = dict[@"description"];
	return me;
}

+(PaymentType)paymentTypeFromString:(NSString *)paymentTypeStr {
	NSDictionary *enums = @{@"CREDIT": @(CREDIT), @"DEBIT": @(DEBIT), @"SAVINGS": @(SAVINGS), @"PERMANENT_SAVINGS": @(PERMANENT_SAVINGS)};
	return (int) enums[paymentTypeStr];
}

+(NSString *)stringFromPaymentType:(PaymentType)paymentType {
	NSDictionary *enums = @{@(CREDIT): @"CREDIT", @(DEBIT): @"DEBIT", @(SAVINGS): @"SAVINGS", @(PERMANENT_SAVINGS): @"PERMANENT_SAVINGS"};
	return enums[@(paymentType)];
}

-(NSDictionary *)toDictionary {
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MM/dd/yyyy HH:mm:ss"];

	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	if (self.transactionId) {
		dict[@"transactionId"] = [NSString stringWithFormat:@"%i", self.transactionId];
	}
	dict[@"paymentType"] = [Transaction stringFromPaymentType:self.paymentType];
	dict[@"purchaseDate"] = [format stringFromDate:self.purchaseDate];
	dict[@"business"] = self.business;
	dict[@"amount"] = [NSString stringWithFormat:@"%f", self.amount.value];
	dict[@"categoryId"] = [NSString stringWithFormat:@"%i", self.categoryId];
	if (self.desc) {
		dict[@"description"] = self.desc;
	}
	return dict;
}

@end
