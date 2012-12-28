//
//  SAOverlay.h
//  EditMyFields
//
//  Created by Bob Ashmore on 20/02/2012.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SAOverlay : UIControl

@property(strong, nonatomic) CATextLayer *faceLayer;
@property(strong, nonatomic) NSString *text; 

- (void)setUpControl;
-(float) maxFontSizeThatFitsForString:(NSString*)_string inRect:(CGRect)rect withFont:(NSString *)fontName;

@end
