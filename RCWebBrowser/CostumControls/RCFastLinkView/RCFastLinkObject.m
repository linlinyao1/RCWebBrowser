//
//  RCFastLinkObject.m
//  RCWebBrowser
//
//  Created by imac on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCFastLinkObject.h"
#import "EGOCache.h"

@implementation RCFastLinkObject

@synthesize name = _name;
@synthesize url = _url;
@synthesize date = _date;
@synthesize icon = _icon;

- (NSString *)cachePathForFileName:(NSString *)name WithExtention:(NSString*)extention
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);  
    NSString *documentsPath = [paths objectAtIndex:0];
//    NSString *cachePath = [documentsPath stringByAppendingString:@"/Library/Caches/"] ;
    return [documentsPath stringByAppendingFormat:@"/%@.%@",name,extention]; 
}

-(void)saveToDiscWithIcon:(UIImage*)icon andURL:(NSURL*)url
{
    NSString *pureName = [url.absoluteString stringByReplacingOccurrencesOfString:@"/" withString:@""];
//    pureName = [pureName stringByReplacingOccurrencesOfString:@"." withString:@""];
//    pureName = [pureName stringByReplacingOccurrencesOfString:@":" withString:@""];

    NSString *storePath = [self cachePathForFileName:pureName WithExtention:@"png"];
    if (![[NSFileManager defaultManager] createFileAtPath:storePath contents:UIImagePNGRepresentation(icon) attributes:nil ]) {
        NSLog(@"save failed");
    }

}
-(UIImage*)getImageFromDiscWithURL:(NSURL*)url
{
    NSString *pureName = [url.absoluteString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString *storePath = [self cachePathForFileName:pureName WithExtention:@"png"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:storePath]) {
        return nil;
    } else {
        return [UIImage imageWithContentsOfFile:storePath];
    }
}

-(void)setIcon:(UIImage *)icon
{
    [_icon release];
    _icon = [icon retain];
    [self saveToDiscWithIcon:icon andURL:self.url];
//    [[EGOCache currentCache] setImage:icon forKey:self.url.absoluteString withTimeoutInterval:[NSDate timeIntervalSinceReferenceDate]];
}
-(UIImage *)icon
{
    if (!_icon) {
//        _icon = [[EGOCache currentCache] imageForKey:self.url.absoluteString];
      _icon = [self getImageFromDiscWithURL:self.url];
    }
    return _icon;
}



- (id) initWithName:(NSString *)name andURL:(NSURL *)url andIcon:(UIImage*)icon
{
    self = [super init];
    if (self) {
        self.name = name;
        self.url = url;
        self.date = [NSDate date];
        self.icon = icon;
    }
    return self;
}

- (id) initWithCoder: (NSCoder *)coder {
    self = [self init];
    if (self != nil)
    {
        self.name = [coder decodeObjectForKey: @"name"];
        self.url = [coder decodeObjectForKey: @"url"];
        self.date = [coder decodeObjectForKey:@"date"];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder *)coder {
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_url forKey:@"url"];
    [coder encodeObject:_date forKey:@"date"];
    
}

- (void) dealloc {
    self.name = nil;
    self.url = nil;
    self.date = nil;
    [super dealloc];
}


@end
