//
//  Client.h
//  TransactionRegister
//
//  Created by Eric Romrell on 9/4/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXCategory.h"
#import "TXError.h"
#import "Transaction.h"
#import "PaymentTypeSum.h"

#define DEFAULT_ERROR_MESSAGE @"There was an error loading the data from the service. Please talk to your husband about it. :)"

@interface Client : NSObject

+(void)getBudgetWithDate:(NSDate *)date andCallback:(void (^)(NSArray<TXCategory *> *categories, TXError *error))callback;

+(void)getAllActiveCategoriesWithCallback:(void (^)(NSArray<TXCategory *> *categories, TXError *error))callback;

+(void)getHistoryForCategoryId:(int)categoryId withCallback:(void (^)(NSArray<TXCategory *> *history, TXError *error))callback;

+(void)getAllTransactionsForDate:(NSDate *)date withPaymentType:(PaymentType *)paymentType withCallback:(void (^)(NSArray<Transaction *> *transactions, TXError *error))callback;

+(void)getPaymentTypeSumsWithCallback:(void (^)(NSArray<PaymentTypeSum *> *sums, TXError *error))callback;

+(void)createTransaction:(Transaction *)tx withCallback:(void (^)(Transaction *tx, TXError *error))callback;

+(void)editTransaction:(int)txId withTransaction:(Transaction *)tx andCallback:(void (^)(Transaction *tx, TXError *error))callback;

@end
