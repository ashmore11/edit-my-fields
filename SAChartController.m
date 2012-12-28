//
//  SAChartController.m
//  EditMyFields
//
//  Created by SCOTT ASHMORE on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SAChartController.h"
#import <QuartzCore/QuartzCore.h>

@implementation SAChartController

@synthesize myRow;
@synthesize myChartView;

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
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //SAChartDef *chartDef = [myRow.options objectAtIndex:0];

    // Do any additional setup after loading the view from its nib.
    self.title = myRow.myLabel;
    myChartView.myRow = myRow;
    //[myChartView setNeedsDisplay];
    myChartView.backgroundColor = [UIColor blackColor];
    [myChartView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    myChartView.contentMode = UIViewContentModeRedraw;
    /*
    if(chartDef.values2 != nil)
    {
        SAOverlay *axisControl = [[SAOverlay alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-200,40,150,50)];
        axisControl.text = @"Sales";
        [self.view addSubview:axisControl];

        ;
    }
     */
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.myRow = nil;
    self.myChartView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
