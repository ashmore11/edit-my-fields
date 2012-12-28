//
//  SAWebViewController.m
//  EditMyFields
//
//  Created by SCOTT ASHMORE on 13/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SAWebViewController.h"

@implementation SAWebViewController

@synthesize myWebView;
@synthesize myRow;
@synthesize loadingIndicator;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-10, (self.view.frame.size.height/2)-10, 20,20)];
    [loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [loadingIndicator setHidesWhenStopped:YES];
    [myWebView addSubview:loadingIndicator];
    [myWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

    
    myWebView.scalesPageToFit = YES;
    NSURL *url = [NSURL URLWithString:myRow.myData];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:urlRequest];
    
    UIBarButtonItem *backButton = [self barItemWithImage:[UIImage imageNamed:@"webViewBack.png"] 
                                             highlighted:[UIImage imageNamed:@"backButtonHighlighted.png"] 
                                                disabled:[UIImage imageNamed:@"backButtonDisabled.png"] 
                                                  target:self 
                                                  action:@selector(goBack)];
    
    UIBarButtonItem *forwardButton = [self barItemWithImage:[UIImage imageNamed:@"webViewForward.png"] 
                                                highlighted:[UIImage imageNamed:@"forwardButtonHighlighted.png"] 
                                                   disabled:[UIImage imageNamed:@"forwardButtonDisabled.png"] 
                                                     target:self 
                                                     action:@selector(goForward)];
    
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedButton.width = 10;
    backButton.enabled = NO;
    forwardButton.enabled = NO;

    NSMutableArray *buttonItems = [NSMutableArray array];
    [buttonItems addObject:fixedButton];
    [buttonItems addObject:forwardButton];    
    [buttonItems addObject:backButton];
    
    [self.navigationItem setRightBarButtonItems:buttonItems];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    myWebView = nil;
    loadingIndicator = nil;
}

- (void)goBack
{
    if (myWebView.canGoBack)
        [myWebView goBack];
}

- (void)goForward
{
    if (myWebView.canGoForward)
        [myWebView goForward];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [loadingIndicator startAnimating];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView
{
    [loadingIndicator stopAnimating];
    UIBarButtonItem *itemGoBack = [self.navigationItem.rightBarButtonItems objectAtIndex:2];
    UIBarButtonItem *itemGoForward = [self.navigationItem.rightBarButtonItems objectAtIndex:1];
  
    if (!myWebView.canGoBack)
        itemGoBack.enabled = NO;
    else 
        itemGoBack.enabled = YES;
    
    if (!myWebView.canGoForward)
        itemGoForward.enabled = NO;
    else 
        itemGoForward.enabled = YES;

}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Webpage failed to load" 
                                                    message:@"Please check you have network availability" 
                                                   delegate:self 
                                          cancelButtonTitle: @"Cancel"
                                          otherButtonTitles:nil];
    [alert show];
}

- (UIBarButtonItem*)barItemWithImage:(UIImage*)image highlighted:(UIImage *)highlight disabled:(UIImage *)disable target:(id)target action:(SEL)action
{    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:highlight forState:UIControlStateHighlighted];
    [button setBackgroundImage:disable forState:UIControlStateDisabled];
    
    button.frame= CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    
    [button addTarget:target action:action   forControlEvents:UIControlEventTouchUpInside];
    
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    
    [v addSubview:button];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:v];
    
    return item;
}


@end
