//
//  UIView+ScreenShot.m
//  RCWebBrowser
//
//  Created by imac on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIView+ScreenShot.h"
#import "QuartzCore/QuartzCore.h"

@implementation UIView (ScreenShot)
+(UIImage*)captureView:(UIView *)theView
{
//    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
//        UIGraphicsBeginImageContextWithOptions(theView.bounds.size, NO, [UIScreen mainScreen].scale);
//    else
        UIGraphicsBeginImageContext(CGSizeMake(64, 64)); //theView.bounds.size
//    CGRect rect = theView.frame;
//    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//+(UIImage*)captureView:(UIView *)theView WithRect:(CGRect)rect
//{
//    UIImage*mainImage = [UIView captureView:<#(UIView *)#>]
//    
//  
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(img.CGImage, rect);  
//    CGRect smallBounds = CGRectMake(rect.origin.x, rect.origin.y, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));  
//    
//    UIGraphicsBeginImageContext(smallBounds.size);  
//    CGContextDrawImage(UIGraphicsGetCurrentContext(), smallBounds, subImageRef);  
//    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];  
//    UIGraphicsEndImageContext();  
//    
//    return smallImage;  
//}

@end
