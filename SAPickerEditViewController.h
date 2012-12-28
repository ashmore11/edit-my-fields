//
//  SAPickerEditViewController.h
//  EditMyFields
//
//  Created by Scott Ashmore on 12-02-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAEditViewController.h"

@interface SAPickerEditViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) SARow *myRow;
@property (strong, nonatomic) IBOutlet UIPickerView *myPicker;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) UITextField *cellTextField;
@property (strong, nonatomic) NSString *pickerString;
@property (strong, nonatomic) SAEditViewController *parent;
@property (nonatomic) float pickerWidth;
@property (nonatomic) CGRect pickerRect;

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end
