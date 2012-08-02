//
//  RCRecordData.m
//  RCWebBrowser
//
//  Created by imac on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCRecordData.h"

@implementation RCRecordData


static inline NSString* cachePathForKey(NSString* key) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [paths objectAtIndex:0];
	path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",key]];
    return path;
}




+(NSMutableArray *)recordDataWithKey:(NSString *)key
{
    NSMutableArray* result = nil;
    NSString *path = cachePathForKey(key);
    NSData* data = [NSData dataWithContentsOfFile:path];
    if (data) {
        result = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    }else {
        result = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return result;
}

//+(void)addRecord:(id)record ForKey:(NSString *)key
//{
//    NSMutableArray *records = [self recordDataWithKey:key];
//    [records addObject:record];
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:records];
//    [[NSFileManager defaultManager]createFileAtPath:cachePathForKey(key) contents:data attributes:nil];
//}


+(void)updateRecord:(NSMutableArray *)record ForKey:(NSString *)key
{
    if (!record) {
        record = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:record];
    [[NSFileManager defaultManager]createFileAtPath:cachePathForKey(key) contents:data attributes:nil];
}

@end
