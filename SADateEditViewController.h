//
//  SADateEditViewController.h
//  EditMyFields
//
//  Created by Scott Ashmore on 12-02-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SARow.h"
#import "SAEditViewController.h"


@interface SADateEditViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) SARow *myRow;
@property (strong, nonatomic) IBOutlet UIDatePicker *myDate;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) UITextField *cellTextField;
@property (strong, nonatomic) NSString *dateString;
@property (strong, nonatomic) SAEditViewController *parent;
- (IBAction)dateValueChanged:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end
