//
//  SFDefault.m
//  iOS-SFCustomCamera
//
//  Created by Scott Freschet on 8/5/13.
//  Copyright (c) 2013 Scott Freschet. All rights reserved.
//

#import "SFDefault.h"

@interface SFDefault ()

@end

@implementation SFDefault

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
    self.xScreenshotUtils = [[ScreenshotUtils alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_Camera_Done:) name:NOTIFICATION_CAMERA_DONE object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////////////////////////////////////////
#pragma mark - Notification Callbacks.
///////////////////////////////////////////////////////////////////

-(void)notification_Camera_Done:(NSNotification*) notification
{
    // Grab the notification data.
    NSDictionary* data = [notification object];
    
    UIImageView* screenshot = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    screenshot.image = [data objectForKey:NOTIFICATION_CAMERA_DONE_DK_SCREENSHOT];
    [self.view addSubview:screenshot];
    
    // Annimate.
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
     {
         [screenshot setFrame:CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
     }
                     completion:^(BOOL finished)
    {
        [screenshot removeFromSuperview];
    }];
}


///////////////////////////////////////////////////////////////////
#pragma mark - IBActions.
///////////////////////////////////////////////////////////////////

-(IBAction)cameraLongPressed:(UILongPressGestureRecognizer*)sender
{
    NSLog(@"cameraLongpressed");
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        self.xImageView_Camera.highlighted = YES;
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [sender locationInView:self.view];
        if ((point.x - self.xImageView_Camera.center.x > 40) || (point.x - self.xImageView_Camera.center.x < -40) || (point.y - self.xImageView_Camera.center.y > 40) || (point.y - self.xImageView_Camera.center.y < -40))
        {
            self.xImageView_Camera.highlighted = NO;
            sender.enabled = NO;
            sender.enabled = YES;
        }
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        self.xImageView_Camera.highlighted = NO;
        
        // Grab screenshot.
        UIImage* screenshot = [self.xScreenshotUtils getScreenshotImage:self];
        
        // Prepare notification with data.
        NSDictionary* data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              screenshot, NOTIFICATION_CAMERA_START_DK_SCREENSHOT,
                              nil];
        
        // Segue to SFCamera2.
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController* SFCamera1 = [storyboard instantiateViewControllerWithIdentifier:@"SFCamera2"];
        [self presentViewController:SFCamera1 animated:NO completion:^
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CAMERA_START object:data];
         }];
    }
    
}



@end
