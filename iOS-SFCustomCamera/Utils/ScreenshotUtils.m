//
//  ScreenshotUtils.m
//  iOS-SFCustomCamera
//
//  Created by Scott Freschet on 8/5/13.
//  Copyright (c) 2013 Scott Freschet. All rights reserved.
//

#import "ScreenshotUtils.h"
#import <QuartzCore/QuartzCore.h>

@implementation ScreenshotUtils

-(UIImage*)getScreenshotImage:(UIViewController*)viewController
{
    // Save screenshot.
    CGSize imageSize = viewController.view.bounds.size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [[viewController.view layer] renderInContext:context];
    CGContextRestoreGState(context);
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenShot;
}

@end
