//
//  CameraSessionManager.m
//  iOS-SFCustomCamera
//
//  Created by Scott Freschet on 8/5/13.
//  Copyright (c) 2013 Scott Freschet. All rights reserved.
//

#import "CameraSessionManager.h"

@implementation CameraSessionManager

- (id)init
{
	if ((self = [super init]))
    {
        self.captureSession = [[AVCaptureSession alloc]init];
	}
	return self;
}

- (void)addVideoPreviewLayer
{
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
}

- (void)addVideoInput
{
	AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	if (videoDevice)
    {
		NSError *error;
		AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
		if (!error)
        {
            if ([self.captureSession canAddInput:videoIn])
            {
                [self.captureSession addInput:videoIn];
            }
			else
            {
                NSLog(@"Couldn't add video input");
            }
		}
		else
			NSLog(@"Couldn't create video input");
	}
	else
		NSLog(@"Couldn't create video capture device");
}

- (void)addImageOutput
{
    self.imageOutput = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary* outputSettings = [[NSDictionary alloc]initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.imageOutput setOutputSettings:outputSettings];
    
    [self.captureSession addOutput:self.imageOutput];
}

@end
