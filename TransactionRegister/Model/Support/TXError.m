//
//  Error.m
//  TransactionRegister
//
//  Created by Eric Romrell on 9/4/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import "TXError.h"

@implementation TXError

+(TXError *)errorWithError:(NSError *)error readableMessage:(NSString *)readableMessage andDebugMessage:(NSString *)debugMessage {
	TXError *me = [[self alloc] init];
	me.error = error;
	me.readableMessage = readableMessage;
	me.debugMessage = debugMessage;
	return me;
}

-(NSString *)description {
	return [NSString stringWithFormat:@"Error: %@\nReadable Message: %@\nDebug Message: %@", self.error, self.readableMessage, self.debugMessage];
}

@end
