//
//  AddTransactionPopUpViewController.m
//  TransactionRegister
//
//  Created by Eric Romrell on 10/27/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import "AddTransactionPopUpViewController.h"
#import "Client.h"
#import "TransactionRegister-Swift.h"

#define TOOLBAR_HEIGHT 44

@interface AddTransactionPopUpViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomContraint;
@property (weak, nonatomic) IBOutlet UISegmentedControl *paymentTypeControl;
@property (weak, nonatomic) IBOutlet UITextField *businessField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *amountField;
@property (weak, nonatomic) IBOutlet UITextField *categoryField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;

@property (nonatomic) NSArray<BudgetCategory *> *categories;
@property (nonatomic) int selectedCategoryId;
@property (nonatomic) NSDate *purchaseDate;

@property (nonatomic) UITextField *selectedField;

@end

@implementation AddTransactionPopUpViewController

-(void)viewDidLoad {
    [super viewDidLoad];
	
	if (self.transaction) {
		NSDateFormatter *dateFormat = [NSDateFormatter new];
		[dateFormat setDateFormat:@"MM/dd/yyyy"];
	
		self.businessField.text = self.transaction.business;
		self.dateField.text = [dateFormat stringFromDate:self.transaction.purchaseDate];
		self.purchaseDate = self.transaction.purchaseDate;
		self.amountField.text = [NSString stringWithFormat:@"%.2f", self.transaction.amount.value];
		self.categoryField.text = self.transaction.categoryName;
		self.selectedCategoryId = self.transaction.categoryId;
		self.descriptionField.text = self.transaction.desc;
	}
	
	//Load the picker values from the web service
	[Client getAllActiveCategoriesWithCallback:^(NSArray<BudgetCategory *> *categories, TXError *error) {
		if (error) {
			[self showError:error];
		} else {
			self.categories = categories;
			[((UIPickerView *)self.categoryField.inputView) reloadAllComponents];
		}
	}];
	
	//Listen for when the keyboard enters and exits the screen
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardFrameEndUserInfoKey object:nil];
	
	//If there is a default, select it. Otherwise default to the first one
	self.paymentTypeControl.selectedSegmentIndex = self.defaultPaymentType ? [self.defaultPaymentType orderIndex] : 0;
	
	//Setup a special date picker for the keyboard
	UIDatePicker *datePicker = [[UIDatePicker alloc] init];
	[datePicker setDatePickerMode:UIDatePickerModeDate];
	[datePicker addTarget:self action:@selector(dateUpdated:) forControlEvents:UIControlEventValueChanged];
	self.dateField.inputView = datePicker;
	
	//Setup a custom picker view for the categories
	UIPickerView *categoryPicker = [[UIPickerView alloc] init];
	categoryPicker.delegate = self;
	categoryPicker.dataSource = self;
	self.categoryField.inputView = categoryPicker;
	
	//Put toolbars on top of each of the non keyboard fields
	UIToolbar *toolbar = [self createNextToolbarWithNegative:NO];
	self.dateField.inputAccessoryView = toolbar;
	self.categoryField.inputAccessoryView = toolbar;
	
	UIToolbar *amountToolbar = [self createNextToolbarWithNegative:YES];
	self.amountField.inputAccessoryView = amountToolbar;
}

-(UIToolbar *)createNextToolbarWithNegative:(BOOL)negative {
	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, TOOLBAR_HEIGHT)];
	UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextTapped)];
	toolbar.backgroundColor = [UIColor grayColor];
	if (negative) {
		UIBarButtonItem *plusMinusButton = [[UIBarButtonItem alloc] initWithTitle:@"+/-" style:UIBarButtonItemStylePlain target:self action:@selector(togglePositiveNegative)];
		toolbar.items = @[plusMinusButton, flexSpace, nextButton];
	} else {
		toolbar.items = @[flexSpace, nextButton];
	}
	return toolbar;
}

#pragma mark UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField {
	self.selectedField = textField;
	
	//If it's a picker field, set the text when it is first clicked
	if (textField == self.dateField) {
		self.purchaseDate = [NSDate date];
	
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"MM/dd/yyyy"];
		textField.text = [format stringFromDate:self.purchaseDate];
	} else if (textField == self.categoryField) {
		self.selectedCategoryId = self.categories[0].categoryId;
		textField.text = self.categories[0].name;
	}
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
	if ([textField.text isEqualToString:@""] && textField != self.descriptionField) {
		textField.layer.borderColor = [[UIColor redColor] CGColor];
		textField.layer.borderWidth = 1;
	} else {
		textField.layer.borderWidth = 0;
	}
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	NSInteger nextTag = textField.tag + 1;
	UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
	
	if (nextResponder) {
		[nextResponder becomeFirstResponder];
	} else {
		[textField resignFirstResponder];
		
		[self saveTapped:nil];
	}
	return NO;
}

#pragma mark UIPickerViewDataSource/Delegate callbacks

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return self.categories.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return self.categories[row].name;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.selectedCategoryId = self.categories[row].categoryId;
	self.categoryField.text = self.categories[row].name;
}

#pragma mark Custom Functions

-(void)nextTapped {
	[self textFieldShouldReturn:self.selectedField];
}

-(void)togglePositiveNegative {
	if ([self.amountField.text rangeOfString:@"-"].location == NSNotFound) {
		self.amountField.text = [@"-" stringByAppendingString:self.amountField.text];
	} else {
		self.amountField.text = [self.amountField.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
	}
}

-(void)dateUpdated:(UIDatePicker *)picker {
	self.purchaseDate = picker.date;

	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MM/dd/yyyy"];
	self.dateField.text = [format stringFromDate:picker.date];
}

-(IBAction)saveTapped:(id)sender {
	@try {
		Transaction *newTx = [self getTransactionIfValid];
		[self.spinner startAnimating];
		void (^callback)() = ^(Transaction *tx, TXError *error) {
			[self.spinner stopAnimating];
			if (error) {
				[self showError:error];
			} else {
				[self dismissPopUpWithChanges:YES];
			}
		};
		if (self.transaction) {
			[Client editTransaction:self.transaction.transactionId withTransaction:newTx andCallback:callback];
		} else {
			[Client createTransaction:newTx withCallback:callback];
		}
	} @catch (NSException *exception) {
		NSArray<UITextField *> *errorFields = exception.userInfo[@"errorFields"];
		for (UITextField *field in errorFields) {
			field.layer.borderColor = [[UIColor redColor] CGColor];
			field.layer.borderWidth = 1.0f;
		}
	}
}

-(Transaction *)getTransactionIfValid {
	NSMutableArray<UITextField *> *errorFields = [NSMutableArray array];
	
	Transaction *tx = [[Transaction alloc] init];
	tx.paymentType = [[PaymentType alloc] initWithIndex:self.paymentTypeControl.selectedSegmentIndex];
	if (![self.businessField.text isEqualToString:@""]) {
		tx.business = self.businessField.text;
	} else {
		[errorFields addObject:self.businessField];
	}
	
	if (self.purchaseDate) {
		tx.purchaseDate = self.purchaseDate;
	} else {
		[errorFields addObject:self.dateField];
	}
	
	if (![self.amountField.text isEqualToString:@""]) {
		tx.amount = [[Amount alloc] initWithValue:[self.amountField.text doubleValue]];
	} else {
		[errorFields addObject:self.amountField];
	}
	
	if (self.selectedCategoryId) {
		tx.categoryId = self.selectedCategoryId;
	} else {
		[errorFields addObject:self.categoryField];
	}
	tx.desc = self.descriptionField.text;
	
	if (errorFields.count != 0) {
		@throw [NSException exceptionWithName:NSInvalidArgumentException reason:nil userInfo:@{@"errorFields": errorFields}];
	}
	return tx;
}

-(IBAction)cancelTapped:(id)sender {
	[self dismissPopUpWithChanges:NO];
}

-(void)dismissPopUpWithChanges:(BOOL)changes {
	[self.delegate popUpDismissedWithChanges:changes];
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)keyboardWillShow:(NSNotification *)notification {
	self.bottomContraint.constant = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
}

-(void)keyboardWillHide:(NSNotification *)notification {
	self.bottomContraint.constant = 0;
}

@end
