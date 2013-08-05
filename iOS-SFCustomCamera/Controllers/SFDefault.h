//
//  SFDefault.h
//  iOS-SFCustomCamera
//
//  Created by Scott Freschet on 8/5/13.
//  Copyright (c) 2013 Scott Freschet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreenshotUtils.h"
#import "SFCamera2.h"

@interface SFDefault : UIViewController

// Variables.
@property (strong, nonatomic) ScreenshotUtils* xScreenshotUtils;

// IBOutlets.
@property (strong, nonatomic) IBOutlet UIImageView* xImageView_Camera;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer* xGesture_CameraLongPress;

// IBActions.
-(IBAction)cameraLongPressed:(UILongPressGestureRecognizer*)sender;

@end
