//
//  RCTab.h
//  RCWebBrowser
//
//  Created by imac on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TAB_WIDTH   107
#define TAB_HEIGHT  38

@protocol RCTabDelegate;

@interface RCTab : UITableViewCell
@property (nonatomic,assign) NSObject<RCTabDelegate> *delegate;
//+(RCTab*)tabWithDelegate:(NSObject<RCTabDelegate>*)delegate;
@property (nonatomic,retain) UILabel *titleLabel;
@end

@protocol RCTabDelegate <NSObject>
@required
-(BOOL)canCloseCell;
@optional
-(void)tabNeedsToClose:(RCTab*)tab;
@end