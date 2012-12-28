//
//  SAMapViewController.h
//  EditMyFields
//
//  Created by Scott Ashmore on 12-02-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SARow.h"
#import "SAAnnotationEdit.h"

@interface SAMapViewController : UIViewController <MKMapViewDelegate, SAAnnotationEditProtocol>

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *mapAnnotations;
@property (strong, nonatomic) SARow *myRow;
@property (strong, nonatomic) UIActivityIndicatorView *loadingIndicator;
@property BOOL bFirstTimeIn;
@property int autoTag;

- (IBAction)mapTypePressed:(id)sender;
- (void)displayError:(NSError*)error;

@end
