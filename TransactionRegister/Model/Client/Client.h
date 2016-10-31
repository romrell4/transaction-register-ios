//
//  Client.h
//  TransactionRegister
//
//  Created by Eric Romrell on 9/4/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Category.h"
#import "TXError.h"
#import "Transaction.h"

#define DEFAULT_ERROR_MESSAGE @"There was an error loading the data from the service. Please talk to your husband about it. :)"

@interface Client : NSObject

+(void)getBudgetWithCallback:(void (^)(NSArray<Category *> *categories, TXError *error))callback;
+(void)getAllActiveCategoriesWithCallback:(void (^)(NSArray<Category *> *categories, TXError *error))callback;
+(void)getHistoryForCategoryId:(int)categoryId withCallback:(void (^)(NSArray<Category *> *history, TXError *error))callback;

+(void)getAllTransactionsWithPaymentType:(PaymentType)paymentType withCallback:(void (^)(NSArray<Transaction *> *transactions, TXError *error))callback;

+(void)createTransaction:(Transaction *)tx withCallback:(void (^)(Transaction *tx, TXError *error))callback;

@end
