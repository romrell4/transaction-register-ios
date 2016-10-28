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
	
	self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTransaction)];
	
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:ADD_TX_ID]) {
		AddTransactionPopUpViewController *vc = segue.destinationViewController;
		vc.delegate = self;
		vc.providesPresentationContextTransitionStyle = YES;
		vc.definesPresentationContext = YES;
	}
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

#pragma mark PopUpDelegate callback

-(void)popUpDismissed {
	[self.navBarShade removeFromSuperview];
	[self.backgroundShade removeFromSuperview];
}

#pragma mark Custom Functions

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

@end
