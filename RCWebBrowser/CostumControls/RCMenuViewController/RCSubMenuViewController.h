//
//  RCSubMenuViewController.h
//  RCWebBrowser
//
//  Created by imac on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    RCSubMenuFavorite = 1,
    RCSubMenuHistory = 2,
    RCSubMenuMostViewed = 3,
    RCSubMenuSetting = 4
};
typedef NSUInteger RCSubMenuType;

@interface RCSubMenuViewController : UITableViewController

-(id)initWithSubMenuType:(RCSubMenuType)type;

@end
