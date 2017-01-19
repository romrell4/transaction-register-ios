//
//  Transaction.h
//  TransactionRegister
//
//  Created by Eric Romrell on 10/24/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Amount;
@class PaymentType;

@interface Transaction : NSObject

@property (nonatomic) int transactionId;
@property (nonatomic) PaymentType *paymentType;
@property (nonatomic) NSDate *purchaseDate;
@property (nonatomic) NSString *business;
@property (nonatomic) Amount *amount;
@property (nonatomic) int categoryId;
@property (nonatomic) NSString *categoryName;
@property (nonatomic) NSString *desc;

+(Transaction *)transactionWithDictionary:(NSDictionary *)dict;

-(NSDictionary *)toDictionary;

@end
