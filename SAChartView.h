//
//  SAChartView.h
//  EditMyFields
//
//  Created by SCOTT ASHMORE on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAEditViewController.h"
#import "SAOverlay.h"

@interface SAChartView : UIView

@property (strong, nonatomic) SARow *myRow;
@property (strong, nonatomic) SAChartDef *chartDef;

@property (nonatomic) double xInset;
@property (nonatomic) double yInset;
@property (nonatomic) double yAxisTickCount;
@property (nonatomic) double xOffset;
@property (nonatomic) double yOffset;

@property (nonatomic) double xAxisPointLength;
@property (nonatomic) double xAxisTickCount;
@property (nonatomic) double xAxisTickSpace;

@property (nonatomic) double yAxisPointLength;
@property (nonatomic) double yAxisTickSpace;
@property (nonatomic) double yUnit;


-(void)drawDataSetGradient:(CGContextRef) ctx;
-(void)drawAxis:(CGContextRef) ctx;
-(void)drawChartHeader:(CGContextRef) ctx;
-(void)drawAxisLabels:(CGContextRef) ctx;
-(void)drawDataPoints:(CGContextRef) ctx;
-(void)drawDataLines:(CGContextRef) ctx;
-(void)drawDataLine:(CGContextRef)ctx witValueArray:(NSArray *)dataPoints andColor:(UIColor *)lineColor;
-(void)drawDataPoint:(CGContextRef)ctx witValueArray:(NSArray *)dataPoints andColor:(UIColor *)lineColor;


@end
