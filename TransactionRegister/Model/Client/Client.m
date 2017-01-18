//
//  Client.m
//  TransactionRegister
//
//  Created by Eric Romrell on 9/4/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import "Client.h"
#import "TXResponse.h"

#define BASE_URL @"https://transaction-register.herokuapp.com"

@implementation Client

+(void)getBudgetWithDate:(NSDate *)date andCallback:(void (^)(NSArray<TXCategory *> *, TXError *))callback {
	NSString *url = [NSString stringWithFormat:@"%@/categories?%@", BASE_URL, [self monthAndYearWithDate:date]];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	[self sendRequest:request withCallback:^(TXResponse *response) {
		if (response.failed) {
			callback(nil, response.error);
		} else {
			callback([self parseCategoriesFromResponse:response], nil);
		}
	}];
}

+(void)getAllActiveCategoriesWithCallback:(void (^)(NSArray<TXCategory *> *, TXError *))callback {
	NSString *url = [NSString stringWithFormat:@"%@/categories/active", BASE_URL];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	[self sendRequest:request withCallback:^(TXResponse *response) {
		if (response.failed) {
			callback(nil, response.error);
		} else {
			callback([self parseCategoriesFromResponse:response], nil);
		}
	}];
}

+(void)getHistoryForCategoryId:(int)categoryId withCallback:(void (^)(NSArray<TXCategory *> *, TXError *))callback {
	NSString *url = [NSString stringWithFormat:@"%@/categories?categoryId=%i", BASE_URL, categoryId];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	[self sendRequest:request withCallback:^(TXResponse *response) {
		if (response.failed) {
			callback(nil, response.error);
		} else {
			callback([self parseCategoriesFromResponse:response], nil);
		}
	}];
}

+(NSArray<TXCategory *> *)parseCategoriesFromResponse:(TXResponse *)response {
	NSArray *categoriesJson = [response getDataJson];
	
	NSMutableArray<TXCategory *> *categories = [NSMutableArray arrayWithCapacity:categoriesJson.count];
	for (NSDictionary *dict in categoriesJson) {
		[categories addObject:[TXCategory categoryWithDictionary:dict]];
	}
	return categories;
}

+(void)getAllTransactionsForDate:(NSDate *)date withPaymentType:(PaymentType *)paymentType withCallback:(void (^)(NSArray<Transaction *> *, TXError *))callback {
	NSString *paymentTypeParam = paymentType ? [NSString stringWithFormat:@"&type=%@", paymentType.realType] : @"";
	NSString *url = [NSString stringWithFormat:@"%@/transactions?%@%@", BASE_URL, [self monthAndYearWithDate:date], paymentTypeParam];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	[self sendRequest:request withCallback:^(TXResponse *response) {
		if (response.failed) {
			callback(nil, response.error);
		} else {
			NSArray *transactionsJson = [response getDataJson];
			
			NSMutableArray<Transaction *> *transactions = [NSMutableArray arrayWithCapacity:transactionsJson.count];
			for (NSDictionary *dict in transactionsJson) {
				[transactions addObject:[Transaction transactionWithDictionary:dict]];
			}
			callback(transactions, nil);
		}
	}];
}

+(void)getPaymentTypeSumsWithCallback:(void (^)(NSArray<PaymentTypeSum *> *, TXError *))callback {
	NSString *url = [NSString stringWithFormat:@"%@/transactions/sums", BASE_URL];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	[self sendRequest:request withCallback:^(TXResponse *response) {
		if (response.failed) {
			callback(nil, response.error);
		} else {
			NSArray *sumsJson = [response getDataJson];
			
			NSMutableArray<PaymentTypeSum *> *sums = [NSMutableArray arrayWithCapacity:sumsJson.count];
			for (NSDictionary *dict in sumsJson) {
				[sums addObject:[PaymentTypeSum sumWithDictionary:dict]];
			}
			[sums sortUsingComparator:^NSComparisonResult(PaymentTypeSum *sum1, PaymentTypeSum *sum2) {
				return [sum1.paymentType compare:sum2.paymentType];
			}];
			callback(sums, nil);
		}
	}];
}

+(void)createTransaction:(Transaction *)tx withCallback:(void (^)(Transaction *, TXError *))callback {
	NSString *url = [NSString stringWithFormat:@"%@/transactions", BASE_URL];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	request.HTTPMethod = @"POST";
	[request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	request.HTTPBody = [NSJSONSerialization dataWithJSONObject:[tx toDictionary] options:0 error:nil];
	[self sendRequest:request withCallback:^(TXResponse *response) {
		if (response.failed) {
			callback(nil, response.error);
		} else {
			callback([Transaction transactionWithDictionary:[response getDataJson]], nil);
		}
	}];
}

+(void)editTransaction:(int)txId withTransaction:(Transaction *)tx andCallback:(void (^)(Transaction *, TXError *))callback {
	NSString *url = [NSString stringWithFormat:@"%@/transactions/%i", BASE_URL, txId];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	request.HTTPMethod = @"PUT";
	[request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	request.HTTPBody = [NSJSONSerialization dataWithJSONObject:[tx toDictionary] options:0 error:nil];
	[self sendRequest:request withCallback:^(TXResponse *response) {
		if (response.failed) {
			callback(nil, response.error);
		} else {
			callback([Transaction transactionWithDictionary:[response getDataJson]], nil);
		}
	}];
}

+(void)sendRequest:(NSURLRequest *)request withCallback:(void (^)(TXResponse *response))callback {
	[[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			TXResponse *txResponse = [TXResponse responseWithData:data response:(NSHTTPURLResponse *)response andError:error];
			if (txResponse.failed) {
				[txResponse logError];
			}
			
			callback(txResponse);
		}];
	}] resume];
}

+(NSString *)monthAndYearWithDate:(NSDate *)date {
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"'month='MM'&year='YYYY"];
	return [format stringFromDate:date];
}

@end
