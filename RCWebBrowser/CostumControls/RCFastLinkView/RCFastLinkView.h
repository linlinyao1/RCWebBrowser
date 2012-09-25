//
//  RCFastLinkView.h
//  RCWebBrowser
//
//  Created by imac on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCFastLinkViewDelegate <NSObject>

-(void)openLink:(NSURL *)URL;
-(void)fastLinkStartEdting;
-(void)fastLinkEndEdting;

@end



@interface RCFastLinkView : UIView
@property (nonatomic,assign) NSObject<RCFastLinkViewDelegate>* delegate; 

+(RCFastLinkView*)defaultPage;

-(void)scrollPage;

-(void)refresh;

-(BOOL)editing;
-(void)setEding:(BOOL)editing;

-(BOOL)canBeSlided;

@end
