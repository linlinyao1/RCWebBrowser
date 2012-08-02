//
//  UIBarButtonItem+BackStyle.m
//  RCBMITest
//
//  Created by imac on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIBarButtonItem+BackStyle.h"




@implementation UIBarButtonItem (BackStyle)

+(UIBarButtonItem *)barButtonWithBackStyle:(RCBarButtonStyle)style Title:(NSString *)title Target:(id)target Action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (style == RCBarButtonBackStyle) {
        [button setBackgroundImage:[UIImage imageNamed:@"navBarPre"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"navBarPre_hover"] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"navBarPre_hover"] forState:UIControlStateSelected];
    }else {
        [button setBackgroundImage:[UIImage imageNamed:@"navBarNext"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"navBarNext_hover"] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"navBarNext_hover"] forState:UIControlStateSelected];
    }
    button.frame = CGRectMake(0, 0, 72, 30.5);
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    return barButton;
}


+(UIBarButtonItem *)barButtonWithCustomImage:(UIImage *)image HilightImage:(UIImage *)highlightImage Title:(NSString *)title Target:(id)target Action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    if (highlightImage) {
        [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
        [button setBackgroundImage:highlightImage forState:UIControlStateSelected];
    }
    button.frame = CGRectMake(0, 0, image.size.width/2, image.size.height/2);
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    return barButton;
}


@end
