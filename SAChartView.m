//
//  SAChartView.m
//  EditMyFields
//
//  Created by SCOTT ASHMORE on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SAChartView.h"

@implementation SAChartView

@synthesize myRow;
@synthesize chartDef;
@synthesize xInset;
@synthesize yInset;
@synthesize yAxisTickCount;
@synthesize xOffset;
@synthesize yOffset;
@synthesize xAxisPointLength;
@synthesize xAxisTickCount;
@synthesize xAxisTickSpace;
@synthesize yAxisPointLength;
@synthesize yAxisTickSpace;
@synthesize yUnit;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    
    self = [super initWithCoder:decoder];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)drawRect:(CGRect)rect
{
    CGRect bounds = self.bounds;
    NSLog(@"SAChartView - drawRect width %f height %f",bounds.size.width,bounds.size.height);
    chartDef = [myRow.options objectAtIndex:0];
    xInset = 40.0;
    yInset = 40.0;
    yAxisTickCount = 10.0;
    xOffset = 0.0;
    yOffset = 0.0;

    xAxisPointLength = self.bounds.size.width - (xInset * 2.0);
    xAxisTickCount = [chartDef.xLabels count];
    xAxisTickSpace = xAxisPointLength/(xAxisTickCount - 1.0);

    yAxisPointLength = self.bounds.size.height - (yInset * 2.0);
    yAxisTickSpace = yAxisPointLength/yAxisTickCount;
    yUnit = yAxisPointLength / [chartDef.yMax floatValue];
    
    // Get the graphics context
    CGContextRef ctx = UIGraphicsGetCurrentContext();
 
    // View with rounded rect
    CGContextSaveGState(ctx);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(16.0, 16.0)];
    CGContextAddPath(ctx, path.CGPath);
    CGContextClip(ctx);

    // color the background
    UIColor *fillColor = [UIColor colorWithRed:19.0f/255.0f green:77.0f/255.0f blue:132.0f/255.0f alpha:1.0f];
    CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
    CGContextFillRect(ctx, self.bounds);
    CGContextRestoreGState(ctx);
    
    // Draw the chart
    [self drawDataSetGradient:ctx];
    [self drawAxis:ctx];
    [self drawChartHeader:ctx];
    [self drawAxisLabels:ctx];
    [self drawDataPoints:ctx];
    [self drawDataLines:ctx];


}

-(void)drawAxis:(CGContextRef) ctx
{
    CGContextSaveGState(ctx);

    // set the origin of the graphics context to the lower left
    CGContextTranslateCTM(ctx, 0.0, self.bounds.size.height);
    // set the Y Axis to increase upwards
    CGContextScaleCTM(ctx, 1.0, -1.0);

    // Set the line width, color, endcaps and joins REMEMBER to add 0.5 to points when using odd line widths
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor lightGrayColor] CGColor]);
    CGContextSetLineJoin(ctx, kCGLineJoinMiter);
    CGContextSetLineCap(ctx, kCGLineCapRound);

    // Draw the Graph on the X and Y Axis use dashed lines
    CGFloat dash[] = {2.0, 2.0};
    CGContextSetLineDash(ctx, 0.0, dash, 2);
    xOffset = xAxisTickSpace;
    for (int i = 0; i < xAxisTickCount - 1; i++)
    {
        CGContextMoveToPoint(ctx, rint(xInset+xOffset) + 0.5, rint(yInset) + 0.5);
        CGContextAddLineToPoint(ctx, rint(xInset+xOffset) + 0.5,rint(self.bounds.size.height - yInset) + 0.5);
        CGContextStrokePath(ctx);
        xOffset += xAxisTickSpace;
    }

    yOffset = yAxisTickSpace;
    for (int i = 0; i < 10; i++)
    {
        CGContextMoveToPoint(ctx, rint(xInset) + 0.5, rint(yInset + yOffset) + 0.5);
        CGContextAddLineToPoint(ctx, rint(self.bounds.size.width - xInset) + 0.5, rint(yInset + yOffset) + 0.5);
        CGContextStrokePath(ctx);
        yOffset += yAxisTickSpace;
    }

    // Remove the dash
    CGContextSetLineDash(ctx, 0.0, NULL, 0.0); 
    CGContextSetStrokeColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
  
    CGContextMoveToPoint(ctx, rint(xInset) + 0.5, rint(self.bounds.size.height - yInset) + 0.5);
    CGContextAddLineToPoint(ctx, rint(xInset) + 0.5, rint(yInset) + 0.5);
    CGContextAddLineToPoint(ctx, rint(self.bounds.size.width - xInset) + 0.5, rint(yInset) + 0.5);
    CGContextStrokePath(ctx);

/*
    CGContextMoveToPoint(ctx, rint(16.0) + 0.5, rint(self.bounds.size.height - 1) + 0.5);
    CGContextAddLineToPoint(ctx, rint(self.bounds.size.width - 16.0) + 0.5, rint(self.bounds.size.height - 1) + 0.5);
    CGContextStrokePath(ctx);

    CGContextMoveToPoint(ctx, rint(16.0) + 0.5, rint(self.frame.size.height - 13) + 0.5);
    CGContextAddLineToPoint(ctx, rint(self.frame.size.width - 16.0) + 0.5, rint(self.frame.size.height - 13) + 0.5);
    CGContextStrokePath(ctx);
*/
    
    CGContextRestoreGState(ctx);
}

-(void)drawAxisLabels:(CGContextRef) ctx
{
    CGContextSaveGState(ctx);
    CGFloat shadowHeight = 2.0;
    CGContextSetShadowWithColor(ctx, CGSizeMake(1.0, -shadowHeight), 0.0, [[UIColor darkGrayColor] CGColor]);
    // Draw in the Tick Labels
    [[UIColor whiteColor] setFill];
    UIFont *fontLabels = [UIFont systemFontOfSize:14.0];

    // Get the maximum width of the labels
    float maxLabelWidth = 0.0;
    for(NSString *xLabel in chartDef.xLabels) {
        CGSize monthSize = [xLabel sizeWithFont:fontLabels];
        if(monthSize.width > maxLabelWidth)
            maxLabelWidth = monthSize.width;
    }

    // if the label is wider than the tick space then stagger the labels
    BOOL bStaggered = NO;
    if(maxLabelWidth > xAxisTickSpace)
        bStaggered = YES;
    
    xOffset = 0;
    int lineNo = 0;
    for(NSString *xLabel in chartDef.xLabels) {
        CGSize monthSize = [xLabel sizeWithFont:fontLabels];
        CGRect monthRect = CGRectMake(rint((xInset + xOffset) - (monthSize.width/2)), rint((self.bounds.size.height - yInset)), monthSize.width, monthSize.height);
        if(bStaggered && lineNo % 2)
            monthRect.origin.y = rint((self.bounds.size.height - yInset) + monthSize.height);
        [xLabel drawInRect:monthRect withFont:fontLabels];
        xOffset += xAxisTickSpace; 
        lineNo++;
    }
    float yMin = 0.0;
    if (chartDef.yMin != nil)
        yMin = [chartDef.yMin floatValue];
    float yMax = [chartDef.yMax floatValue];
    float yTick = (yMax - yMin) / 10.0;
    yOffset = yAxisTickSpace;
    float yLabelValue = yMin + yTick;
    
    for (int i = 0; i < 10; i++)
    {
        NSString *yLabel = [NSString stringWithFormat:@"%d",(int)yLabelValue];
        CGSize labelSize = [yLabel sizeWithFont:fontLabels];
        CGRect labelRect = CGRectMake(rint(xInset - labelSize.width) - 3.0, rint(self.bounds.size.height - ((yInset + yOffset) + (labelSize.height / 2))), labelSize.width, labelSize.height);
        [yLabel drawInRect:labelRect withFont:fontLabels];
        yLabelValue += yTick;
        yOffset += yAxisTickSpace;
    }    
    CGContextRestoreGState(ctx);
}


-(void)drawChartHeader:(CGContextRef) ctx
{
    CGContextSaveGState(ctx);
    CGFloat shadowHeight = 2.0;
    CGContextSetShadowWithColor(ctx, CGSizeMake(1.0, -shadowHeight), 0.0, [[UIColor darkGrayColor] CGColor]);

    [[UIColor whiteColor] setFill];
    UIFont *fontHeaders = [UIFont systemFontOfSize:20.0];
    CGSize headerSize = [chartDef.chartHeader sizeWithFont:fontHeaders];
    CGRect headerRect = CGRectMake( rint(self.center.x - (headerSize.width / 2.0)), 10.0, headerSize.width, headerSize.height);
    [chartDef.chartHeader drawInRect:headerRect withFont:fontHeaders];
    CGContextRestoreGState(ctx);

}

-(void)drawDataSetGradient:(CGContextRef) ctx
{
    if (chartDef.values2 != nil)
        return;
    
    CGContextSaveGState(ctx);
    // set the origin of the graphics context to the lower left
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    // set the Y Axis to increase upwards
    CGContextScaleCTM(ctx, 1.0, -1.0);

    // Create a clipping region under the data set
    xOffset = 0;
    float lastX = 0.0;
    CGContextMoveToPoint(ctx, xInset, yInset);
    
    for(NSString *sNum in chartDef.values) {
        float yValue = [sNum floatValue] * yUnit;
        CGContextAddLineToPoint(ctx, xInset + xOffset, yInset + yValue);
        lastX = xInset + xOffset;
        xOffset += xAxisTickSpace;
    }
    CGContextAddLineToPoint(ctx, lastX, yInset);
    CGContextClosePath(ctx);
    CGContextClip(ctx);
    
    // Create the Gradient
    UIColor *startColor = [UIColor colorWithRed:19.0f/255.0f green:77.0f/255.0f blue:132.0f/255.0f alpha:1.0f];
    UIColor *endColor = [UIColor colorWithRed:239.0f/255.0f green:237.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
    CGGradientRef   gradient;
    
    CGFloat startColorR,startColorG,startColorB,startColorA;
    CGFloat endColorR,endColorG,endColorB,endColorA;
    
    [startColor getRed:&startColorR green:&startColorG blue:&startColorB alpha:&startColorA];
    [endColor getRed:&endColorR green:&endColorG blue:&endColorB alpha:&endColorA];
    
    CGFloat colors[8] = {startColorR, startColorG, startColorB, startColorA, endColorR, endColorG, endColorB, endColorA };
    CGFloat locations[2] = { 0.05f, 0.95f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColorComponents(colorSpace,colors,locations,2);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint startPoint = CGPointMake(0.0,0.0);
    CGPoint endPoint = CGPointMake(0.0,self.bounds.size.height);
    CGContextDrawLinearGradient(ctx,gradient,startPoint,endPoint,0);
    CGGradientRelease(gradient);
    gradient = nil;
    
    CGContextRestoreGState(ctx);
}

-(void)drawDataLine:(CGContextRef)ctx witValueArray:(NSArray *)dataPoints andColor:(UIColor *)lineColor
{
    CGContextSetStrokeColorWithColor(ctx, lineColor.CGColor);
    float yTickSize = (self.bounds.size.height - (yInset * 2)) / fabsf([chartDef.yMax floatValue] - [chartDef.yMin floatValue]) ;
    float yZeroOffset =  fabsf([chartDef.yMin floatValue] * yTickSize) + yInset;
    xOffset = 0;
    BOOL bStart = YES;
    for(NSString *sNum in dataPoints) {
        float yValue = [sNum floatValue];
        if(bStart) {
            bStart = NO;
            CGContextMoveToPoint(ctx, rint(xInset + xOffset ), rint(yZeroOffset + (yValue * yTickSize)));
        }
        else {
            CGContextAddLineToPoint(ctx, rint(xInset + xOffset), rint(yZeroOffset + (yValue * yTickSize)));
        }
        xOffset += xAxisTickSpace;
    }
    CGContextStrokePath(ctx);    
}

-(void)drawDataLines:(CGContextRef) ctx
{
    CGContextSaveGState(ctx);
    // set the origin of the graphics context to the lower left
    CGContextTranslateCTM(ctx, 0.0, self.bounds.size.height);
    // set the Y Axis to increase upwards
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    // Draw the lines along datapoins
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    [self drawDataLine:ctx witValueArray:chartDef.values andColor:[UIColor whiteColor]];
    if (chartDef.values2 != nil)
        [self drawDataLine:ctx witValueArray:chartDef.values2 andColor:[UIColor yellowColor]];
    if (chartDef.values3 != nil)
        [self drawDataLine:ctx witValueArray:chartDef.values3 andColor:[UIColor redColor]];
    if (chartDef.values4 != nil)
        [self drawDataLine:ctx witValueArray:chartDef.values4 andColor:[UIColor greenColor]];
    
    CGContextRestoreGState(ctx);    
}

-(void)drawDataPoints:(CGContextRef) ctx
{
    CGContextSaveGState(ctx);
    // set the origin of the graphics context to the lower left
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    // set the Y Axis to increase upwards
    CGContextScaleCTM(ctx, 1.0, -1.0);

    [self drawDataPoint:ctx witValueArray:chartDef.values andColor:[UIColor whiteColor]];
    if (chartDef.values2 != nil)
        [self drawDataPoint:ctx witValueArray:chartDef.values2 andColor:[UIColor yellowColor]];
    if (chartDef.values3 != nil)
        [self drawDataPoint:ctx witValueArray:chartDef.values3 andColor:[UIColor redColor]];
    if (chartDef.values4 != nil)
        [self drawDataPoint:ctx witValueArray:chartDef.values4 andColor:[UIColor greenColor]];

    /*
    CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor whiteColor] CGColor]);

    // Add in dataPoints
    xOffset = 0;
    for(NSString *sNum in chartDef.values) {
        float yValue = [sNum floatValue] * yUnit;
        CGRect rect = CGRectMake(rint(xInset + xOffset - 1.0), rint(yInset + yValue - 1.0), 2.0, 2.0);
        CGContextAddEllipseInRect(ctx, rect);
        xOffset += xAxisTickSpace;
    }
    CGContextDrawPath(ctx, kCGPathFillStroke);
     */
    CGContextRestoreGState(ctx);
}

-(void)drawDataPoint:(CGContextRef)ctx witValueArray:(NSArray *)dataPoints andColor:(UIColor *)lineColor
{
    CGContextSetStrokeColorWithColor(ctx, lineColor.CGColor);
    CGContextSetFillColorWithColor(ctx, lineColor.CGColor);
    float yTickSize = (self.bounds.size.height - (yInset * 2)) / fabsf([chartDef.yMax floatValue] - [chartDef.yMin floatValue]) ;
    float yZeroOffset =  fabsf([chartDef.yMin floatValue] * yTickSize) + yInset;
    xOffset = 0;
    for(NSString *sNum in dataPoints) {
        float yValue = [sNum floatValue];
        CGRect rect = CGRectMake(rint(xInset + xOffset - 1.0), rint(yZeroOffset + (yValue * yTickSize) - 1.0), 2.0, 2.0);
        CGContextAddEllipseInRect(ctx, rect);
        xOffset += xAxisTickSpace;
    }
    CGContextDrawPath(ctx, kCGPathFillStroke);   
}

@end
