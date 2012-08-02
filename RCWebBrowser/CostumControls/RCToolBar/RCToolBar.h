//
//  RCToolBar.h
//  RCWebBrowser
//
//  Created by imac on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RCToolBarDelegate <NSObject>
-(void)backButtonPressed;
-(void)forwardButtonPressed;
-(void)menuButtonPressed;
-(void)homeButtonPressed;
-(void)fullScreenButtonPressed:(BOOL)hideOrNot;
@end

@interface RCToolBar : UIView
@property(nonatomic) BOOL isBarShown;

//-(void)moveFrontBar:(BOOL)isOut;
-(void)enableBackOrNot:(BOOL)enable;
-(void)enableForwardOrNot:(BOOL)enable;

-(void)preHideBar:(BOOL)transparent;
-(void)hideBar;
-(void)showBar;
@property (nonatomic,assign) IBOutlet NSObject<RCToolBarDelegate> *delegate;
@end
