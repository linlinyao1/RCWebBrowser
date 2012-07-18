//
//  RCFastLinkView.h
//  RCWebBrowser
//
//  Created by imac on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCFastLinkView : UIView

@property (nonatomic,retain) UIScrollView *scrollBoard;

+(id)defaultPage;

-(void)reloadIcons;

@end
