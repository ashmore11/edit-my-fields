//
//  SAEditViewController.h
//  EditMyFields
//
//  Created by Bob Ashmore on 30/01/2012.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMessageView.h"

typedef enum fieldTypes
{
    type_textGeneral = 1,
    type_textPassword,
    type_textInteger,
    type_textDecimal,
    type_date,
    type_switch,
    type_segmented,
    type_picker,
    type_table,
    type_slider,
    type_location,
    type_imagePicker,
    type_webView,
    type_chart,
} FieldTypes;


typedef enum displayTypes
{
    display_general = 1,
    display_chart,
    display_location,
    display_webView,
    display_imagePicker,
} displayTypes;



@interface SAMapTag : NSObject
@property (strong,nonatomic) NSString *tag;
@property (strong,nonatomic) NSString *lat;
@property (strong,nonatomic) NSString *lon;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *subtitle;
-(id) initWithlattidude:(NSString *)lattidude andLongitude:(NSString *)longitude tag:(NSString *)myTag title:(NSString *)mytitle subtitle:(NSString *)mySubTitle;
@end


@interface SARow : NSObject
@property (nonatomic) FieldTypes type;
@property (strong, nonatomic) NSString *myLabel;
@property (strong, nonatomic) NSString *myData;
@property (strong, nonatomic) NSMutableArray *options;
@property (nonatomic) int fieldTag;
- (void) addRowWithType:(FieldTypes)myType label:(NSString *) myLbl data:(NSString *) myDta withTag:(int)myTag;
- (void) addRowWithOptionsAndType:(FieldTypes)myType label:(NSString *) myLbl data:(NSString *) myDta options:(NSArray *) myOptions withTag:(int)myTag;
@end


@protocol SAEditProtocol <NSObject>
- (void)didPressOk:(id) tableEditor;
@end

@interface SASection : NSObject
@property (strong, nonatomic) NSString *headerText;
@property (strong, nonatomic) NSMutableArray *myRows;
- (void) addRowWithType:(FieldTypes)myType label:(NSString *) myLbl data:(NSString *) myDta withTag:(int)myTag;
- (void) addRowWithOptionsAndType:(FieldTypes)myType label:(NSString *) myLbl data:(NSString *) myDta options:(NSArray *) myOptions withTag:(int)myTag;
@end

@interface SAChartDef : NSObject

@property (strong, nonatomic) NSString *chartHeader;
@property (strong, nonatomic) NSString *yMax;
@property (strong, nonatomic) NSString *yMin;
@property (strong, nonatomic) NSArray *xLabels;
@property (strong, nonatomic) NSArray *values;
@property (strong, nonatomic) NSArray *values2;
@property (strong, nonatomic) NSArray *values3;
@property (strong, nonatomic) NSArray *values4;
@property (strong, nonatomic) NSString *plotName1;
@property (strong, nonatomic) NSString *plotName2;
@property (strong, nonatomic) NSString *plotName3;
@property (strong, nonatomic) NSString *plotName4;

@end



@interface SAEditViewController : UITableViewController <UITextFieldDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) NSString *headerText;
@property (strong, nonatomic) NSMutableArray *mySecionArray;
@property (strong, nonatomic) id <SAEditProtocol> delegate;
@property (strong, nonatomic) UIViewController *myView;
@property (strong, nonatomic) UIColor *headerTextColor;
@property (strong, nonatomic) UINavigationController *myNavigationController;

- (SASection *) addSectionWithHeader:(NSString *) myHeader;


- (void) addRowToSection:(SASection *)mySec withType:(FieldTypes)myType label:(NSString *) myLbl data:(NSString *) myDta withTag:(int)tag;
- (void) addRowToSectionWithOptions:(SASection *)mySec andType:(FieldTypes)myType label:(NSString *) myLbl data:(NSString *) myDta options:(NSArray *) myOptions withTag:(int)tag;


- (IBAction)pressedOK:(id)sender;
- (IBAction)sliderChanged:(id)sender;

- (void) addToView:(UIViewController *)view;

- (UITableViewCell *)AddGeneralTextRow:(SARow *)myRowData tableView:(UITableView *)tableView;
- (void) setFieldData:(NSString *)data forTag:(int)tag;
- (NSString *) getFieldDataForTag:(int)tag;
- (int) getFieldTypeForTag:(int)tag;


- (UITableViewCell *)AddSwitchRow:(SARow *)myRowData tableView:(UITableView *)tableView;
- (UITableViewCell *)AddSliderRow:(SARow *)myRowData tableView:(UITableView *)tableView;
- (UITableViewCell *)AddSegmentedControlRow:(SARow *)myRowData tableView:(UITableView *)tableView;


- (BOOL)integerTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (BOOL)decimalTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;


- (IBAction)switchChanged:(id)sender;
- (IBAction)segPushed:(id)sender;



- (SARow *) getFieldForSection:(int) mySection withRow:(int) myRow;


- (void) pushDateView:(SARow *)selectedRow;
- (void) pushPickerView:(SARow *)selectedRow;
- (void) pushLocationView:(SARow *)selectedRow;
- (void) pushImagePickerView:(SARow *)selectedRow;
- (void) pushWebView:(SARow *)selectedRow;
- (void) pushChartView:(SARow *)selectedRow;

@end
