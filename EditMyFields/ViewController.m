//
//  ViewController.m
//  EditMyFields
//
//  Created by Scott Ashmore on 12-01-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "SAChartController.h"
#import "SAMapViewController.h"
#import "SAWebViewController.h"
#import "SAImagePickerController.h"

@implementation ViewController

@synthesize myTableEdit;
@synthesize processFields;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Demo";
}

- (void)didPressOk:(id) tableEditor
{
    SAEditViewController *myEdit = tableEditor;
    NSLog(@"Pressed OK");
    for(int i= 1;i<20;i++) {
        NSLog(@"Tag: %d Data: %@",i,[myEdit getFieldDataForTag:i]);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

- (IBAction)doEditFields:(id)sender {
    // Do any additional setup after loading the view, typically from a nib.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SADefinitions" ofType:@"plist"];
    NSMutableDictionary *dataDictionary = [[[NSMutableDictionary alloc] initWithContentsOfFile:path] objectForKey:@"root"];
    
    myTableEdit = [[SAEditViewController alloc] init];
    myTableEdit.headerText = @"Employee Edit";
    myTableEdit.delegate = self;
    
    SASection *mySection1 = [myTableEdit addSectionWithHeader:@"General"];
    [myTableEdit addRowToSection:mySection1 withType:type_textGeneral label:@"Surname" data:@"Ashmore" withTag:1];
    [myTableEdit addRowToSection:mySection1 withType:type_textGeneral label:@"First Name" data:@"Scott" withTag:2];    
    NSMutableArray *deptOptions = [dataDictionary objectForKey:@"departments"];
    [myTableEdit addRowToSectionWithOptions:mySection1 andType:type_picker label:@"Department" data:nil options:deptOptions withTag:3];    
    [myTableEdit addRowToSection:mySection1 withType:type_textGeneral label:@"PPS Number" data:nil withTag:4];
    
    SASection *mySection2 = [myTableEdit addSectionWithHeader:@"Pay Data"];
    [myTableEdit addRowToSection:mySection2 withType:type_textDecimal label:@"Salary" data:@"24000.00" withTag:5];
    [myTableEdit addRowToSection:mySection2 withType:type_textGeneral label:@"Tax Payed" data:@"5000" withTag:6];
    [myTableEdit addRowToSection:mySection2 withType:type_textInteger label:@"Tax Number" data:@"5" withTag:7];
    
    SASection *mySection3 = [myTableEdit addSectionWithHeader:@"Passwords"];
    [myTableEdit addRowToSection:mySection3 withType:type_textPassword label:@"Payroll" data:@"12345" withTag:8];
    
    SASection *mySection4 = [myTableEdit addSectionWithHeader:@"Employment Type"];
    [myTableEdit addRowToSection:mySection4 withType:type_switch label:@"Fulltime Employee" data:@"YES" withTag:9];
    [myTableEdit addRowToSection:mySection4 withType:type_switch label:@"Holidayable" data:@"NO" withTag:10];
    [myTableEdit addRowToSection:mySection4 withType:type_date label:@"Birth Date" data:@"03 Oct 1988" withTag:11];
    
    SASection *mySection5 = [myTableEdit addSectionWithHeader:@"Bio Details"];
    NSMutableArray *hairColor = [dataDictionary objectForKey:@"haircolor"];
    [myTableEdit addRowToSectionWithOptions:mySection5 andType:type_picker label:@"Hair Color" data:@"Red" options:hairColor withTag:12];
    NSMutableArray *eyeColor = [dataDictionary objectForKey:@"eyecolor"];
    [myTableEdit addRowToSectionWithOptions:mySection5 andType:type_picker label:@"Eye Color" data:nil options:eyeColor withTag:13];
    
    SASection *mySection6 = [myTableEdit addSectionWithHeader:@"Hours"];
    NSArray *sliderValues = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:40.0], nil];
    [myTableEdit addRowToSectionWithOptions:mySection6 andType:type_slider label:@"p/w" data:@"20.0" options:sliderValues withTag:14];
    NSArray *sliderValues2 = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:-30.0], [NSNumber numberWithFloat:100.0], nil];
    [myTableEdit addRowToSectionWithOptions:mySection6 andType:type_slider label:@"p/w" data:nil options:sliderValues2 withTag:15];
    
    SASection *mySection7 = [myTableEdit addSectionWithHeader:@"Floor"];
    NSArray *floor = [[NSArray alloc] initWithObjects:@"First", @"Second", @"Third", nil];
    [myTableEdit addRowToSectionWithOptions:mySection7 andType:type_segmented label:nil data:nil options:floor withTag:16];
    
    SASection *mySection8 = [myTableEdit addSectionWithHeader:@"Locations"];
    SAMapTag *tagLocation1 = [[SAMapTag alloc] initWithlattidude:@"53.22646" andLongitude:@"-6.13488" tag:@"1" title:@"Marble Hall" subtitle:@"Home"];
    SAMapTag *tagLocation2 = [[SAMapTag alloc] initWithlattidude:@"53.298" andLongitude:@"-6.137" tag:@"2" title:@"Marina" subtitle:@"Dunlaoghaire"];
    NSMutableArray *locations = [[NSMutableArray alloc] initWithObjects:tagLocation1, tagLocation2, nil];
    [myTableEdit addRowToSectionWithOptions:mySection8 andType:type_location label:@"My Location from the mapview please" data:nil options:locations withTag:17];
    
    SASection *mySection9 = [myTableEdit addSectionWithHeader:@"Photo ID"];
    [myTableEdit addRowToSection:mySection9 withType:type_imagePicker label:@"Select or Create Image" data:@"assets-library://asset/asset.JPG?id=981F7FBC-9E42-493F-9DDC-2FD601BDBE9E&ext=JPG" withTag:18];
    
    SASection *mySection10 = [myTableEdit addSectionWithHeader:@"Home Page"];
    [myTableEdit addRowToSection:mySection10 withType:type_webView label:@"Goto Homepage" data:@"http://www.dunluce.com" withTag:19];
    
    SASection *mySection11 = [myTableEdit addSectionWithHeader:@"Charts"];
    SAChartDef *chartDef = [[SAChartDef alloc] init];
    chartDef.chartHeader = @"1st Half Sales for 2011";
    chartDef.yMax = @"50";
    chartDef.xLabels = [[NSArray alloc] initWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", nil];
    chartDef.values = [[NSArray alloc] initWithObjects:@"22", @"12", @"35", @"18", @"30", @"10", nil];
    NSMutableArray *chartData = [[NSMutableArray alloc] initWithObjects:chartDef, nil];
    [myTableEdit addRowToSectionWithOptions:mySection11 andType:type_chart label:@"6 Months Sales" data:nil options:chartData withTag:20];
    
    SAChartDef *chartDef1 = [[SAChartDef alloc] init];
    chartDef1.chartHeader = @"Sales for 2011";
    chartDef1.yMax = @"500";
    chartDef1.xLabels = [[NSArray alloc] initWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun",@"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
    chartDef1.values = [[NSArray alloc] initWithObjects:@"220", @"120", @"350", @"180", @"300", @"100",@"360", @"420", @"150", @"180", @"200", @"300", nil];
    NSMutableArray *chartData1 = [[NSMutableArray alloc] initWithObjects:chartDef1, nil];
    [myTableEdit addRowToSectionWithOptions:mySection11 andType:type_chart label:@"12 Months Sales" data:nil options:chartData1 withTag:21];
    
    myTableEdit.headerTextColor = [UIColor whiteColor];
    myTableEdit.view.backgroundColor = [UIColor darkGrayColor];
    [self.navigationController pushViewController:myTableEdit animated:YES];
}

- (IBAction)displayChart:(id)sender {

    SAChartDef *chartDef1 = [[SAChartDef alloc] init];
    chartDef1.chartHeader = @"Sales for 2011";
    chartDef1.yMax = @"500";
    chartDef1.xLabels = [[NSArray alloc] initWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun",@"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
    chartDef1.values = [[NSArray alloc] initWithObjects:@"220", @"120", @"350", @"180", @"300", @"100",@"360", @"420", @"150", @"180", @"200", @"300", nil];
    NSMutableArray *chartData1 = [[NSMutableArray alloc] initWithObjects:chartDef1, nil];
 
    SARow *chartRow = [[SARow alloc] init];
    [chartRow addRowWithOptionsAndType:type_location label:@"Sales Data" data:nil options:chartData1 withTag:0];

    SAChartController *chartView = [[SAChartController alloc] init];
    chartView.myRow = chartRow;
    [self.navigationController pushViewController:chartView animated:YES];
    chartView = nil;
}

- (IBAction)showMyLocation:(id)sender 
{
    SAMapTag *tagLocation1 = [[SAMapTag alloc] initWithlattidude:@"53.22646" andLongitude:@"-6.13488" tag:@"1" title:@"Marble Hall" subtitle:@"Home"];
    SAMapTag *tagLocation2 = [[SAMapTag alloc] initWithlattidude:@"53.298" andLongitude:@"-6.137" tag:@"2" title:@"Marina" subtitle:@"Dunlaoghaire"];
    NSMutableArray *locations = [[NSMutableArray alloc] initWithObjects:tagLocation1, tagLocation2, nil];
    SARow *mapRow = [[SARow alloc] init];
    [mapRow addRowWithOptionsAndType:type_location label:@"My Location" data:nil options:locations withTag:0];
    SAMapViewController *mapView = [[SAMapViewController alloc] init];
    mapView.myRow = mapRow;
    [self.navigationController pushViewController:mapView animated:YES];
    mapView = nil;
}

- (IBAction)myHomePage:(id)sender 
{
    SARow *webRow = [[SARow alloc] init];
    [webRow addRowWithOptionsAndType:type_webView label:@"Homepage" data:@"http://www.dunluce.com" options:nil withTag:0];
    SAWebViewController *webView = [[SAWebViewController alloc] init];
    webView.myRow = webRow;
    [self.navigationController pushViewController:webView animated:YES];
    webView = nil;

}

- (IBAction)myPhotoPicker:(id)sender 
{
    SARow *photoRow = [[SARow alloc] init];
    [photoRow addRowWithOptionsAndType:type_imagePicker label:@"Image" data:nil options:nil withTag:0];
    SAImagePickerController *photoView = [[SAImagePickerController alloc] init];
    photoView.myRow = photoRow;
    [self.navigationController pushViewController:photoView animated:YES];
    photoView = nil;
}

- (IBAction)mySalesVSProfit:(id)sender
{
    SAChartDef *chartDef1 = [[SAChartDef alloc] init];
    chartDef1.chartHeader = @"Sales / Profits 2011";
    chartDef1.yMax = @"500";
    chartDef1.yMin = @"-200";
    chartDef1.xLabels = [[NSArray alloc] initWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun",@"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
    chartDef1.values = [[NSArray alloc] initWithObjects:@"0", @"120", @"350", @"180", @"300", @"100",@"360", @"420", @"150", @"180", @"200", @"500", nil];
    chartDef1.values2 = [[NSArray alloc] initWithObjects:@"0", @"60", @"80", @"70", @"120", @"-100",@"130", @"200", @"90", @"60", @"20", @"-200", nil];

    NSMutableArray *chartData1 = [[NSMutableArray alloc] initWithObjects:chartDef1, nil];
    
    SARow *chartRow = [[SARow alloc] init];
    [chartRow addRowWithOptionsAndType:type_location label:@"Sales Data" data:nil options:chartData1 withTag:0];
    
    SAChartController *chartView = [[SAChartController alloc] init];
    chartView.myRow = chartRow;
    [self.navigationController pushViewController:chartView animated:YES];
    chartView = nil;
}

@end
