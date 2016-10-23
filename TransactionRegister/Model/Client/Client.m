//
//  Client.m
//  TransactionRegister
//
//  Created by Eric Romrell on 9/4/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import "Client.h"

#define BASE_URL @"https://transaction-register.herokuapp.com"

@implementation Client

+(void)getAllCurrentCategoriesWithCallback:(void (^)(NSArray<Category *> *categories))callback {
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"'month='MM'&year='YYYY"];

	NSString *url = [NSString stringWithFormat:@"%@/categories?%@", BASE_URL, [format stringFromDate:[NSDate date]]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	
	[[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			if (error || ((NSHTTPURLResponse *) response).statusCode != 200) {
				NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
				callback(nil);
			} else {
				NSArray *categoriesJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
				
				NSMutableArray<Category *> *categories = [NSMutableArray arrayWithCapacity:categoriesJson.count];
				for (NSDictionary *dict in categoriesJson) {
					[categories addObject:[Category categoryWithDictionary:dict]];
				}
				callback(categories);
			}
		}];
	}] resume];
}

+(void)getHistoryForCategoryId:(int)categoryId withCallback:(void (^)(NSArray<Category *> *history))callback {
	callback([NSArray arrayWithObjects:
			  [Category categoryWithDictionary:
			   @{@"categoryId": @"1", @"name": @"Food", @"amountSpent": @"684.30", @"amountLeft": @"-184.30", @"amountBudgeted": @"500"}],
			  [Category categoryWithDictionary:
			   @{@"categoryId": @"2", @"name": @"Misc", @"amountSpent": @"447.42", @"amountLeft": @"-97.42", @"amountBudgeted": @"350"}],
			  [Category categoryWithDictionary:
			   @{@"categoryId": @"3", @"name": @"Date", @"amountSpent": @"131.94", @"amountLeft": @"18.06", @"amountBudgeted": @"150"}],
			  [Category categoryWithDictionary:
			   @{@"categoryId": @"4", @"name": @"Rent", @"amountSpent": @"940.00", @"amountLeft": @"0.00", @"amountBudgeted": @"940"}],
			  [Category categoryWithDictionary:
			   @{@"categoryId": @"5", @"name": @"Gas", @"amountSpent": @"76.80", @"amountLeft": @"3.20", @"amountBudgeted": @"80"}],
			  [Category categoryWithDictionary:
			   @{@"categoryId": @"6", @"name": @"Utilities", @"amountSpent": @"0.00", @"amountLeft": @"100.00", @"amountBudgeted": @"100"}],
			  [Category categoryWithDictionary:
			   @{@"categoryId": @"7", @"name": @"Insurance", @"amountSpent": @"98.41", @"amountLeft": @"0.00", @"amountBudgeted": @"98.41"}],
			  [Category categoryWithDictionary:
			   @{@"categoryId": @"8", @"name": @"Jessica Clothes", @"amountSpent": @"69.48", @"amountLeft": @"-19.48", @"amountBudgeted": @"50"}],
			  [Category categoryWithDictionary:
			   @{@"categoryId": @"9", @"name": @"Tithing/Offerings", @"amountSpent": @"586.56", @"amountLeft": @"3.44", @"amountBudgeted": @"590"}],
			  nil]);
}

@end
