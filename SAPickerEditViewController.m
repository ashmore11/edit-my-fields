//
//  SAPickerEditViewController.m
//  EditMyFields
//
//  Created by Scott Ashmore on 12-02-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SAPickerEditViewController.h"

@implementation SAPickerEditViewController

@synthesize myRow;
@synthesize myPicker;
@synthesize myTableView;
@synthesize cellTextField;
@synthesize pickerString;
@synthesize parent;
@synthesize pickerWidth;
@synthesize pickerRect;

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
    self.title = myRow.myLabel;
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];

    pickerString = myRow.myData;
    __block NSInteger row = -1;
    [myRow.options enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) 
    {
        NSString *strName = obj; 
        if ([strName isEqualToString:pickerString]) 
        {
            row = idx;
            *stop = TRUE;
        }
    }];
    pickerWidth = self.view.bounds.size.width -100;
    pickerRect = myPicker.frame;
    if (row != -1)
        [myPicker selectRow:row inComponent:0 animated:YES];
    else
        [myPicker selectRow:[myRow.options count]/2 inComponent:0 animated:NO];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewWillAppear:(BOOL)animated
{
    //self.navigationItem.hidesBackButton = YES;
    [super viewWillAppear:animated];
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
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 100, 25)];
        label.textAlignment = UITextAlignmentLeft;
        label.font = [UIFont boldSystemFontOfSize:14];;
        label.text = myRow.myLabel;
        label.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:label];
        
        cellTextField = [[UITextField alloc]initWithFrame:CGRectMake(150, 12, 200, 25)];
        cellTextField.clearsOnBeginEditing = NO;
        cellTextField.tag = myRow.fieldTag;
        cellTextField.enabled = NO;;
        cellTextField.text = pickerString;
        [cell.contentView addSubview:cellTextField];
    }
    else {
        cellTextField.text = pickerString;
    }
    return cell;
}

- (IBAction)doneButtonPressed:(id)sender;
{
    NSInteger row = [myPicker selectedRowInComponent:0];
    pickerString = [myRow.options objectAtIndex:row];

    myRow.myData = pickerString;
    [self.navigationController popViewControllerAnimated:YES];
    [parent.tableView reloadData];
}

- (IBAction)cancelButtonPressed:(id)sender;
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.myRow.options count];
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.myRow.options objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    pickerString = [myRow.options objectAtIndex:row];
    [myTableView reloadData];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return pickerWidth;
}

- (void)deviceOrientationDidChange:(NSNotification *)notification 
{
    //Obtain the current device orientation
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if(orientation == UIInterfaceOrientationPortraitUpsideDown)
        return;
    switch (orientation) 
    {
        case UIDeviceOrientationPortrait: 
        case UIDeviceOrientationPortraitUpsideDown: 
          //  myPicker.transform = CGAffineTransformIdentity;
            [myPicker setFrame:pickerRect];
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
        {
            //[myPicker setFrame:CGRectMake(0, containerView.bounds.size.height/4+25, containerView.bounds.size.width, (containerView.bounds.size.height/4) *3)];
            [myPicker setFrame:CGRectMake(0, 120, self.view.bounds.size.width, 150)];
/*           
            CGAffineTransform t0 = CGAffineTransformMakeTranslation (0, (myPicker.bounds.size.height/4) *1 );
            CGAffineTransform s0 = CGAffineTransformMakeScale       (1.0, 0.75);
            myPicker.transform = CGAffineTransformConcat          (t0, s0);
 */
            break;
        }
        default:break;
    }
}

@end
