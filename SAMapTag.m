//
//  SAMapTag.m
//  EditMyFields
//
//  Created by Bob Ashmore on 08/02/2012.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "SAMapTag.h"

@implementation SAMapTag

@synthesize tag;
@synthesize lat;
@synthesize lon;
@synthesize title;
@synthesize subtitle;


-(id) initWithlattidude:(NSString *)lattidude andLongitude:(NSString *)longitude tag:(NSString *)myTag title:(NSString *)mytitle subtitle:(NSString *)mySubTitle
{
    self = [super init];
    if (self) 
    {
        tag = myTag;
        lat = lattidude;
        lon = longitude;
        title = mytitle;
        subtitle = mySubTitle;
    }
    return self;
}
@end
