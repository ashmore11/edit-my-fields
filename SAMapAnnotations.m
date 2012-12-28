//
//  SAMapAnnotations.m
//  EditMyFields
//
//  Created by Bob Ashmore on 08/02/2012.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "SAMapAnnotations.h"

@implementation SAMapAnnotations

@synthesize coordinate;
@synthesize tag;
@synthesize title;
@synthesize subtitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D)c withTag:(NSUInteger)t withTitle:(NSString *)tl withSubtitle:	(NSString *)s	
{
	if(self = [super init])
	{
		coordinate = c;
		tag = t;
		title = tl;
		subtitle = s;
	}
	return self;
}

@end
