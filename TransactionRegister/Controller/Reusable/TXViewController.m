//
//  TXViewController.m
//  TransactionRegister
//
//  Created by Eric Romrell on 10/26/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import "TXViewController.h"

@implementation TXViewController

-(void)showError:(TXError *)error {
	[self showError:error withCallback:^(UIAlertAction *alert) {
		[self.navigationController popViewControllerAnimated:YES];
	}];
}

-(void)showError:(TXError *)error withCallback:(void (^)(UIAlertAction *))callback {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.readableMessage preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:callback]];
	[self presentViewController:alert animated:YES completion:nil];
}

@end
