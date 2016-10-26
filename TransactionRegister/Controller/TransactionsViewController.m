//
//  TransactionsViewController.m
//  TransactionRegister
//
//  Created by Eric Romrell on 10/24/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import "TransactionsViewController.h"
#import "Client.h"
#import "TXTableView.h"
#import "TransactionTableViewCell.h"

@interface TransactionsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet TXTableView *tableView;

@property (nonatomic) NSArray<Transaction *> *transactions;

@end

@implementation TransactionsViewController

-(void)viewDidLoad {
    [super viewDidLoad];

	[self.spinner startAnimating];
	[Client getAllTransactionsThisMonthWithCallback:^(NSArray<Transaction *> *transactions, TXError *error) {
		[self.spinner stopAnimating];
		if (error) {
			[self showError:error];
		} else {
			self.transactions = transactions;
			[self.tableView reloadData];
		}
	}];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus"] style:UIBarButtonItemStylePlain target:self action:@selector(addTransaction)];
	
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark UITableViewDataSource/Delegate callbacks

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.transactions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Transaction *tx = self.transactions[indexPath.row];

	TransactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	cell.transaction = tx;
	return cell;
}

#pragma mark Custom Functions

-(void)addTransaction {
	//TODO: Add transaction
	NSLog(@"Adding transaction!");
}

@end
