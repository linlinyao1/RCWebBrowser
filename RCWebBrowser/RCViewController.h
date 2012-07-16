//
//  RCViewController.h
//  RCWebBrowser
//
//  Created by imac on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCTabView.h"
#import "RCSearchBar.h"
#import "RCToolBar.h"
#import "RCWebView.h"
#import "PPRevealSideViewController.h"

@interface RCViewController : UIViewController<PPRevealSideViewControllerDelegate>
@property (retain, nonatomic) IBOutlet RCTabView *tabView;
@property (retain, nonatomic) IBOutlet RCSearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UIView *broswerView;
@property (retain, nonatomic) IBOutlet RCToolBar *bottomToolBar;

-(void)loadURLWithCurrentTab:(NSURL*)url;
@end
