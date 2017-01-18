//
//  Category.h
//  TransactionRegister
//
//  Created by Eric Romrell on 9/4/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Amount;

@interface TXCategory : NSObject

@property (nonatomic) int categoryId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *month;
@property (nonatomic) Amount *amountSpent;
@property (nonatomic) Amount *amountLeft;
@property (nonatomic) Amount *amountBudgeted;

+(TXCategory *)categoryWithDictionary:(NSDictionary *)dict;

@end
