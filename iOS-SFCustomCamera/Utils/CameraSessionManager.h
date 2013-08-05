//
//  CameraSessionManager.h
//  iOS-SFCustomCamera
//
//  Created by Scott Freschet on 8/5/13.
//  Copyright (c) 2013 Scott Freschet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

@interface CameraSessionManager : NSObject

@property (retain) AVCaptureSession* captureSession;
@property (retain) AVCaptureVideoPreviewLayer* previewLayer;
@property (retain) AVCaptureStillImageOutput* imageOutput;

- (void)addVideoPreviewLayer;
- (void)addVideoInput;
- (void)addImageOutput;



@end
