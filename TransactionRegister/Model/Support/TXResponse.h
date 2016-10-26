//
//  TXResponse.h
//  TransactionRegister
//
//  Created by Eric Romrell on 10/24/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXError.h"

@interface TXResponse : NSObject

@property (nonatomic) NSData *data;
@property (nonatomic) NSHTTPURLResponse *response;
@property (nonatomic) TXError *error;

+(TXResponse *)responseWithData:(NSData *)data response:(NSHTTPURLResponse *)response andError:(NSError *)error;
+(TXResponse *)responseWithError:(TXError *)byuError;

-(BOOL)failed;
-(NSString *)getDataString;
-(id)getDataJson;
-(void)logError;

@end
