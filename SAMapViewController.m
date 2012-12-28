//
//  SAMapViewController.m
//  EditMyFields
//
//  Created by Scott Ashmore on 12-02-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SAMapViewController.h"
#import "SAMapAnnotations.h"
#import "SAMapTag.h"
#import "SAAnnotationEdit.h"

@implementation SAMapViewController

@synthesize mapView;
@synthesize locationManager;
@synthesize bFirstTimeIn;
@synthesize mapAnnotations;
@synthesize myRow;
@synthesize loadingIndicator;
@synthesize autoTag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bFirstTimeIn = YES;
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Hybrid" style:UIBarButtonItemStyleBordered target:self action:@selector(mapTypePressed:)];
    self.navigationItem.title = @"Map";
    // Create the map view
    mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    [mapView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    mapView.mapType = MKMapTypeHybrid;
    mapView.showsUserLocation = YES;
    mapView.alpha = 0.0;
    mapView.delegate = self;
    
    [self.view addSubview:mapView];
    
    // Create an Activity view and give the user feedback when loading the map from a slow network
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((mapView.frame.size.width/2)-10, (mapView.frame.size.height/2)-10, 20,20)];
    [loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loadingIndicator setHidesWhenStopped:YES];
    [mapView addSubview:loadingIndicator];
    
    // load all the animations passed in through the options array
    if(myRow.options != nil) {
        if(mapAnnotations == nil)
            mapAnnotations = [[NSMutableArray alloc] init];
        
        NSUInteger tag;
        CLLocationCoordinate2D annotationCenter;
        SAMapAnnotations *annotation;
        for(SAMapTag *mapPoint in myRow.options) 
        {
            tag = ++autoTag;
            mapPoint.tag = [NSString stringWithFormat:@"%d",tag];
            annotationCenter.latitude = [mapPoint.lat floatValue];
            annotationCenter.longitude = [mapPoint.lon floatValue];
            annotation = [[SAMapAnnotations alloc] initWithCoordinate:annotationCenter withTag:tag withTitle:mapPoint.title withSubtitle:mapPoint.subtitle];
            [mapAnnotations addObject:annotation];
            annotation = nil;
        }
    }
       
	//add annotations array to the mapView
	[mapView addAnnotations:mapAnnotations];
    
    // Add a 1 second press Gesture to drop an Annotation
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    lpgr.minimumPressDuration = 1.0;  //user must press for 1 seconds
    [mapView addGestureRecognizer:lpgr];
    lpgr = nil;
    
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    if (locationAllowed == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services are not available" 
                                                        message:@"Please check your settings" 
                                                       delegate:self 
                                              cancelButtonTitle: @"Cancel"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.mapView.userLocation addObserver:self 
                                forKeyPath:@"location" 
                                   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) 
                                   context:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    mapView = nil;
    locationManager = nil;
    mapAnnotations = nil;
    myRow = nil;
    loadingIndicator = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

// Listen to change in the userLocation
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context 
{     
    if(bFirstTimeIn == YES) {
        bFirstTimeIn = NO;
        MKCoordinateRegion region;
        region.center = self.mapView.userLocation.coordinate;  
        
        MKCoordinateSpan span; 
        span.latitudeDelta  = 0.01; // Change these values to change the zoom
        span.longitudeDelta = 0.01; 
        region.span = span;
        
        [self.mapView setRegion:region animated:NO];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:2.5];
        [self.mapView setAlpha:1.0];
        [UIView commitAnimations];
    }
}

- (IBAction)mapTypePressed:(id)sender
{
    if([self.navigationItem.rightBarButtonItem.title isEqualToString:@"Hybrid"])
    {
        self.navigationItem.rightBarButtonItem.title = @"Map";
        self.mapView.mapType = MKMapTypeStandard;
    }
    else if([self.navigationItem.rightBarButtonItem.title isEqualToString:@"Map"])
    {
        self.navigationItem.rightBarButtonItem.title = @"Sat";
        self.mapView.mapType = MKMapTypeSatellite;
    }
    else if([self.navigationItem.rightBarButtonItem.title isEqualToString:@"Sat"])
    {
        self.navigationItem.rightBarButtonItem.title = @"Hybrid";
        self.mapView.mapType = MKMapTypeHybrid;
    }   
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    [loadingIndicator startAnimating];   
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
   [loadingIndicator stopAnimating]; 
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Google Maps failed to load" 
                                                    message:@"Please check you have network availability" 
                                                   delegate:self 
                                          cancelButtonTitle: @"Cancel"
                                          otherButtonTitles:nil];
    [alert show];
}

- (MKAnnotationView *)mapView:(MKMapView *)myMapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    if(annotation != mapView.userLocation)
    {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[myMapView dequeueReusableAnnotationViewWithIdentifier:@"SAAnnotationView"];
        if(annotationView == nil) 
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"SAAnnotationView"];
            annotationView.canShowCallout = YES;
            [annotationView setPinColor:MKPinAnnotationColorRed]; 
            UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.rightCalloutAccessoryView = infoButton;
            annotationView.draggable = YES;
        }
        annotationView.annotation = annotation;
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    SAMapAnnotations *annotation = view.annotation;
    
    SAAnnotationEdit *aView = [[SAAnnotationEdit alloc] init];
    aView.annotation = annotation;
    aView.delegate = self;
    [self.navigationController pushViewController:aView animated:YES];    
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return;
    
    if(![myRow.options respondsToSelector: @selector(addObject:)])
        return;

    CGPoint touchPoint = [gestureRecognizer locationInView:mapView];
    CLLocationCoordinate2D touchMapCoordinate = [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    
    [loadingIndicator startAnimating];   

    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            [loadingIndicator stopAnimating];   
            [self displayError:error];
            return;
        }
        dispatch_async(dispatch_get_main_queue(),^ {
            if([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                NSString *city = placemark.locality;
                NSString *street = placemark.thoroughfare;
                SAMapAnnotations *annotation = [[SAMapAnnotations alloc] initWithCoordinate:touchMapCoordinate withTag:++autoTag withTitle:street withSubtitle:city];
                NSString *sLat = [NSString stringWithFormat:@"%f",annotation.coordinate.latitude];
                NSString *sLon = [NSString stringWithFormat:@"%f",annotation.coordinate.longitude];
                SAMapTag *tagLocation = [[SAMapTag alloc] initWithlattidude:sLat andLongitude:sLon tag:[NSString stringWithFormat:@"%d",autoTag] title:annotation.title subtitle:annotation.subtitle];
                [myRow.options addObject:tagLocation]; 

                [mapView addAnnotation:annotation];
                [loadingIndicator stopAnimating];   
            }
        });
    }];
}

- (void)removePin:(SAMapAnnotations *)annotation
{
    [mapView removeAnnotation:annotation];
    NSString *sTag = [NSString stringWithFormat:@"%d",annotation.tag];
    __block NSInteger row=0;
    [myRow.options enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) 
     {
         SAMapTag *location = obj; 
         if ([location.tag isEqualToString:sTag]) 
         {
             row = idx;
             *stop = TRUE;
         }
     }];

    [myRow.options removeObjectAtIndex:row];
}

- (void)displayError:(NSError*)error
{
    dispatch_async(dispatch_get_main_queue(),^ {
        NSString *message;
        switch ([error code])
        {
            case kCLErrorGeocodeFoundNoResult: message = @"kCLErrorGeocodeFoundNoResult";
                break;
            case kCLErrorGeocodeCanceled: message = @"kCLErrorGeocodeCanceled";
                break;
            case kCLErrorGeocodeFoundPartialResult: message = @"kCLErrorGeocodeFoundNoResult";
                break;
            default: message = [error description];
                break;
        }
        
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"An error occurred."
                                                          message:message
                                                         delegate:nil 
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [alert show];
    });   
}

/*
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState 
{
    if(newState == MKAnnotationViewDragStateEnding) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:annotationView.annotation.coordinate.latitude longitude:annotationView.annotation.coordinate.longitude];
        
        [loadingIndicator startAnimating];   
        __block SAMapAnnotations *annotation = annotationView.annotation;
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
            if (error){
                NSLog(@"Geocode failed with error: %@", error);
                [loadingIndicator stopAnimating];   
                [self displayError:error];
                return;
            }
            NSLog(@"Received placemarks: %@", placemarks);
            dispatch_async(dispatch_get_main_queue(),^ {
                if([placemarks count] > 0) {
                    CLPlacemark *placemark = [placemarks objectAtIndex:0];
                    NSString *city = placemark.locality;
                    NSString *street = placemark.thoroughfare;
                    NSString *sLat = [NSString stringWithFormat:@"%f",annotation.coordinate.latitude];
                    NSString *sLon = [NSString stringWithFormat:@"%f",annotation.coordinate.longitude];
                    annotation.title = street;
                    annotation.subtitle = city;
                    NSString *sTag = [NSString stringWithFormat:@"%d",annotation.tag];
                    __block NSInteger row=0;
                    [myRow.options enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) 
                     {
                         SAMapTag *location = obj; 
                         if ([location.tag isEqualToString:sTag]) 
                         {
                             row = idx;
                             *stop = TRUE;
                         }
                     }];
                    SAMapTag *tagLocation = [myRow.options objectAtIndex:row];
                    tagLocation.lat = sLat;
                    tagLocation.lon = sLon;
                    tagLocation.title = street;
                    tagLocation.subtitle = city;
                    [loadingIndicator stopAnimating];   
                }
            });
        }];
    }
}
*/
@end
