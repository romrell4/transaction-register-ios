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

+(void)getAllCurrentCategoriesWithCallback:(void (^)(NSArray<Category *> *, TXError *))callback {
	NSString *url = [NSString stringWithFormat:@"%@/categories?%@", BASE_URL, [self monthAndYear]];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	[self sendRequest:request withCallback:^(TXResponse *response) {
		if (response.failed) {
			callback(nil, response.error);
		} else {
			NSArray *categoriesJson = [response getDataJson];
			
			NSMutableArray<Category *> *categories = [NSMutableArray arrayWithCapacity:categoriesJson.count];
			for (NSDictionary *dict in categoriesJson) {
				[categories addObject:[Category categoryWithDictionary:dict]];
			}
			callback(categories, nil);
		}
	}];
}

+(void)getHistoryForCategoryId:(int)categoryId withCallback:(void (^)(NSArray<Category *> *, TXError *))callback {
	NSString *url = [NSString stringWithFormat:@"%@/categories?categoryId=%i", BASE_URL, categoryId];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	[self sendRequest:request withCallback:^(TXResponse *response) {
		if (response.failed) {
			callback(nil, response.error);
		} else {
			NSArray *historyJson = [response getDataJson];
			
			NSMutableArray<Category *> *history = [NSMutableArray arrayWithCapacity:historyJson.count];
			for (NSDictionary *dict in historyJson) {
				[history addObject:[Category categoryWithDictionary:dict]];
			}
			callback(history, nil);
		}
	}];
}

+(void)getAllTransactionsThisMonthWithCallback:(void (^)(NSArray<Transaction *> *, TXError *))callback {
	NSString *url = [NSString stringWithFormat:@"%@/transactions?%@", BASE_URL, [self monthAndYear]];
	
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
			[transactions sortUsingComparator:^NSComparisonResult(Transaction *tx1, Transaction *tx2) {
				if (![tx1.purchaseDate isEqual:tx2.purchaseDate]) {
					return [tx2.purchaseDate compare:tx1.purchaseDate];
				} else {
					return [[NSNumber numberWithInt:tx2.transactionId] compare:[NSNumber numberWithInt:tx1.transactionId]];
				}
			}];
			callback(transactions, nil);
		}
	}];
}

+(void)getAllTransactionsForPaymentType:(PaymentType)paymentType withCallback:(void (^)(NSArray<Transaction *> *, TXError *))callback {
	
}

+(void)sendRequest:(NSURLRequest *)request withCallback:(void (^)(TXResponse *response))callback {
	[[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			TXResponse *txResponse = [TXResponse responseWithData:data response:(NSHTTPURLResponse *)response andError:error];
			//If the reponse failed, and there was no readable message, look for retry policy
			if (txResponse.failed) {
				[txResponse logError];
			}
			
			callback(txResponse);
		}];
	}] resume];
}

+(NSString *)monthAndYear {
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"'month='MM'&year='YYYY"];
	return [format stringFromDate:[NSDate date]];
}

@end
