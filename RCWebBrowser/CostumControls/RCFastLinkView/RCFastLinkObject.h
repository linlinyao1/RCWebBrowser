//
//  RCFastLinkObject.h
//  RCWebBrowser
//
//  Created by imac on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCFastLinkObject : NSObject<NSCoding>

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) UIImage *icon;

- (id) initWithName:(NSString *)name andURL:(NSURL *)url andIcon:(UIImage*)icon;

@end
