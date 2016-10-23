//
//  Client.h
//  TransactionRegister
//
//  Created by Eric Romrell on 9/4/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Category.h"
#import "Error.h"

#define DEFAULT_ERROR_MESSAGE @"There was an error loading the data from the service. Please talk to your husband about it. :)"

@interface Client : NSObject

+(void)getAllCurrentCategoriesWithCallback:(void (^)(NSArray<Category *> *categories))callback;
+(void)getHistoryForCategoryId:(int)categoryId withCallback:(void (^)(NSArray<Category *> *history))callback;

@end
