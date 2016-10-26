//
//  ViewController.m
//  TransactionRegister
//
//  Created by Eric Romrell on 9/4/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import "CategoriesViewController.h"
#import "TXTableView.h"
#import "Client.h"
#import "CategoryTableViewCell.h"
#import "CategoryViewController.h"

@interface CategoriesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet TXTableView *tableView;

@property (nonatomic) NSArray<Category *> *categories;

@end

@implementation CategoriesViewController

-(void)viewDidLoad {
	[super viewDidLoad];
	
	[self.spinner startAnimating];
	[Client getAllCurrentCategoriesWithCallback:^(NSArray<Category *> *categories, TXError *error) {
		[self.spinner stopAnimating];
		if (error) {
			[self showError:error];
		} else {
			self.categories = categories;
			[self.tableView reloadData];
		}
	}];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
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
	return [NSString stringWithFormat:@"Budget - %@", [format stringFromDate:[NSDate date]]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.categories.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	[cell setCategory:self.categories[indexPath.row] withMainProperty:CATEGORY_NAME];
	return cell;
}

@end
