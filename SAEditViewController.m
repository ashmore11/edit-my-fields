//
//  SAEditViewController.m
//  EditMyFields
//
//  Created by Bob Ashmore on 30/01/2012.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "SAEditViewController.h"
#import "SADateEditViewController.h"
#import "SAPickerEditViewController.h"
#import "SAMapViewController.h"
#import "SAImagePickerController.h"
#import "SAWebViewController.h"
#import "SAChartController.h"

#define NAVBARHEIGHT 44
#define SectionHeaderHeight 40

@implementation SAEditViewController
@synthesize headerText;
@synthesize mySecionArray;
@synthesize delegate;
@synthesize myView;
@synthesize headerTextColor;
@synthesize myNavigationController;

- (id)init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) addToView:(UIViewController *)view
{
    myView = view;
    self.myNavigationController = [[UINavigationController alloc] initWithRootViewController:self];
    self.myNavigationController.navigationBar.tintColor = [UIColor blackColor];
    self.myNavigationController.view.frame = myView.view.frame;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(pressedOK:)];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.title = self.headerText;
    
    [myView.view addSubview:myNavigationController.view];  
    
    [myView addChildViewController:myNavigationController];
    [myNavigationController didMoveToParentViewController:myView];
}


// the user has pressed the save button
- (IBAction)pressedOK:(id)sender
{
    if([self.delegate respondsToSelector:@selector(didPressOk:)])
        [delegate didPressOk:self];
}

- (SASection *) addSectionWithHeader:(NSString *) myHeader
{
    SASection *newSection = [[SASection alloc] init];
    newSection.headerText = myHeader;
    newSection.myRows = [[NSMutableArray alloc] init];
    if (mySecionArray == nil) 
        mySecionArray = [[NSMutableArray alloc] init];
    [mySecionArray addObject:newSection];
    return newSection;
}

- (void) addRowToSection:(SASection *)mySec withType:(FieldTypes)myType label:(NSString *) myLbl data:(NSString *) myDta withTag:(int)tag
{
    [mySec addRowWithType:myType label:myLbl data:myDta withTag:tag];
}

- (void) addRowToSectionWithOptions:(SASection *)mySec andType:(FieldTypes)myType label:(NSString *) myLbl data:(NSString *) myDta options:(NSArray *) myOptions withTag:(int)tag
{
    [mySec addRowWithOptionsAndType:myType label:myLbl data:myDta options:myOptions withTag:tag];
}

- (NSString *) getDataFieldForSection:(int) mySection withRow:(int) myRow
{
    return [[[mySecionArray objectAtIndex:mySection] myRows] objectAtIndex:myRow];
}

- (SARow *) getFieldForSection:(int) mySection withRow:(int) myRow
{
    return [[[mySecionArray objectAtIndex:mySection] myRows] objectAtIndex:myRow];
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
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(pressedOK:)];
    self.navigationItem.rightBarButtonItem.enabled = YES;
            
    self.title = self.headerText;
    self.navigationController.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    headerText = nil;
    mySecionArray = nil;
    delegate = nil;
    myView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [mySecionArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[mySecionArray objectAtIndex:section] headerText];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[mySecionArray objectAtIndex:section] myRows] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SARow *myRowData = [[[mySecionArray objectAtIndex:indexPath.section] myRows]objectAtIndex:indexPath.row];
    
    switch (myRowData.type) {
        case type_textGeneral:
        case type_textInteger:
        case type_textDecimal:
        case type_textPassword:
        case type_date:
        case type_picker:
        case type_location:
        case type_imagePicker:
        case type_webView:
        case type_chart:
            return [self AddGeneralTextRow:myRowData tableView:tableView];
            break;
            
        case type_switch:
            return [self AddSwitchRow:myRowData tableView:tableView];
            break;
            
        case type_slider:
            return [self AddSliderRow:myRowData tableView:tableView];
            break;
            
        case type_segmented:
            return [self AddSegmentedControlRow:myRowData tableView:tableView];
            break;
            
        default:
            break;
    }
    return nil;
}

- (UITableViewCell *)AddSwitchRow:(SARow *)myRowData tableView:(UITableView *)tableView
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellSwitch%03d", myRowData.fieldTag];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellSwitch"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 190, 25)];
        label.textAlignment = UITextAlignmentLeft;
        label.font = [UIFont boldSystemFontOfSize:14];
        label.text = myRowData.myLabel;
        label.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:label];
        UISwitch *switchField = [[UISwitch alloc]initWithFrame:CGRectMake(225, 9, 200, 25)];
        switchField.tag = myRowData.fieldTag;
        switchField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        if ([myRowData.myData isEqualToString:@"YES"]) {
            switchField.on = YES;
        }
        else {
            switchField.on = NO;            
        }
        [switchField addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        
        [cell.contentView addSubview:switchField];
    }
    else {
        for(UIView *subView in cell.contentView.subviews) {
            if([subView isMemberOfClass:[UISwitch class]]) {
                UISwitch *switchField = (UISwitch *)subView;
                if ([myRowData.myData isEqualToString:@"YES"]) {
                    switchField.on = YES;
                }
                else {
                    switchField.on = NO;            
                }
            }
        }
    }
    return cell;
}

- (UITableViewCell *)AddSliderRow:(SARow *)myRowData tableView:(UITableView *)tableView
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellSlider%03d", myRowData.fieldTag];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellSlider"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 190, 25)];
        label.textAlignment = UITextAlignmentLeft;
        label.font = [UIFont boldSystemFontOfSize:14];
        label.text = myRowData.myLabel;
        label.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:label];
        
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, 12, 220, 25)];
        [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        [slider setBackgroundColor:[UIColor clearColor]];
        slider.minimumValue = [(NSNumber *)[myRowData.options objectAtIndex:0] floatValue];
        slider.minimumValue = [(NSNumber *)[myRowData.options objectAtIndex:1] floatValue];;
        slider.continuous = YES;
        slider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        if (myRowData.myData == nil) 
        {
            slider.value = slider.minimumValue;
        }
        else 
        {
            slider.value = [myRowData.myData floatValue]; 
        }
        slider.tag = myRowData.fieldTag;
        [cell.contentView addSubview:slider];
        
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.bounds.size.width -40, 12, 30, 25)];
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.text = [NSString stringWithFormat:@"%2.0f",slider.value];
        myLabel.tag = 1999;
        myLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        myLabel.textAlignment = UITextAlignmentRight;
        [cell.contentView addSubview:myLabel];
    }    
    return cell;
}

- (IBAction)sliderChanged:(id)sender
{
    UISlider *mySlider = sender;
    UIView *contentView = mySlider.superview;
    for(UIView *subView in contentView.subviews) 
    {
        if(subView.tag == 1999) 
        {
            UILabel *label = (UILabel *)subView;
            label.text = [NSString stringWithFormat:@"%2.0f", mySlider.value];
            [self setFieldData:label.text forTag:mySlider.tag];

        }
    }    
}

- (UITableViewCell *)AddSegmentedControlRow:(SARow *)myRowData tableView:(UITableView *)tableView
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellSegmented%03d", myRowData.fieldTag];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellSegmented"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:myRowData.options];
        segControl.frame = CGRectMake(0, 0, cell.contentView.bounds.size.width, cell.contentView.bounds.size.height+1);
        [segControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [segControl addTarget:self action:@selector(segPushed:) forControlEvents:UIControlEventValueChanged];

        if (myRowData.myData != nil) 
        {
            __block NSInteger row = -1;
            [myRowData.options enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) 
             {
                 NSString *strName = obj; 
                 if ([strName isEqualToString:myRowData.myData]) 
                 {
                     row = idx;
                     *stop = TRUE;
                 }
             }];
            if (row != -1)
            {    
                segControl.selectedSegmentIndex = row;
            }
            else 
            {
                segControl.selectedSegmentIndex = UISegmentedControlNoSegment;
            }
        }
        else 
        {
            segControl.selectedSegmentIndex = UISegmentedControlNoSegment;
        }
        segControl.segmentedControlStyle = UISegmentedControlStylePlain;
        segControl.tag = myRowData.fieldTag;        
        [cell.contentView addSubview:segControl];
    }   
    return cell;
}

- (IBAction)segPushed:(id)sender
{
    UISegmentedControl *mySeg = sender;
    [self setFieldData:[mySeg titleForSegmentAtIndex:mySeg.selectedSegmentIndex] forTag:mySeg.tag];
}

- (UITableViewCell *)AddGeneralTextRow:(SARow *)myRowData tableView:(UITableView *)tableView
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellTextGeneral%03d", myRowData.fieldTag];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 100, 25)];
        label.textAlignment = UITextAlignmentLeft;
        label.font = [UIFont boldSystemFontOfSize:14];
        label.text = myRowData.myLabel;
        label.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:label];
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(106, 12, 170, 25)];
        textField.clearsOnBeginEditing = NO;
        [textField setDelegate:self];
        textField.returnKeyType = UIReturnKeyDone;
        [textField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
        textField.text = myRowData.myData;
        textField.tag = myRowData.fieldTag;
        textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        if (myRowData.type == type_textPassword) {
            textField.secureTextEntry = YES;
        }
        if (myRowData.type == type_date) {
            textField.enabled = NO;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (myRowData.type == type_picker) {
            textField.enabled = NO;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (myRowData.type == type_location) {
            textField.enabled = NO;
            textField.hidden = YES;
            label.frame = CGRectMake(10, 10, cell.contentView.bounds.size.width-50, cell.contentView.bounds.size.height - 20);
            label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (myRowData.type == type_imagePicker) {
            textField.enabled = NO;
            textField.hidden = YES;
            label.frame = CGRectMake(10, 10, cell.contentView.bounds.size.width-50, cell.contentView.bounds.size.height - 20);
            label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (myRowData.type == type_textInteger) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (myRowData.type == type_textDecimal) {
            textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
        if (myRowData.type == type_slider) {
            textField.enabled = NO;
        }
        if (myRowData.type == type_segmented) {
            textField.enabled = NO;
        }
        if (myRowData.type == type_webView) {
            textField.enabled = NO;
            textField.hidden = YES;
            label.frame = CGRectMake(10, 10, cell.contentView.bounds.size.width-50, cell.contentView.bounds.size.height - 20);
            label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (myRowData.type == type_chart) {
            textField.enabled = NO;
            textField.hidden = YES;
            label.frame = CGRectMake(10, 10, cell.contentView.bounds.size.width-50, cell.contentView.bounds.size.height - 20);
            label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        //textField.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:textField];
    }
    else {
        for(UIView *subView in cell.contentView.subviews) {
            if([subView isMemberOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)subView;
                textField.text = myRowData.myData;
            }
        }
    }

    return cell;
}

- (IBAction)textFieldDone:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)switchChanged:(id)sender
{
    UISwitch *switchField = sender;
    if (switchField.on == YES) {
        [self setFieldData:@"YES" forTag:switchField.tag];    
    }
    else 
    {
        [self setFieldData:@"NO" forTag:switchField.tag];    
    }
}

- (void) textFieldChanged:(UITextField *)textField
{
    [self setFieldData:textField.text forTag:textField.tag];
}

- (void) setFieldData:(NSString *)data forTag:(int)tag
{
    for(SASection *sec in mySecionArray) {
        for(SARow *row in sec.myRows) {
            if(row.fieldTag == tag) {
                row.myData = data;
                return;
            }
        }
    }
}

- (NSString *) getFieldDataForTag:(int)tag
{
    for(SASection *sec in mySecionArray) {
        for(SARow *row in sec.myRows) {
            if(row.fieldTag == tag) {
                return row.myData;
            }
        }
    }
    return nil;
}

- (int) getFieldTypeForTag:(int)tag
{
    for(SASection *sec in mySecionArray) {
        for(SARow *row in sec.myRows) {
            if(row.fieldTag == tag) {
                return row.type;
            }
        }
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SARow *selectedRow = [self getFieldForSection: indexPath.section withRow:indexPath.row];
    if (selectedRow.type == type_date) {
        [self pushDateView:selectedRow];
    }  
    else if (selectedRow.type == type_picker)
    {
        [self pushPickerView:selectedRow];
    }
    else if (selectedRow.type == type_location)
    {
        [self pushLocationView:selectedRow];
    }
    else if (selectedRow.type == type_imagePicker)
    {
        [self pushImagePickerView:selectedRow];
    }
    else if (selectedRow.type == type_webView)
    {
        [self pushWebView:selectedRow];
    }
    else if (selectedRow.type == type_chart)
    {
        [self pushChartView:selectedRow];
    }
}

- (void) pushDateView:(SARow *)selectedRow
{
    SADateEditViewController *dateCtl = [[SADateEditViewController alloc] init];
    dateCtl.myRow = selectedRow;
    dateCtl.parent = self;
    [self.navigationController pushViewController:dateCtl animated:YES];
    dateCtl = nil;
}

- (void) pushPickerView:(SARow *)selectedRow
{
    SAPickerEditViewController *pickerCtl = [[SAPickerEditViewController alloc] init];
    pickerCtl.myRow = selectedRow;
    pickerCtl.parent = self;
    [self.navigationController pushViewController:pickerCtl animated:YES];
    pickerCtl = nil;
}

- (void) pushLocationView:(SARow *)selectedRow
{
    SAMapViewController *mapView = [[SAMapViewController alloc] init];
    mapView.myRow = selectedRow;
    [self.navigationController pushViewController:mapView animated:YES];
    mapView = nil;
}

- (void) pushImagePickerView:(SARow *)selectedRow
{
    SAImagePickerController *imageCtl = [[SAImagePickerController alloc] init];
    imageCtl.currentImageURL = selectedRow.myData;
    imageCtl.myRow = selectedRow;
    [self.navigationController pushViewController:imageCtl animated:YES];
    imageCtl = nil;
}

- (void) pushWebView:(SARow *)selectedRow
{
    SAWebViewController *webView = [[SAWebViewController alloc] init];
    webView.myRow = selectedRow;
    [self.navigationController pushViewController:webView animated:YES];
    webView = nil;
}

- (void) pushChartView:(SARow *)selectedRow
{
    SAChartController *chartView = [[SAChartController alloc] init];
    chartView.myRow = selectedRow;
    [self.navigationController pushViewController:chartView animated:YES];
    chartView = nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int type = [self getFieldTypeForTag:textField.tag];
    
    switch (type) {
        case type_textInteger:
            return [self integerTextField:textField shouldChangeCharactersInRange:range replacementString:string];
            
            break;
        case type_textDecimal:
            return [self decimalTextField:textField shouldChangeCharactersInRange:range replacementString:string];
            break;
            
        default:
            break;
    }
    return YES;
}

- (BOOL)integerTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length >0 && [string length] ==0) {
        return YES;
    }
    
    if([string isEqualToString:@"\n"])
        return YES;
    
    NSString *numberSet=@"0123456789";
    NSCharacterSet *characterSet;
    characterSet=[[NSCharacterSet characterSetWithCharactersInString:numberSet]invertedSet];
    return ([[string stringByTrimmingCharactersInSet:characterSet] length] > 0);
}

- (BOOL)decimalTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //NSLog(@"%d %d %@", range.location, range.length, string);
    if (range.length >0 && [string length] ==0) {
        return YES;
    }
    
    if([string isEqualToString:@"\n"])
        return YES;

    NSCharacterSet *characterSet;
    NSString *numberSet=@"0123456789";
    NSString *numberPeriodSet=@"0123456789.";
    NSRange seperatorRange=[textField.text rangeOfString:@"."];
    if (seperatorRange.location == NSNotFound) {
        characterSet=[[NSCharacterSet characterSetWithCharactersInString:numberPeriodSet]invertedSet];
        
    }
    else {    
        characterSet=[[NSCharacterSet characterSetWithCharactersInString:numberSet]invertedSet];
    }
    if (![[string stringByTrimmingCharactersInSet:characterSet] length] > 0)
    {
        NSLog(@"contentOffset x = %f, y =%f", ((UIScrollView *)self.view).contentOffset.x, ((UIScrollView *)self.view).contentOffset.y);
        SAMessageView *messageView = [[SAMessageView alloc] init];
        [messageView showWithTimer:3.0 inView:self.view bounce:YES withText:@"This field requires a decimal number"];
        messageView = nil;
    }
    
    return ([[string stringByTrimmingCharactersInSet:characterSet] length] > 0);
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView titleForHeaderInSection:section] != nil) {
        return SectionHeaderHeight;
    }
    else {
        // If no section header title, no section header needed
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    if(headerTextColor == nil)
        headerTextColor = [UIColor darkGrayColor];
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 6, 300, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = headerTextColor;
    label.shadowColor = [UIColor darkGrayColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SectionHeaderHeight)];
    [view addSubview:label];
    
    return view;
}



@end
