//
//  RCBookMarkPop.h
//  RCWebBrowser
//
//  Created by imac on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookmarkObject.h"

@protocol RCBookMarkPopDelegate <NSObject>
-(BookmarkObject*)currentWebInfo;
-(UIWebView*)currentWeb;
-(void)highlightBookMarkButton:(BOOL)isHighlight;
@end

@interface RCBookMarkPop : UIView
@property (nonatomic,assign) NSObject<RCBookMarkPopDelegate> *delegate;

-(void)updateBttonState;
@end
