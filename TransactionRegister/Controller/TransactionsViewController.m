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
#import "AddTransactionPopUpViewController.h"

#define ADD_TX_ID @"addTransaction"

@interface TransactionsViewController () <UITableViewDataSource, UITableViewDelegate, PopUpDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet TXTableView *tableView;

@property (nonatomic) NSArray<Transaction *> *transactions;
@property (nonatomic) UIView *navBarShade;
@property (nonatomic) UIView *backgroundShade;
@property (nonatomic) NSDictionary *currentFilter;

@end

@implementation TransactionsViewController

-(void)viewDidLoad {
    [super viewDidLoad];
	
	self.currentFilter = @{@"name": @"All", @"enum": @(NONE)};
	
	[self loadData];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTransaction)];
	self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filter)];
	
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:ADD_TX_ID]) {
		AddTransactionPopUpViewController *vc = segue.destinationViewController;
		vc.delegate = self;
		vc.defaultPaymentType = [self.currentFilter[@"enum"] intValue];
		vc.providesPresentationContextTransitionStyle = YES;
		vc.definesPresentationContext = YES;
	}
}

#pragma mark UITableViewDataSource/Delegate callbacks

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [NSString stringWithFormat:@"%@ Account Transactions", self.currentFilter[@"name"]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.transactions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Transaction *tx = self.transactions[indexPath.row];

	TransactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	cell.transaction = tx;
	return cell;
}

#pragma mark PopUpDelegate callback

-(void)popUpDismissedWithChanges:(BOOL)changes {
	[self.navBarShade removeFromSuperview];
	[self.backgroundShade removeFromSuperview];
	
	if (changes) {
		[self loadData];
	}
}

#pragma mark Custom Functions

-(void)filter {
	UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"What account would you like to filter by?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	[controller addAction:[UIAlertAction actionWithTitle:@"Credit Card" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		self.currentFilter = @{@"name": @"Credit Card", @"enum": @(CREDIT)};
		[self loadData];
	}]];
	
	[controller addAction:[UIAlertAction actionWithTitle:@"Checking" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		self.currentFilter = @{@"name": @"Checking", @"enum": @(DEBIT)};
		[self loadData];
	}]];
	[controller addAction:[UIAlertAction actionWithTitle:@"Savings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		self.currentFilter = @{@"name": @"Savings", @"enum": @(SAVINGS)};
		[self loadData];
	}]];
	[controller addAction:[UIAlertAction actionWithTitle:@"Permanent Savings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		self.currentFilter = @{@"name": @"Permanent Savings", @"enum": @(PERMANENT_SAVINGS)};
		[self loadData];
	}]];
	[self presentViewController:controller animated:YES completion:nil];
}

-(void)addTransaction {	
	//Make main navBar faded
	self.navBarShade = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height + 20)];
	self.navBarShade.backgroundColor = [UIColor blackColor];
	self.navBarShade.alpha = 0.5f;
	[self.navigationController.navigationBar addSubview:self.navBarShade];
	
	//Make main view faded
	self.backgroundShade = [[UIView alloc] initWithFrame:self.view.frame];
	self.backgroundShade.backgroundColor = [UIColor blackColor];
	self.backgroundShade.alpha = 0.5f;
	[self.view addSubview:self.backgroundShade];
	
	[self performSegueWithIdentifier:ADD_TX_ID sender:self];
}

-(void)loadData {
	[self.spinner startAnimating];
	[Client getAllTransactionsWithPaymentType:[self.currentFilter[@"enum"] intValue] withCallback:^(NSArray<Transaction *> *transactions, TXError *error) {
		[self.spinner stopAnimating];
		if (error) {
			[self showError:error];
		} else {
			self.transactions = transactions;
			[self.tableView reloadData];
		}
	}];
}

@end
