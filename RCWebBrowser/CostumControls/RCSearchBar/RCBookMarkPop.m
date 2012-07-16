//
//  RCBookMarkPop.m
//  RCWebBrowser
//
//  Created by imac on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCBookMarkPop.h"
#import "RCFastLinkObject.h"
#import "UIView+ScreenShot.h"

@implementation RCBookMarkPop
@synthesize delegate = _delegate;

-(void)addToFav:(UIButton*)sender
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSData * bookmarks = [defaults objectForKey:@"bookmarks"];
    NSMutableArray *bookmarksArray;
    
    if (bookmarks) {
        bookmarksArray = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:bookmarks]];
    } else {
        bookmarksArray = [[NSMutableArray alloc] initWithCapacity:1];        
    } 
    
    BookmarkObject *curObj = [self.delegate currentWebInfo];
    BOOL saveURL = YES;
    // Check that the URL is not already in the bookmark list
    for (BookmarkObject * bookmark in bookmarksArray) {
        if ([bookmark.url.absoluteString isEqual:curObj.url.absoluteString]) {
            saveURL = NO;
            break;
        }
    }
    
    // Add the new URL in the list
    if (saveURL) {
        [bookmarksArray addObject:curObj];
    }
    
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:bookmarksArray] forKey:@"bookmarks"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)addToFastLink:(UIButton*)sender
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSData * fastlinks = [defaults objectForKey:@"fastlinks"];
    NSMutableArray *fastlinksArray;
    
    if (fastlinks) {
        fastlinksArray = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:fastlinks]];
    } else {
        fastlinksArray = [[NSMutableArray alloc] initWithCapacity:1];        
    } 
    
    BookmarkObject *curObj = [self.delegate currentWebInfo];
    RCFastLinkObject *flObj = [[RCFastLinkObject alloc] initWithName:curObj.name andURL:curObj.url andIcon:[UIView captureView:[self.delegate currentWeb]]];
//    BOOL saveURL = YES;
//    // Check that the URL is not already in the bookmark list
//    for (BookmarkObject * bookmark in bookmarksArray) {
//        if ([bookmark.url.absoluteString isEqual:curObj.url.absoluteString]) {
//            saveURL = NO;
//            break;
//        }
//    }
    
    // Add the new URL in the list
//    if (saveURL) {
        [fastlinksArray addObject:flObj];
//    }
    
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:fastlinksArray] forKey:@"fastlinks"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        UIButton* addToFav = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        addToFav.frame = CGRectMake(0, 0, frame.size.width, frame.size.height/2);
        [addToFav setTitle:@"添加到收藏" forState:UIControlStateNormal];
        addToFav.titleLabel.textAlignment = UITextAlignmentCenter;
        [addToFav addTarget:self action:@selector(addToFav:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addToFav];
        
        UIButton* addToFastLink = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        addToFastLink.frame = CGRectMake(0, frame.size.height/2, frame.size.width, frame.size.height/2);
        [addToFastLink setTitle:@"添加快速启动" forState:UIControlStateNormal];
        [addToFastLink addTarget:self action:@selector(addToFastLink:) forControlEvents:UIControlEventTouchUpInside];
        addToFastLink.titleLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:addToFastLink];
    }
    return self;
}


@end
