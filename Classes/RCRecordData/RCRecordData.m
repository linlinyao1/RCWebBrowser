//
//  RCRecordData.m
//  RCWebBrowser
//
//  Created by imac on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCRecordData.h"
#import "JSONKit.h"
#import "RCFastLinkObject.h"

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
        result = [[[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]] autorelease];
    }else {
        result = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
        if ([key isEqualToString:RCRD_FASTLINK]) {
            NSString *path = [[NSBundle mainBundle]pathForResource:@"defaultFastlinks" ofType:@"json"];
            NSString *jsonData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            NSArray *array = [jsonData objectFromJSONString];//[array mutableCopy];
            for (NSDictionary* dic in array) {
                RCFastLinkObject *newObj = [[RCFastLinkObject alloc] initWithName:[dic objectForKey:@"urltitle"] andURL:[NSURL URLWithString:[dic objectForKey:@"urllink"]] andIcon:nil];
                newObj.isDefault = YES;
                newObj.iconName = [dic objectForKey:@"urlico"];
                [result addObject:newObj];
                [newObj release];
            } 
            [self updateRecord:result ForKey:RCRD_FASTLINK];
        }
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
