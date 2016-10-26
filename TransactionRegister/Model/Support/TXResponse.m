//
//  TXResponse.m
//  TransactionRegister
//
//  Created by Eric Romrell on 10/24/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import "TXResponse.h"

@implementation TXResponse

+(TXResponse *)responseWithData:(NSData *)data response:(NSHTTPURLResponse *)response andError:(NSError *)error {
	TXResponse *me = [[self alloc] init];
	me.data = data;
	me.response = response;
	me.error = [me getErrorWithError:error];
	return me;
}

+(TXResponse *)responseWithError:(TXError *)byuError {
	TXResponse *me = [[self alloc] init];
	me.error = byuError;
	return me;
}

-(BOOL)failed {
	return self.error || self.response.statusCode >= 300;
}

-(TXError *)getErrorWithError:(NSError *)error {
	if ([self failed]) {
		NSString *readableMessage = [self getReadableErrorMessage];
		if (readableMessage) {
			return [TXError errorWithError:error readableMessage:readableMessage andDebugMessage:nil];
		} else {
			return [TXError errorWithError:error readableMessage:@"The server encountered an error. Please try again later." andDebugMessage:[self getDataString]];
		}
	}
	return nil;
}

-(NSString *)getReadableErrorMessage {
	//If there is no path, stop
	id json = [self getDataJson];
	
	//If the json isn't a dictionary, stop
	if ([json isKindOfClass:[NSDictionary class]]) {
		id value = (NSDictionary *) json[@"message"];
		
		//If the value of the dictionary[path] is nil or isn't a string, stop
		if (value && [value isKindOfClass:[NSString class]]) {
			return (NSString *)value;
		}
	}
	return nil;
}

-(NSString *)getDataString {
	return [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
}

-(id)getDataJson {
	return self.data != nil ? [NSJSONSerialization JSONObjectWithData:self.data options:0 error:nil] : nil;
}

-(void)logError {
	NSLog(@"Error: %@", self.error);
	NSLog(@"Response: %@", [self getDataString]);
}

-(NSString *)description {
	return [NSString stringWithFormat:@"%i %@", (int) self.response.statusCode, [self getDataString]];
}


@end
