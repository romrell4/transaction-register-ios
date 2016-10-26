//
//  TXTableView.m
//  TransactionRegister
//
//  Created by Eric Romrell on 10/25/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import "TXTableView.h"

@implementation TXTableView

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	self.tableFooterView = [[UIView alloc] init];
	return self;
}

@end
