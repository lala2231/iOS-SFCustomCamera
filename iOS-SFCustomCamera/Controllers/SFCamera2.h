//
//  SFCamera2.h
//  iOS-SFCustomCamera
//
//  Created by Scott Freschet on 8/5/13.
//  Copyright (c) 2013 Scott Freschet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraSessionManager.h"
#import "ScreenshotUtils.h"

// Notification Constants
extern NSString* const NOTIFICATION_CREATE_OBJECT_WITH_CAMERA;
extern NSString* const NOTIFICATION_CREATE_OBJECT_WITH_CAMERA_DK_SCREENSHOT;
extern NSString* const NOTIFICATION_CAMERA_START;
extern NSString* const NOTIFICATION_CAMERA_START_DK_SCREENSHOT;
extern NSString* const NOTIFICATION_CAMERA_DONE;
extern NSString* const NOTIFICATION_CAMERA_DONE_DK_IMAGE;
extern NSString* const NOTIFICATION_CAMERA_DONE_DK_SCREENSHOT;

@interface SFCamera2 : UIViewController

// Variables.
@property (retain) CameraSessionManager *cameraManager;
@property (strong, nonatomic) ScreenshotUtils* xScreenshotUtils;

// IBOutlets.
@property (nonatomic, strong) IBOutlet UIImageView* xImageView_Screenshot;
@property (strong, nonatomic) IBOutlet UIView* xView_MainView;
@property (strong, nonatomic) IBOutlet UIImageView* xImageView_Camera;
@property (strong, nonatomic) IBOutlet UIImageView* xImageView_CameraIcon;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer* xGesture_CameraIconLongPress;
@property (strong, nonatomic) IBOutlet UIImageView* xImageView_CancelIcon;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer* xTapGestureRecognizer_CancelIconTap;

@property (strong, nonatomic) IBOutlet UIView* xView_2_MainView;
@property (strong, nonatomic) IBOutlet UIImageView* xImageView_2_CapturedImage;
@property (strong, nonatomic) IBOutlet UIImageView* xImageView_2_BackIcon;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer* xTapGestureRecognizer_BackIconTap;
@property (strong, nonatomic) IBOutlet UIImageView* xImageView_2_AcceptIcon;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer* xGestureRecognizer_AcceptIconLongPress;


// IBActions.
-(IBAction)cancelIconTapped:(id)sender;
-(IBAction)cameraIconLongPressed:(UILongPressGestureRecognizer*)sender;
-(IBAction)backIconTapped:(id)sender;
-(IBAction)acceptIconLongPressed:(UILongPressGestureRecognizer*)sender;

@end
