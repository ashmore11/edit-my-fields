//
//  SAChartController.h
//  EditMyFields
//
//  Created by SCOTT ASHMORE on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAEditViewController.h"
#import "SAChartView.h"

@interface SAChartController : UIViewController

@property (strong, nonatomic) SARow *myRow;
@property (strong, nonatomic) IBOutlet SAChartView *myChartView;

@end
