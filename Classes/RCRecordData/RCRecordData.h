//
//  RCRecordData.h
//  RCWebBrowser
//
//  Created by imac on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RCRD_BOOKMARK @"bookmark"
#define RCRD_HISTORY @"history"
#define RCRD_FASTLINK @"fastlink"


@interface RCRecordData : NSObject

+(NSMutableArray*)recordDataWithKey:(NSString*)key;

//+(void)addRecord:(id)record ForKey:(NSString*)key;
+(void)updateRecord:(NSMutableArray*)record ForKey:(NSString*)key;

@end
