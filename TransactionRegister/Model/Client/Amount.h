//
//  Amount.h
//  TransactionRegister
//
//  Created by Eric Romrell on 9/4/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Amount : NSObject

@property (nonatomic) double value;

+(Amount *)amountWithDouble:(double)value;

-(NSString *)formattedValue;

@end
