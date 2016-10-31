//
//  AddTransactionPopUpViewController.h
//  TransactionRegister
//
//  Created by Eric Romrell on 10/27/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import "TXViewController.h"
#import "Transaction.h"

@class AddTransactionPopUpViewController;

@protocol PopUpDelegate

-(void)popUpDismissedWithChanges:(BOOL)changes;

@end

@interface AddTransactionPopUpViewController : TXViewController

@property (nonatomic) id<PopUpDelegate> delegate;
@property (nonatomic) PaymentType defaultPaymentType;

@end
