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
@property (nonatomic) int countdown;
@property (nonatomic) NSArray<PaymentTypeSum *> *sums;
@property (nonatomic) PaymentType *currentFilter;

@end

@implementation TransactionsViewController

-(void)viewDidLoad {
    [super viewDidLoad];
	
	self.currentFilter = nil;
	
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
		vc.defaultPaymentType = self.currentFilter;
	}
}

#pragma mark UITableViewDataSource/Delegate callbacks

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [NSString stringWithFormat:@"%@ Account Transactions", self.currentFilter ? self.currentFilter.prettyType : @"All"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger count = self.transactions.count;
	self.tableView.tableFooterView.hidden = count != 0;
	return count;
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
	for (PaymentTypeSum *sum in self.sums) {
		NSString *title = sum.paymentType.prettyType;
		[controller addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			self.currentFilter = sum.paymentType;
			[self loadData];
		}]];
	}
	[controller addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
	
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
	//Make the "Add" and "Filter" not clickable while loading data
	self.tabBarController.navigationItem.leftBarButtonItem.enabled = NO;
	self.tabBarController.navigationItem.rightBarButtonItem.enabled = NO;
	[self.spinner startAnimating];
	
	[self loadTransactionsForDate:[NSDate date]];
	
	[self loadSums];
}

-(void)loadTransactionsForDate:(NSDate *)date {
	self.countdown++;
	[Client getAllTransactionsForDate:(NSDate *)date withPaymentType:self.currentFilter withCallback:^(NSArray<Transaction *> *transactions, TXError *error) {
		if (error) {
			[self showError:error];
		} else {
			if (transactions.count == 0) {
				NSDateComponents *comp = [[NSDateComponents alloc] init];
				[comp setMonth:-1];
				NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:comp toDate:date options:0];
				[self loadTransactionsForDate:newDate];
			} else {
				self.transactions = transactions;
				[self.tableView reloadData];
			}
		}
		[self decrementCountdown];
	}];
}

-(void)loadSums {
	self.countdown++;
	[Client getPaymentTypeSumsWithCallback:^(NSArray<PaymentTypeSum *> *sums, TXError *error) {
		[self decrementCountdown];
		if (error) {
			[self showError:error];
		} else {
			self.sums = sums;
		}
	}];
}

-(void)decrementCountdown {
	if (--self.countdown == 0) {
		[self.spinner stopAnimating];
		self.tabBarController.navigationItem.leftBarButtonItem.enabled = YES;
		self.tabBarController.navigationItem.rightBarButtonItem.enabled = YES;
	}
}

@end
