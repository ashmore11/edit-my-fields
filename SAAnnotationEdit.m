//
//  SAAnnotationEdit.m
//  EditMyFields
//
//  Created by SCOTT ASHMORE on 10/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SAAnnotationEdit.h"
#import "SAMapTag.h"

@implementation SAAnnotationEdit

@synthesize titleField;
@synthesize subTitleField;
@synthesize annotation;
@synthesize delegate;
@synthesize myRow;
@synthesize tag;


- (IBAction)removePressed:(id)sender
{
    if([self.delegate respondsToSelector:@selector(removePin:)])
        [delegate removePin:annotation];
    [self.navigationController popViewControllerAnimated:YES];

}

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
    
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    self.titleField.text = annotation.title;
    self.subTitleField.text = annotation.subtitle;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)doneButtonPressed:(id)sender;
{
    annotation.title = titleField.text;
    annotation.subtitle = subTitleField.text;

    NSString *sLat = [NSString stringWithFormat:@"%f",annotation.coordinate.latitude];
    NSString *sLon = [NSString stringWithFormat:@"%f",annotation.coordinate.longitude];
    SAMapTag *tagLocation = [[SAMapTag alloc] initWithlattidude:sLat andLongitude:sLon tag:[NSString stringWithFormat:@"%d",tag] title:annotation.title subtitle:annotation.subtitle];
    [myRow.options addObject:tagLocation]; 
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonPressed:(id)sender;
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)textFieldDone:(id)sender
{
    [sender resignFirstResponder];
}

@end
