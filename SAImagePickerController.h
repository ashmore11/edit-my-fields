//
//  SAImagePickerController.h
//  EditMyFields
//
//  Created by Scott Ashmore on 12-02-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SAEditViewController.h"

typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);
typedef void (^ALAssetsLibraryWriteImageCompletionBlock)(NSURL *assetURL, NSError *error);

@interface SAImagePickerController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *myView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) CALayer *imageLayer;
@property (strong, nonatomic) UIImage *currentImage;
@property (strong, nonatomic) NSString *currentImageURL;
@property (strong, nonatomic) SARow *myRow;
@property (strong, nonatomic) NSTimer *barTimer;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *libraryButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *spacerButton;


@property BOOL bBarsHidden;

-(void) saveImageToAssetsLibrary:(UIImage *)image withMetadata:(NSDictionary *)metaData;
-(IBAction)shootPictureOrVideo:(id)sender;
-(IBAction)selectExistingPictureOrVideo:(id)sender;
-(BOOL) isPortrait:(UIImage *)myImage;
-(UIImage *)scaledCopyOfSize:(CGSize)newSize withImage:(UIImage *)originalImage;
-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType;
-(IBAction)toggleNavigationBar:(id)sender;
-(void)loadImageFromAssetsLibrary;
-(void) displayImage:(UIImage *)img;
-(void) imageLoaded;

@end
