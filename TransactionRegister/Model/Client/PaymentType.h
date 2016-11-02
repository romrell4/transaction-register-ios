//
//  PaymentType.h
//  TransactionRegister
//
//  Created by Eric Romrell on 11/1/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentType : NSObject

@property (nonatomic) NSString *realType;
@property (nonatomic) NSString *prettyType;

+(PaymentType *)typeWithRealType:(NSString *)realType;
+(PaymentType *)typeFromIndex:(int)index;

-(int)orderIndex;
-(NSComparisonResult)compare:(id)object;

@end
