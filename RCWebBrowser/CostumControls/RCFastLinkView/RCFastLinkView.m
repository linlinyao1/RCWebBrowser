//
//  RCFastLinkView.m
//  RCWebBrowser
//
//  Created by imac on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCFastLinkView.h"

@implementation RCFastLinkView

static RCFastLinkView *_fastLinkView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

+(id)defaultPage
{
    if (!_fastLinkView) {
        _fastLinkView = [[RCFastLinkView alloc] initWithFrame:CGRectMake(0, 0, 320, 328)];
    }
    return _fastLinkView;
}

@end
