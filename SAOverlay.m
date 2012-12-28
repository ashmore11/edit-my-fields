//
//  SAOverlay.m
//  EditMyFields
//
//  Created by Bob Ashmore on 20/02/2012.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "SAOverlay.h"

@implementation SAOverlay

@synthesize faceLayer;
@synthesize text = text_;


- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self setUpControl];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setUpControl];
    }
    return self;
}

- (void) setText:(NSString *)text
{
    text_ = nil;
    text_ = [text copy];
    faceLayer.string = text_;
    float fontSize = [self maxFontSizeThatFitsForString:faceLayer.string inRect:self.bounds withFont:@"Helvetica"]; 
    faceLayer.fontSize = fontSize-5;

}

- (void)setUpControl {
    
    self.userInteractionEnabled = NO;
    self.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    self.layer.shadowOpacity = 0.9;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.masksToBounds = NO;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = self.bounds;
    gradientLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[UIColor colorWithRed:95.0f/255.0f green:158.0f/255.0f blue:231.0f/255.0f alpha:0.7f].CGColor,
                            (id)[UIColor colorWithRed:0.0f/255.0f green:47.0f/255.0f blue:120.0f/255.0f alpha:0.7f].CGColor,
                            nil];
    gradientLayer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.00f],
                               [NSNumber numberWithFloat:1.00f],
                               nil];
    [self.layer addSublayer:gradientLayer];
    gradientLayer.cornerRadius = 12.0;
    
    [self.layer addSublayer:gradientLayer];
    
    faceLayer = [CATextLayer layer];
    faceLayer.string = self.text;
    
    CGRect faceRect = CGRectInset(self.bounds, 1.0f, 1.0f);
    
    faceLayer.shadowOpacity = 0.9f;
    faceLayer.shadowOffset = CGSizeMake(0.0, 2.0);
    faceLayer.foregroundColor = [[UIColor whiteColor] CGColor];
    faceLayer.string = @"Unset";
    float fontSize = [self maxFontSizeThatFitsForString:faceLayer.string inRect:faceRect withFont:@"Helvetica"]; 
    faceLayer.fontSize = fontSize-5;
    faceLayer.alignmentMode = @"center";
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:fontSize-5];
    faceLayer.anchorPoint = CGPointMake(0.0, 0.0);
    faceLayer.position = CGPointMake(0,(faceRect.size.height/2) - ([font capHeight]/2));
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    faceLayer.contentsScale = scale;
    faceLayer.bounds = faceRect;
    
    [self.layer addSublayer:faceLayer];
    
    CALayer *borderLayer = [CALayer layer];
    CGRect borderRect = CGRectInset(self.bounds, 3.0f, 3.0f);
    [borderLayer setCornerRadius:12.0f];
    [borderLayer setBorderColor:[UIColor colorWithRed:23.0f/255.0f green:61.0f/255.0f blue:109.0f/255.0f alpha:1.0f].CGColor];
    [borderLayer setBorderWidth:2.0f];
    [borderLayer setFrame:borderRect];
    
    [self.layer addSublayer:borderLayer];
}

-(float) maxFontSizeThatFitsForString:(NSString*)_string inRect:(CGRect)rect withFont:(NSString *)fontName  {   
    // this is the maximum size font that will fit on the device
    float _fontSize = 100;
    float fontDelta = 2.0;
    
    CGSize tallerSize = CGSizeMake(rect.size.width, 100000);
    CGSize stringSize = [_string sizeWithFont:[UIFont fontWithName:fontName size:_fontSize] constrainedToSize:tallerSize];
    
    while (stringSize.height >= rect.size.height)
    {       
        _fontSize -= fontDelta;
        stringSize = [_string sizeWithFont:[UIFont fontWithName:fontName size:_fontSize] constrainedToSize:tallerSize];
    }
    
    return _fontSize;
}


@end
