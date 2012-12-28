//
//  AppDelegate.h
//  EditMyFields
//
//  Created by Scott Ashmore on 12-01-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAEditViewController.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) SAEditViewController *myTableEdit;

@property (strong, nonatomic) UINavigationController *navigationController;

@end
