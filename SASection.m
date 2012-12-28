//
//  SASection.m
//  CDFamily
//
//  Created by Scott Ashmore on 12-01-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SASection.h"

@implementation SASection

@synthesize headerText;
@synthesize myRows;

- (void) addRowWithType:(FieldTypes)myType label:(NSString *) myLbl data:(NSString *) myDta  withTag:(int)myTag
{
    SARow *newRow = [[SARow alloc] init];
    [newRow addRowWithType:myType label:myLbl data:myDta withTag:myTag];
    if (myRows == nil) 
    {
        myRows = [[NSMutableArray alloc] init];
    }
    [myRows addObject:newRow];
    newRow = nil;
}

- (void) addRowWithOptionsAndType:(FieldTypes)myType label:(NSString *) myLbl data:(NSString *) myDta options:(NSArray *) myOptions withTag:(int)myTag
{
    SARow *newRow = [[SARow alloc] init];
    [newRow addRowWithOptionsAndType:myType label:myLbl data:myDta options:myOptions withTag:myTag];
    if (myRows == nil) 
    {
        myRows = [[NSMutableArray alloc] init];
    }
    [myRows addObject:newRow];
    newRow = nil;

}

@end
