//
//  RCSearchBar.h
//  RCWebBrowser
//
//  Created by imac on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPopTipView.h"
#import "RCBookMarkPop.h"


enum {
    RCKeyBoardTypeNone=0,
    RCKeyBoardTypePrefix=1,
    RCkeyBoardTypeSuffix=2
};

typedef NSInteger RCKeyBoardAccessoryType ;

@protocol RCSearchBarDelegate <NSObject>

-(void)searchModeOn;
-(void)searchModeOff;

-(void)searchCompleteWithUrl:(NSURL*)url;

-(void)reloadOrStop:(UIButton*)sender;

@end

@interface RCSearchBar : UIView
@property (nonatomic,retain) UITextField *locationField;
@property (nonatomic,assign) IBOutlet NSObject<RCSearchBarDelegate,RCBookMarkPopDelegate> *delegate;
@property (nonatomic,retain) UIButton *bookMarkButton;
@property (nonatomic,retain) CMPopTipView *bookMarkPop;
@property (nonatomic,retain) CMPopTipView *searchEnginePop;
@property (nonatomic) RCKeyBoardAccessoryType KBAType;
@property (nonatomic,retain) UIButton *stopReloadButton;

-(void)restoreDefaultState;

//-(void)preTurnOnSearchMode;
-(void)turnOnSearchMode;
//-(void)preTurnOffSearchMode;
-(void)turnOffSearchMode;


-(void)makeKeyBoardAccessoryWithType:(RCKeyBoardAccessoryType)type;


-(void)hideViewWithOffset:(CGFloat)offset;
-(void)showView;


-(void)startLoadingProgress;
-(void)stopLoadProgress;
-(void)removePregress;
@end
