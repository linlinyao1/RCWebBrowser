//
//  RCTabView.h
//  RCWebBrowser
//
//  Created by imac on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCTabViewDelegate <NSObject>

- (NSInteger)numberOfTabs;
- (NSString*)titleForTabAtIndex:(NSInteger)index;
- (void)didSelectedTabAtIndex:(NSInteger)index;
- (void)didDeselectedTabAtIndex:(NSInteger)index;
- (BOOL)tabShouldAdd;// always add new tab at last,return the index for last item
- (BOOL)tabShouldCloseAtIndex:(NSInteger)index;


@end

@interface RCTabView : UIView
@property (nonatomic,retain) UITableView *tabTable;
@property (nonatomic,assign) IBOutlet NSObject<RCTabViewDelegate>* delegate;


-(void)hideViewWithOffset:(CGFloat)offset;
-(void)showView;
@end
