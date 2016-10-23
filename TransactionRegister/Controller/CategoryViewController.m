//
//  CategoryViewController.m
//  TransactionRegister
//
//  Created by Eric Romrell on 9/5/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import "CategoryViewController.h"
#import "Client.h"

@interface CategoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray<Category *> *history;

@end

@implementation CategoryViewController

-(void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = self.category.name;
	
//	self.history = [Client ]
}

#pragma mark UITableViewDataSource/Delegate callbacks

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.history.count;
}


@end
