//
//  ViewController.h
//  EditMyFields
//
//  Created by Scott Ashmore on 12-01-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAEditViewController.h"

@interface ViewController : UIViewController <SAEditProtocol>

@property (strong, nonatomic) SAEditViewController *myTableEdit;

- (IBAction)showMyLocation:(id)sender;
- (IBAction)myHomePage:(id)sender;
- (IBAction)myPhotoPicker:(id)sender;
- (IBAction)mySalesVSProfit:(id)sender;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *processFields;
- (IBAction)doEditFields:(id)sender;
- (IBAction)displayChart:(id)sender;
@end
