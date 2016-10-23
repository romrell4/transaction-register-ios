//
//  Error.h
//  TransactionRegister
//
//  Created by Eric Romrell on 9/4/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Error : NSObject

@property (nonatomic) NSError *error;
@property (nonatomic) NSString *readableMessage;
@property (nonatomic) NSString *debugMessage;

@end
