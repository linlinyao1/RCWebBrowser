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
@property (nonatomic,assign) NSObject<RCFastLinkButtonDelegate> *delegate;

-(id)initWithFrame:(CGRect)frame Icon:(UIImage*)icon Name:(NSString*)name;

@end


@protocol RCFastLinkButtonDelegate <NSObject>

-(void)editModeEnter;
-(void)editModeExit;
-(BOOL)isEditMode;

-(void)button:(RCFastLinkButton*)button WillBeginMovingAtCenter:(CGPoint)center;
-(void)button:(RCFastLinkButton*)button MovedToLocation:(CGPoint)location;
-(void)button:(RCFastLinkButton*)button DidEndMovingAtCenter:(CGPoint)center;

@end