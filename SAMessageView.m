//
//  SAMessageView.m
//  EditMyFields
//
//  Created by SCOTT ASHMORE on 22/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SAMessageView.h"

@implementation SAMessageView

@synthesize popInTimer;
@synthesize adjustX;
@synthesize adjustY;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)showWithTimer:(CGFloat)timer inView:(UIView *)view bounce:(BOOL)bounce withText:(NSString *)title
{
    // search the view to see if a class of this type is allready in the view
    // if so dont show this view again
    for (UIView *subView in view.subviews) {
        if([subView isMemberOfClass:[SAMessageView class]]) {
            return;
        }
    }
    
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    // Get the the screen size and the orientation
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    // set the proper size of the view dependending on the orientation
    float frameWidth = 0.0;
    if(orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown)
        frameWidth =  screenRect.size.width;
    else if(orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight)
        frameWidth =  screenRect.size.height;

    // set the frame to be just above the visible view of the area
    [self setFrame:CGRectMake(0, -55 +((UIScrollView *)view).contentOffset.y ,frameWidth, 55)];
    self.layer.anchorPoint = CGPointMake(0, 0);
    
    // add a gradient and border to the view
    [self addGradientLayer];

    // add a label to the view
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(5, 15, self.bounds.size.width - 5, 25);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor darkGrayColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = title;
    label.textAlignment = UITextAlignmentCenter;
    [self addSubview:label];
    
    // calculate the on screen position on the view
    self.adjustX = 0;
    self.adjustY = self.bounds.size.height;
    CGPoint fromPos = CGPointMake(0, -self.bounds.size.height +((UIScrollView *)view).contentOffset.y);
    if (bounce)
    {
        CGPoint toPos = fromPos;
        CGPoint bouncePos = fromPos;
        // bounce it just below where it will end up
        bouncePos.x += (adjustX * 1.4);
        bouncePos.y += (adjustY * 1.4);
        toPos.x += adjustX;
        toPos.y += adjustY;
        CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        keyFrame.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCGPoint:fromPos],
                           [NSValue valueWithCGPoint:bouncePos],
                           [NSValue valueWithCGPoint:toPos],
                           nil];
        
        keyFrame.keyTimes = [NSArray arrayWithObjects:
                             [NSNumber numberWithFloat:0],
                             [NSNumber numberWithFloat:0.7],
                             [NSNumber numberWithFloat:1.0],
                             nil];
        
        keyFrame.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        keyFrame.duration = 0.75;
        self.layer.position = toPos;
        [self.layer addAnimation:keyFrame forKey:@"keyFrame"];
    }
    else
    {
        CGPoint toPos = fromPos;
        toPos.x += adjustX;
        toPos.y += adjustY;
        
        [UIView animateWithDuration:0.75
                         animations:^{ 
                             self.layer.position = fromPos;
                             self.layer.position = toPos;
                         } 
                         completion:^(BOOL finished){
                            self.layer.position = toPos;        
                         }];
    }
    popInTimer = [NSTimer scheduledTimerWithTimeInterval:timer target:self selector:@selector(popIn) userInfo:nil repeats:NO];
    [view addSubview:self];
}

- (void)popIn
{
    [UIView animateWithDuration:0.75
                     animations:^{ 
                         self.frame = CGRectOffset(self.frame, -adjustX, -adjustY);
                     } 
                     completion:^(BOOL finished){
                         [self removeFromSuperview];    
                     }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [popInTimer invalidate];
    [self popIn];
}

-(void)addGradientLayer
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = self.bounds;
    gradientLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[UIColor colorWithRed:95.0f/255.0f green:158.0f/255.0f blue:231.0f/255.0f alpha:0.9f].CGColor,
                            (id)[UIColor colorWithRed:0.0f/255.0f green:47.0f/255.0f blue:120.0f/255.0f alpha:0.9f].CGColor,
                            nil];
    gradientLayer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.00f],
                               [NSNumber numberWithFloat:1.00f],
                               nil];
    [self.layer addSublayer:gradientLayer];
    gradientLayer.cornerRadius = 12.0;
    
    [self.layer addSublayer:gradientLayer];
    
    CALayer *borderLayer = [CALayer layer];
    CGRect borderRect = CGRectInset(self.bounds, 3.0f, 3.0f);
    [borderLayer setCornerRadius:12.0f];
    [borderLayer setBorderColor:[UIColor colorWithRed:23.0f/255.0f green:61.0f/255.0f blue:109.0f/255.0f alpha:1.0f].CGColor];
    [borderLayer setBorderWidth:2.0f];
    [borderLayer setFrame:borderRect];
    
    [self.layer addSublayer:borderLayer];
}

@end
