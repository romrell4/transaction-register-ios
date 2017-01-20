//
//  ViewController.m
//  TransactionRegister
//
//  Created by Eric Romrell on 9/4/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import "CategoriesViewController.h"
#import "TXTableView.h"
#import "CategoryTableViewCell.h"
#import "CategoryViewController.h"

#define MONTHS_TO_SHOW 6

@interface CategoriesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet TXTableView *tableView;

@property (nonatomic) NSArray<BudgetCategory *> *categories;
@property (nonatomic) NSMutableArray<NSDate *> *filterDates;
@property (nonatomic) NSDate *currentFilterDate;

@end

@implementation CategoriesViewController

-(void)viewDidLoad {
	[super viewDidLoad];
	
	NSDate *today = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *comp = [[NSDateComponents alloc] init];
	self.filterDates = [[NSMutableArray alloc] init];
	for (int i = 0; i <= MONTHS_TO_SHOW; i++) {
		[comp setMonth:-i];
		[self.filterDates addObject:[calendar dateByAddingComponents:comp toDate:today options:0]];
	}
	self.currentFilterDate = self.filterDates[0];
	
	[self loadDataWithDate:[NSDate date]];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filter)];
	self.tabBarController.navigationItem.rightBarButtonItem = nil;
	
	[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"category"]) {
		CategoryViewController *vc = segue.destinationViewController;
		vc.category = self.categories[[self.tableView indexPathForCell:sender].row];
	}
}

#pragma mark UITableViewDataSource/Delegate callbacks

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MMM YYYY"];
	return [NSString stringWithFormat:@"Budget - %@", [format stringFromDate:self.currentFilterDate]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.categories.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	[cell setCategory:self.categories[indexPath.row] withMainProperty:CATEGORY_NAME];
	return cell;
}

#pragma mark Custom Functions

-(void)filter {
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MMMM YYYY"];

	UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Select Month" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	for (NSDate *date in self.filterDates) {
		[controller addAction:[UIAlertAction actionWithTitle:[format stringFromDate:date] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			[self loadDataWithDate:date];
		}]];
	}
	[controller addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
	[self presentViewController:controller animated:YES completion:nil];
}

-(void)loadDataWithDate:(NSDate *)date {
	[self.spinner startAnimating];
	[Client getBudgetWithDate:date callback:^(NSArray<BudgetCategory *> * _Nullable categories, TXError * _Nullable error) {
		[self.spinner stopAnimating];
		if (error) {
			[self showError:error];
		} else {
			self.currentFilterDate = date;
			self.categories = categories;
			[self.tableView reloadData];
		}
	}];
}

@end
