//
//  SAMessageView.h
//  EditMyFields
//
//  Created by SCOTT ASHMORE on 22/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SAMessageView : UIView

@property (strong, nonatomic) NSTimer *popInTimer;
@property (nonatomic) CGFloat adjustX;
@property (nonatomic) CGFloat adjustY;

- (void)showWithTimer:(CGFloat)timer inView:(UIView *)view bounce:(BOOL)bounce withText:(NSString *)title;
-(void)addGradientLayer;

@end
