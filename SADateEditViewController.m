//
//  SADateEditViewController.m
//  EditMyFields
//
//  Created by Scott Ashmore on 12-02-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SADateEditViewController.h"

@implementation SADateEditViewController

@synthesize myRow;
@synthesize myDate;
@synthesize myTableView;
@synthesize cellTextField;
@synthesize dateString;
@synthesize parent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d MMM yyyy"];
    NSDate *date = [formatter dateFromString:myRow.myData];
    self.myDate.date = date;
    dateString = myRow.myData;
    
    // Add Cancel and Done buttons
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    //self.navigationItem.hidesBackButton = YES;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return @"   ";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 100, 25)];
        label.textAlignment = UITextAlignmentLeft;
        label.font = [UIFont boldSystemFontOfSize:14];;
        label.text = myRow.myLabel;
        label.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:label];
        
        cellTextField = [[UITextField alloc]initWithFrame:CGRectMake(150, 12, 200, 25)];
        cellTextField.clearsOnBeginEditing = NO;
        cellTextField.tag = myRow.fieldTag;
        cellTextField.enabled = NO;;
        cellTextField.text = dateString;
        [cell.contentView addSubview:cellTextField];
    }
    else {
        cellTextField.text = dateString;
    }
    return cell;
}

- (IBAction)dateValueChanged:(id)sender
{
    NSDate *date = myDate.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d MMM yyyy"];
    dateString = [formatter stringFromDate:date];
    [myTableView reloadData];

}

- (IBAction)doneButtonPressed:(id)sender;
{
    NSDate *date = myDate.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d MMM yyyy"];
    myRow.myData = [formatter stringFromDate:date];
    [self.navigationController popViewControllerAnimated:YES];
    [parent.tableView reloadData];
}

- (IBAction)cancelButtonPressed:(id)sender;
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
