//
//  UIBarButtonItem+BackStyle.h
//  RCBMITest
//
//  Created by imac on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    RCBarButtonBackStyle,    
    RCBarButtonForwardStyle
} RCBarButtonStyle;

@interface UIBarButtonItem (BackStyle)

+(UIBarButtonItem*)barButtonWithBackStyle:(RCBarButtonStyle)style 
                                    Title:(NSString*)title 
                                   Target:(id)target 
                                   Action:(SEL)action;

+(UIBarButtonItem*)barButtonWithCustomImage:(UIImage*)image
                               HilightImage:(UIImage*)highlightImage                    
                                    Title:(NSString*)title 
                                   Target:(id)target 
                                   Action:(SEL)action;
@end
