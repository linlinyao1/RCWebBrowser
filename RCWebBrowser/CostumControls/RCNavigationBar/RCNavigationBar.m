//
//  RCNavigationBar.m
//  RCWebBrowser
//
//  Created by imac on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCNavigationBar.h"

@implementation RCNavigationBar
@synthesize bgImage = _bgImage;
@synthesize barSize = _barSize;

-(void)setBgImage:(UIImage *)bgImage
{
    if (_bgImage != bgImage) {
        [_bgImage release];
        _bgImage = [bgImage retain];
    }
    self.barSize = _bgImage.size;
}

-(void) drawRect:(CGRect)rect
{
    [self.bgImage drawInRect:CGRectMake(0, 0, self.barSize.width, self.barSize.height)];
}

- (CGSize)sizeThatFits:(CGSize)size 
{
//    CGRect frame = [UIScreen mainScreen].applicationFrame;
    CGSize newSize = CGSizeMake(self.barSize.width , self.barSize.height);
    return newSize;
}

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.barSize = frame.size;
    }
    return self;
}

@end
