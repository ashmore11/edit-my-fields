//
//  SAAnnotationEdit.h
//  EditMyFields
//
//  Created by SCOTT ASHMORE on 10/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMapAnnotations.h"
#import "SARow.h"

@protocol SAAnnotationEditProtocol <NSObject>

- (void)removePin:(SAMapAnnotations *)annotation;

@end

@interface SAAnnotationEdit : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet UITextField *subTitleField;
@property (strong, nonatomic) SAMapAnnotations *annotation;
@property (strong, nonatomic)  id <SAAnnotationEditProtocol> delegate;
@property (strong, nonatomic) SARow *myRow;
@property int tag;


- (IBAction)removePressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)textFieldDone:(id)sender;

@end
