//
//  TXViewController.h
//  TransactionRegister
//
//  Created by Eric Romrell on 10/26/16.
//  Copyright © 2016 Eric Romrell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXError.h"

@interface TXViewController : UIViewController

-(void)showError:(TXError *)error;

@end
