//
//  SAMapAnnotations.h
//  EditMyFields
//
//  Created by Bob Ashmore on 08/02/2012.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SAMapAnnotations : NSObject <MKAnnotation>

@property(nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property(nonatomic) NSUInteger tag;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *subtitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D)c withTag:(NSUInteger)t withTitle:(NSString *)tl withSubtitle:(NSString *)s;	

@end
