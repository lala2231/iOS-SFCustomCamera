//
//  SFCamera2.m
//  iOS-SFCustomCamera
//
//  Created by Scott Freschet on 8/5/13.
//  Copyright (c) 2013 Scott Freschet. All rights reserved.
//

#import "SFCamera2.h"

#define radians(degrees) (degrees * M_PI/180)

////////////////////////////////////////////////////////
#pragma mark - Notification Constants.
////////////////////////////////////////////////////////
NSString* const NOTIFICATION_CREATE_OBJECT_WITH_CAMERA = @"notification_create_object_with_camera";
NSString* const NOTIFICATION_CREATE_OBJECT_WITH_CAMERA_DK_SCREENSHOT = @"notification_create_object_with_camera_dk_screenshot";
NSString* const NOTIFICATION_CAMERA_START = @"notification_camera_start";
NSString* const NOTIFICATION_CAMERA_START_DK_SCREENSHOT = @"notification_camera_start_dk_screenshot";
NSString* const NOTIFICATION_CAMERA_DONE = @"notification_camera_done";
NSString* const NOTIFICATION_CAMERA_DONE_DK_IMAGE = @"notification_camera_done_dk_image";
NSString* const NOTIFICATION_CAMERA_DONE_DK_SCREENSHOT = @"notification_camera_done_dk_screenshot";

@interface SFCamera2 ()
@end

@implementation SFCamera2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Initialize variables.
    self.xScreenshotUtils= [[ScreenshotUtils alloc]init];
    
    // Register notification callbacks.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_Camera_Start:) name:NOTIFICATION_CAMERA_START object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////
#pragma mark - Notification Handlers
////////////////////////////////////////////////////////

-(void)notification_Camera_Start:(NSNotification*) notification
{
    NSLog(@"notification_Camera_Start");
    
    // Variables.
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = self.view.frame.size.height;
    
    //
    // Setup Camera.
    //
    self.cameraManager = [[CameraSessionManager alloc]init];
    [self.cameraManager addVideoPreviewLayer];
    [self.cameraManager addVideoInput];
    [self.cameraManager addImageOutput];
    self.cameraManager.captureSession.sessionPreset = AVCaptureSessionPreset640x480;
    self.cameraManager.previewLayer.frame = CGRectMake(0, 0, 310, (310*640)/480);
    [self.xImageView_Camera.layer addSublayer:self.cameraManager.previewLayer];
    self.xImageView_Camera.clipsToBounds = YES;
    self.xImageView_Camera.layer.borderColor = [UIColor whiteColor].CGColor;
    self.xImageView_Camera.layer.borderWidth = 2.0;
    [self.cameraManager.captureSession startRunning];
    
    //
    // Setup mainView.
    //
    [self.xView_MainView setFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    [self.xView_MainView bringSubviewToFront:self.xImageView_CameraIcon];
    self.xImageView_CameraIcon.userInteractionEnabled = NO;
    [self.xView_MainView bringSubviewToFront:self.xImageView_CancelIcon];
    self.xImageView_CancelIcon.userInteractionEnabled = NO;
    
    
    //
    // Setup secondView.
    //
    
    self.xView_2_MainView = [[UIView alloc]initWithFrame:CGRectMake(viewWidth, 0, viewWidth, viewHeight)];
    self.xView_2_MainView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.xView_2_MainView];
    
    // Load view from nib.
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"SFCamera2_View" owner:self options:nil];
    [self.xView_2_MainView addSubview:[nibs objectAtIndex:0]];
    
    // Setup xImageView_2_CapturedImage.
    self.xImageView_2_CapturedImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.xImageView_2_CapturedImage.layer.borderWidth = 2.0;
    
    // Setup xImageView_x_AcceptIcon.
    CGFloat acceptIconWidth = self.xImageView_2_AcceptIcon.frame.size.width;
    CGFloat acceptIconHeight = self.xImageView_2_AcceptIcon.frame.size.height;
    self.xImageView_2_AcceptIcon.frame = CGRectMake((viewWidth/2 -acceptIconWidth/2), (viewHeight - acceptIconHeight - 10), acceptIconWidth, acceptIconHeight);
    
    
    //
    // Grab the notification data.
    //
    NSDictionary* data = [notification object];
    //self.xString_CreateObject = [data objectForKey:NOTIFICATION_CAMERA_START_DK_CREATE_OBJECT];
    UIImage* screenshot = [data objectForKey:NOTIFICATION_CAMERA_START_DK_SCREENSHOT];
    
    // Setup xImageView_Screenshot.
    self.xImageView_Screenshot.image = screenshot;
        
    // Prepare mainView for animation.
    [self.xView_MainView setFrame:CGRectMake(0, -viewHeight, viewWidth, viewHeight)];
    
    // Start annimation.
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
     {
         [self.xView_MainView setFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
     }
                     completion:^(BOOL finished){
                         self.xImageView_CameraIcon.userInteractionEnabled = YES; // Enable userInteraction.
                         self.xImageView_CancelIcon.userInteractionEnabled = YES; // Enable userInteraction.
                         [self.xImageView_Screenshot removeFromSuperview]; // remove imageView now in background.
                     }];
}


////////////////////////////////////////////////////////
#pragma mark - IBActions
////////////////////////////////////////////////////////

-(IBAction)cancelIconTapped:(id)sender
{
    // Get screenshot.
    UIImage* screenshot = [self.xScreenshotUtils getScreenshotImage:self];
    
    // Prepare notification with data.
    NSDictionary* data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          screenshot, NOTIFICATION_CAMERA_DONE_DK_SCREENSHOT,
                          nil];
     
    [self dismissViewControllerAnimated:NO completion:^
     {
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CAMERA_DONE object:data];
     }];
}

-(IBAction)cameraIconLongPressed:(UILongPressGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        self.xImageView_CameraIcon.highlighted = YES;
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [sender locationInView:self.view];
        if ((point.x - self.xImageView_CameraIcon.center.x > 40) || (point.x - self.xImageView_CameraIcon.center.x < -40) || (point.y - self.xImageView_CameraIcon.center.y > 40) || (point.y - self.xImageView_CameraIcon.center.y < -40))
        {
            self.xImageView_CameraIcon.highlighted = NO;
            sender.enabled = NO;
            sender.enabled = YES;
        }
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        self.xImageView_CameraIcon.highlighted = NO;
        
        // If camera is available... use camera code.
        BOOL cameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if (cameraAvailable)
        {
            AVCaptureConnection *videoConnection = nil;
            for (AVCaptureConnection *connection in self.cameraManager.imageOutput.connections)
            {
                for (AVCaptureInputPort *port in connection.inputPorts)
                {
                    if ([port.mediaType isEqual:AVMediaTypeVideo])
                    {
                        videoConnection = connection;
                        break;
                    }
                }
                if (videoConnection) { break; }
            }
            
            [self.cameraManager.imageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
             {
                 if (imageSampleBuffer)
                 {
                     NSLog(@"image retrieved");
                 }
                 else
                 {
                     NSLog(@"image NOT retrieved");
                 }
                 NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                 UIImage *image = [[UIImage alloc] initWithData:imageData];
                 NSLog(@"image size is: %f/%f", image.size.width, image.size.height);
                 
                 // Draw image into square rectangle.
                 CGRect rect = CGRectMake(0, 0, 480, 480);
                 CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
                 CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
                 CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
                 CGContextRef bitmap = CGBitmapContextCreate(NULL, rect.size.width, rect.size.height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
                 
                 if (image.imageOrientation == UIImageOrientationLeft) {
                     CGContextRotateCTM (bitmap, radians(90));
                     CGContextTranslateCTM (bitmap, 0, -rect.size.height);
                     
                 } else if (image.imageOrientation == UIImageOrientationRight) {
                     CGContextRotateCTM (bitmap, radians(-90));
                     CGContextTranslateCTM (bitmap, -rect.size.width, 0);
                     
                 } else if (image.imageOrientation == UIImageOrientationUp) {
                     // NOTHING
                 } else if (image.imageOrientation == UIImageOrientationDown) {
                     CGContextTranslateCTM (bitmap, rect.size.width, rect.size.height);
                     CGContextRotateCTM (bitmap, radians(-180));
                 }
                 
                 CGContextDrawImage(bitmap, CGRectMake(0, 0, rect.size.width, rect.size.height), imageRef);
                 CGImageRef ref = CGBitmapContextCreateImage(bitmap);
                 UIImage *newImage=[UIImage imageWithCGImage:ref];
                 CGImageRelease(imageRef);
                 CGContextRelease(bitmap);
                 CGImageRelease(ref);
                 
                 // Update capturedImage.
                 NSLog(@"newImage size is: %f/%f", newImage.size.width, newImage.size.height);
                 self.xImageView_2_CapturedImage.image = newImage;
                 
                 // Start annimation.
                 [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
                  {
                      [self.xView_MainView setFrame:CGRectMake(-self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
                      [self.xView_2_MainView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                  }
                                  completion:^(BOOL finished){}];
             }];
        }
        else
        {
            // Update capturedImage.
            self.xImageView_2_CapturedImage.image = [UIImage imageNamed:@"Pix_Kai2.png"];
            
            // Start annimation.
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
             {
                 [self.xView_MainView setFrame:CGRectMake(-self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
                 [self.xView_2_MainView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
             }
                             completion:^(BOOL finished){}];
        }
        
    }
    
}

-(IBAction)backIconTapped:(id)sender
{
    // Start annimation.
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
     {
         [self.xView_MainView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
         [self.xView_2_MainView setFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
     }
                     completion:^(BOOL finished){
                         self.xImageView_2_CapturedImage.image = nil;
                     }];
}
-(IBAction)acceptIconLongPressed:(UILongPressGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        self.xImageView_2_AcceptIcon.highlighted = YES;
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [sender locationInView:self.view];
        if ((point.x - self.xImageView_2_AcceptIcon.center.x > 40) || (point.x - self.xImageView_2_AcceptIcon.center.x < -40) || (point.y - self.xImageView_2_AcceptIcon.center.y > 40) || (point.y - self.xImageView_2_AcceptIcon.center.y < -40))
        {
            self.xImageView_2_AcceptIcon.highlighted = NO;
            sender.enabled = NO;
            sender.enabled = YES;
        }
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        self.xImageView_2_AcceptIcon.highlighted = NO;
        
        // Grab screenshot.
        UIImage* screenshot = [self.xScreenshotUtils getScreenshotImage:self];
        
        // Prepare notification with data.
        NSDictionary* data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              screenshot, NOTIFICATION_CAMERA_DONE_DK_SCREENSHOT,
                              nil];
        
        // Dismiss viewController
        [self dismissViewControllerAnimated:NO completion:^
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CAMERA_DONE object:data];
         }];
    }
}


@end
