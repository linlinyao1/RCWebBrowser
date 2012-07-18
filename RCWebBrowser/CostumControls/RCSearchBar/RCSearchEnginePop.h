//
//  RCSearchEnginePop.h
//  RCWebBrowser
//
//  Created by imac on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SE_UDKEY @"SearchEngineType"

enum  {
    SETypeBaidu = 0,
    SETypeGoogle = 1,
    SETypeSoso = 2,
    SETypeEasou = 3,
    SETypeYicha =4
    };
typedef NSInteger SETypes;

@protocol RCSearchEnginePopDelegate <NSObject>

-(void)searchNeedUpdate;

@end


@interface RCSearchEnginePop : UITableView
+(UIImage*) imageForSEType:(SETypes) type;
+(NSURL*) urlForSEType:(SETypes)type WithKeyWords:(NSString*)keywords;

@property (nonatomic,assign) NSObject<RCSearchEnginePopDelegate> *notification;
@end
