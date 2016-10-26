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
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.readableMessage preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil]];
	[self presentViewController:alert animated:YES completion:nil];
}

@end
