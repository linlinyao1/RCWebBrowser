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

@protocol RCSearchBarDelegate <NSObject>

-(BOOL)searchBarShouldReturn:(UITextField*)textField;
@end

@interface RCSearchBar : UIView
@property (nonatomic,retain) UITextField *locationField;
@property (nonatomic,assign) IBOutlet NSObject<RCSearchBarDelegate,RCBookMarkPopDelegate> *delegate;
@property (nonatomic,retain) UIButton *bookMarkButton;
@property (nonatomic,retain) CMPopTipView *bookMarkPop;

-(id)initForSearchDisplayWithFrame:(CGRect)frame ;
-(void)restoreDefaultState;

-(void)hideViewWithOffset:(CGFloat)offset;
-(void)showView;
@end
