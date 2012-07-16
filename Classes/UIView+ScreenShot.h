//
//  UIView+ScreenShot.h
//  RCWebBrowser
//
//  Created by imac on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ScreenShot)
+(UIImage*)captureView:(UIView *)theView;
//+(UIImage*)captureView:(UIView *)theView WithRect:(CGRect)rect;

@end
