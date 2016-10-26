//
//  CategoryViewController.m
//  TransactionRegister
//
//  Created by Eric Romrell on 9/5/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import "CategoryViewController.h"
#import "Client.h"
#import "TXTableView.h"
#import "CategoryTableViewCell.h"

@interface CategoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet TXTableView *tableView;

@property (nonatomic) NSArray<Category *> *history;

@end

@implementation CategoryViewController

-(void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = self.category.name;
	
	[self.spinner startAnimating];
	[Client getHistoryForCategoryId:self.category.categoryId withCallback:^(NSArray<Category *> *history, TXError *error) {
		[self.spinner stopAnimating];
		if (error) {
			[self showError:error];
		} else {
			self.history = history;
			[self.tableView reloadData];
		}
	}];
}

#pragma mark UITableViewDataSource/Delegate callbacks

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.history.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	[cell setCategory:self.history[indexPath.row] withMainProperty:MONTH];
	return cell;
}


@end
