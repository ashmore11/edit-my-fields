//
//  SAWebViewController.h
//  EditMyFields
//
//  Created by SCOTT ASHMORE on 13/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SARow.h"

@interface SAWebViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *myWebView;
@property (strong, nonatomic) SARow *myRow;
@property (strong, nonatomic) UIActivityIndicatorView *loadingIndicator;

- (void)goBack;
- (void)goForward;

- (UIBarButtonItem*)barItemWithImage:(UIImage*)image highlighted:(UIImage *)highlight disabled:(UIImage *)disable target:(id)target action:(SEL)action;


@end
