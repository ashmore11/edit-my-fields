//
//  SAImagePickerController.m
//  EditMyFields
//
//  Created by Scott Ashmore on 12-02-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SAImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@implementation SAImagePickerController

@synthesize myView;
@synthesize imageLayer;
@synthesize toolbar;
@synthesize bBarsHidden;
@synthesize currentImage;
@synthesize currentImageURL;
@synthesize myRow;
@synthesize barTimer;
@synthesize cameraButton;
@synthesize libraryButton;
@synthesize spacerButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    [myView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
    
    // this hides the camera button if no camera is available
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *photoLib  = [[UIBarButtonItem alloc] initWithTitle:@"Library" style:UIBarButtonItemStyleBordered target:self action:@selector(selectExistingPictureOrVideo:)];
        [toolbar setItems:[NSArray arrayWithObjects:flexSpace,photoLib,flexSpace, nil]];
    }
    else {
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *photoLib  = [[UIBarButtonItem alloc] initWithTitle:@"Library" style:UIBarButtonItemStyleBordered target:self action:@selector(selectExistingPictureOrVideo:)];
        UIBarButtonItem *cameraBtn  = [[UIBarButtonItem alloc] initWithTitle:@"Camera" style:UIBarButtonItemStyleBordered target:self action:@selector(shootPictureOrVideo:)];
        [toolbar setItems:[NSArray arrayWithObjects:flexSpace,cameraBtn,photoLib,flexSpace, nil]];
    }
    
    if(currentImageURL != nil)
        [self loadImageFromAssetsLibrary];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    myView = nil;
    imageLayer = nil;
    toolbar = nil;
    currentImage = nil;
    currentImageURL = nil;
    myRow = nil;
    barTimer = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.navigationController.navigationBar setAlpha:1.0];
    [UIView commitAnimations];
}

- (IBAction)toggleNavigationBar:(id)sender 
{
    if (bBarsHidden == YES & imageLayer != nil)
    {
        // animate the Nav and Toolbar into view
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [self.navigationController.navigationBar setAlpha:0.7];
        [self.toolbar setAlpha:0.7];
        [UIView commitAnimations];
        bBarsHidden = NO;
        // keep them onscreen for 5 seconds
        barTimer = [NSTimer scheduledTimerWithTimeInterval: 5.0 target: self selector:@selector(barTimerFired:) userInfo: nil repeats:NO];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        return NO;
    
    return YES;
}

- (IBAction)shootPictureOrVideo:(id)sender
{
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)selectExistingPictureOrVideo:(id)sender
{
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark UIImagePickerController delegate methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqual:(NSString *)kUTTypeImage]) 
    {
        NSDictionary *metaDictionary = [info objectForKey:UIImagePickerControllerMediaMetadata];
        if(metaDictionary != nil) {
            [self saveImageToAssetsLibrary:[info objectForKey:UIImagePickerControllerOriginalImage] withMetadata:metaDictionary];
        }
        else
            myRow.myData = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];

        [self displayImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    }
    [picker dismissModalViewControllerAnimated:YES];
}

-(void) displayImage:(UIImage *)img
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    /*
     UIDeviceOrientationPortrait,
     UIDeviceOrientationPortraitUpsideDown,
     UIDeviceOrientationLandscapeLeft,
     UIDeviceOrientationLandscapeRight,
     */
    
    currentImage = img;
    myView.layer.sublayers = nil;
    imageLayer = nil;
    imageLayer = [CALayer layer];
    imageLayer.opacity  = 0.0;
    if ([self isPortrait:img] && (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown))
    {
        UIImage *smallImage = [self scaledCopyOfSize:myView.frame.size withImage:img];
        imageLayer.frame = CGRectMake(0, 0, myView.frame.size.width, myView.frame.size.height);
        imageLayer.contents = (id) smallImage.CGImage;
    }
    else if([self isPortrait:img] && (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight))
    {
        CGRect layerRect = myView.frame;
        float ratio = img.size.width / img.size.height;
        layerRect.size.width = layerRect.size.height * ratio;
        UIImage *smallImage = [self scaledCopyOfSize:layerRect.size withImage:img];
        imageLayer.frame = CGRectMake((myView.bounds.size.width/2) -(layerRect.size.width/2),0, layerRect.size.width, layerRect.size.height);
        imageLayer.contents = (id) smallImage.CGImage;
    }
    else
    {
        CGRect layerRect = myView.frame;
        float ratio = img.size.height/img.size.width;
        layerRect.size.height = layerRect.size.width * ratio;
        UIImage *smallImage = [self scaledCopyOfSize:layerRect.size withImage:img];
        imageLayer.frame = CGRectMake(0, (myView.bounds.size.height/2) -(layerRect.size.height/2), layerRect.size.width, layerRect.size.height);
        imageLayer.contents = (id) smallImage.CGImage;
    }
    [myView.layer addSublayer:imageLayer];
    // Animate the image into view
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
    fadeInAnimation.duration = 0.35;
    [imageLayer addAnimation:fadeInAnimation forKey:@"opacity"];
    imageLayer.opacity  = 1.0;
    // Show the nav and toolbar for 5 seconds
    [self.navigationController.navigationBar setAlpha:0.5];
    [self.toolbar setAlpha:0.5];
    bBarsHidden = NO;
    barTimer = [NSTimer scheduledTimerWithTimeInterval: 5.0 target: self selector:@selector(barTimerFired:) userInfo: nil repeats:NO];
}

-(void)barTimerFired:(NSTimer *)timer {
    // Remove the Nav and Toolbar from view
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.navigationController.navigationBar setAlpha:0.0];
    [self.toolbar setAlpha:0.0];
    [UIView commitAnimations];
    bBarsHidden = YES;
}

-(BOOL) isPortrait:(UIImage *)myImage
{
    //NSLog(@"width %f height %f", myImage.size.width, myImage.size.height);
    if (myImage.size.width < myImage.size.height)
        return TRUE;
    return FALSE;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediaTypes count] > 0) 
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error accessing media" 
                                                       message:@"Device doesn't support that media source" 
                                                      delegate:nil 
                                             cancelButtonTitle:@"OK" 
                                             otherButtonTitles:nil];
        [alert show];
    }
}

- (UIImage *)scaledCopyOfSize:(CGSize)newSize withImage:(UIImage *)originalImage {
    CGImageRef imgRef = originalImage.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > newSize.width || height > newSize.height) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = newSize.width;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = newSize.height;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = originalImage.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

-(void)loadImageFromAssetsLibrary
{
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        ALAssetOrientation orientation = rep.orientation;
        if (iref) {
            currentImage = [UIImage imageWithCGImage:iref scale: 1.0 orientation:(UIImageOrientation)orientation ];
            // run in main thread
            dispatch_async(dispatch_get_main_queue(), ^{[self imageLoaded];});
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
        NSLog(@"Unable to load image - %@",[myerror localizedDescription]);
    };
    
    currentImage = nil;
    NSURL *imageURL = [[NSURL alloc] initWithString:currentImageURL];
    ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL resultBlock:resultblock failureBlock:failureblock];
}

-(void) imageLoaded
{
    if(currentImage)
        [self displayImage:currentImage];
}

-(void) saveImageToAssetsLibrary:(UIImage *)image withMetadata:(NSDictionary *)metaData
{
    ALAssetsLibraryWriteImageCompletionBlock resulblock = ^(NSURL *assetURL, NSError *error)
    {
        if (error) {
            NSLog(@"Unable to save image - %@",[error localizedDescription]);
        } else {
            myRow.myData = [assetURL absoluteString];
        }
    };
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:[image CGImage] metadata:metaData completionBlock:resulblock];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification 
{
    //Obtain the current device orientation
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if(orientation == UIInterfaceOrientationPortraitUpsideDown)
        return;
    [self displayImage:currentImage];
}

@end
