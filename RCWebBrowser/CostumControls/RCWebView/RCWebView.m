//
//  RCWebView.m
//  RCWebBrowser
//
//  Created by imac on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCWebView.h"
#import "RCFastLinkView.h"

@implementation RCWebView
@synthesize isDefaultPage = _isDefaultPage;




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self turnOnDefaultPage];
        self.scalesPageToFit = YES;

    }
    return self;
}

-(void)turnOnDefaultPage
{
    [[RCFastLinkView defaultPage] reloadIcons];
    [self addSubview:[RCFastLinkView defaultPage]];
    self.isDefaultPage = YES;
}
-(void)turnOffDefaultPage
{
    [[RCFastLinkView defaultPage] removeFromSuperview];
    [self reload];
    self.isDefaultPage = NO;
}

-(BOOL)canGoBack
{
    if (self.isDefaultPage){
        return NO;
    }else {
        return YES;
    }
}

-(BOOL)canGoForward
{
    if (self.isDefaultPage ) {
        if (self.request) {
            return YES;
        }else {
            return NO;
        }
    }else {
        if ([super canGoForward]) {
            return YES;
        }else {
            return NO;
        }
    }
}

-(void)goBack
{
    if (![self canGoBack]) {
        return;
    }
    
    if (![super canGoBack]) {
        [self turnOnDefaultPage];
    }else {
        [super goBack];
    }
}

-(void)goForward
{
    if (![self canGoForward]) {
        return;
    }
    
    if (self.isDefaultPage && self.request) {
        [self turnOffDefaultPage];
    }else {
        [super goForward];
    }
}





@end
