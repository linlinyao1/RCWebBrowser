//
//  RCFastLinkButton.h
//  RCWebBrowser
//
//  Created by imac on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RCFastLinkButtonDelegate;

@interface RCFastLinkButton : UIButton
@property (nonatomic,retain) NSURL *url;

-(id)initWithFrame:(CGRect)frame Icon:(UIImage*)icon Name:(NSString*)name;

@end


