//
//  PaymentTypeSum.h
//  TransactionRegister
//
//  Created by Eric Romrell on 10/31/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Transaction.h"

@interface PaymentTypeSum : NSObject

@property (nonatomic) PaymentType *paymentType;
@property (nonatomic) Amount *total;

+(PaymentTypeSum *)sumWithDictionary:(NSDictionary *)dict;

@end
