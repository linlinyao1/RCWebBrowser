//
//  RCWebView.h
//  RCWebBrowser
//
//  Created by imac on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCWebView : UIWebView 

//@property (nonatomic,retain)RCFastLinkView *fastLinkView;
@property (nonatomic) BOOL isDefaultPage;
-(void)turnOnDefaultPage;
-(void)turnOffDefaultPage;
@end
