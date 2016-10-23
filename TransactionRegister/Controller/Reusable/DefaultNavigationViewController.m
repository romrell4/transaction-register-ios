//
//  DefaultNavigationViewController.m
//  TransactionRegister
//
//  Created by Eric Romrell on 9/4/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import "DefaultNavigationViewController.h"
#import "UIColor+colors.h"

@interface DefaultNavigationViewController ()

@end

@implementation DefaultNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationBar.translucent = NO;
	self.navigationBar.barTintColor = [UIColor navBarColor];
	self.navigationBar.tintColor = [UIColor navBarTintColor];
	self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
}

@end
