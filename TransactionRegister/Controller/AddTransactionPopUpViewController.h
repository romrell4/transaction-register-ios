//
//  AddTransactionPopUpViewController.h
//  TransactionRegister
//
//  Created by Eric Romrell on 10/27/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import "TXViewController.h"

@class AddTransactionPopUpViewController;

@protocol PopUpDelegate

-(void)popUpDismissed;

@end

@interface AddTransactionPopUpViewController : TXViewController

@property (nonatomic) id<PopUpDelegate> delegate;

@end
