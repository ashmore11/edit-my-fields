//
//  SARow.m
//  CDFamily
//
//  Created by Scott Ashmore on 12-01-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SARow.h"

@implementation SARow

@synthesize type;
@synthesize myLabel;
@synthesize myData;
@synthesize options;
@synthesize fieldTag;

- (void) addRowWithType:(FieldTypes)myType label:(NSString *) myLbl data:(NSString *) myDta  withTag:(int)myTag
{
    type = myType;
    myLabel = myLbl;
    myData = myDta;
    fieldTag = myTag;
}

- (void) addRowWithOptionsAndType:(FieldTypes)myType label:(NSString *) myLbl data:(NSString *) myDta options:(NSMutableArray *) myOptions withTag:(int)myTag
{
    [self addRowWithType:myType label:myLbl data:myDta withTag:myTag];
    options = myOptions;
}

@end
