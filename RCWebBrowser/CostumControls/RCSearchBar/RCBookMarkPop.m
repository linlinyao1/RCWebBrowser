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
#import "RCRecordData.h"

@interface RCBookMarkPop ()
@property (nonatomic,retain) NSMutableArray *bookmarksArray;
@property (nonatomic,retain) NSMutableArray *fastlinksArray;
@property (nonatomic,retain) UIButton *addToFav;
@property (nonatomic,retain) UIButton *addToFastLink;
@end

@implementation RCBookMarkPop
@synthesize delegate = _delegate;
@synthesize bookmarksArray = _bookmarksArray;
@synthesize fastlinksArray = _fastlinksArray;
@synthesize addToFav = _addToFav;
@synthesize addToFastLink = _addToFastLink;


-(void)addToFav:(UIButton*)sender
{
    BookmarkObject *curObj = [self.delegate currentWebInfo];
    BookmarkObject *existObj = [self checkBookMarkExist];
    if (!existObj) {
        [self.bookmarksArray addObject:curObj];
        [sender setTitle:@"从收藏夹移除" forState:UIControlStateNormal];
    }else {
        [self.bookmarksArray removeObject:existObj];
        [sender setTitle:@"添加到收藏" forState:UIControlStateNormal];
    }
    [RCRecordData updateRecord:self.bookmarksArray ForKey:RCRD_BOOKMARK];

}

-(void)addToFastLink:(UIButton*)sender
{
//    NSMutableArray *fastlinksArray = [RCRecordData recordDataWithKey:RCRD_FASTLINK];
    BookmarkObject *curObj = [self.delegate currentWebInfo];
    RCFastLinkObject *existObj = [self checkFastLinkExist];
    if (!existObj) {
        RCFastLinkObject *flObj = [[RCFastLinkObject alloc] initWithName:curObj.name andURL:curObj.url andIcon:[UIView captureView:[self.delegate currentWeb]]];
        [self.fastlinksArray addObject:flObj];
        [sender setTitle:@"从快速启动移除" forState:UIControlStateNormal];
    }else {
        [self.fastlinksArray removeObject:existObj];
        [sender setTitle:@"添加快速启动" forState:UIControlStateNormal];
    }
    [RCRecordData updateRecord:self.fastlinksArray ForKey:RCRD_FASTLINK];
}


-(BookmarkObject*)checkBookMarkExist
{
    NSMutableArray *bookmarksArray = self.bookmarksArray;
    BookmarkObject *curObj = [self.delegate currentWebInfo];
    for (BookmarkObject * bookmark in bookmarksArray) {
        if ([bookmark.url.absoluteString isEqual:curObj.url.absoluteString]) {
            return bookmark;
            break;
        }
    }
    return nil;
}

-(RCFastLinkObject*)checkFastLinkExist
{
    NSMutableArray *fastlinksArray = self.fastlinksArray;
    BookmarkObject *curObj = [self.delegate currentWebInfo];
    for (RCFastLinkObject * fastlink in fastlinksArray) {
        if ([fastlink.url.absoluteString isEqual:curObj.url.absoluteString]) {
            return fastlink;
        }
    }
    return nil;
}

-(void)updateBttonState
{
    if (![self checkBookMarkExist]) {
        [self.addToFav setTitle:@"添加到收藏" forState:UIControlStateNormal];
    }else {
        [self.addToFav setTitle:@"从收藏夹移除" forState:UIControlStateNormal];
    }
    
    if (![self checkFastLinkExist]) {
        [self.addToFastLink setTitle:@"添加快速启动" forState:UIControlStateNormal];
    }else {
        [self.addToFastLink setTitle:@"从快速启动移除" forState:UIControlStateNormal];
    }        

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        self.bookmarksArray = [RCRecordData recordDataWithKey:RCRD_BOOKMARK];
        self.fastlinksArray = [RCRecordData recordDataWithKey:RCRD_FASTLINK];
        
        UIButton* addToFav = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        addToFav.frame = CGRectMake(0, 0, frame.size.width, frame.size.height/2);
        addToFav.titleLabel.textAlignment = UITextAlignmentCenter;
        [addToFav addTarget:self action:@selector(addToFav:) forControlEvents:UIControlEventTouchUpInside];
        self.addToFav = addToFav;
        [self addSubview:addToFav];

        UIButton* addToFastLink = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        addToFastLink.frame = CGRectMake(0, frame.size.height/2, frame.size.width, frame.size.height/2);
        [addToFastLink addTarget:self action:@selector(addToFastLink:) forControlEvents:UIControlEventTouchUpInside];
        addToFastLink.titleLabel.textAlignment = UITextAlignmentCenter;
        self.addToFastLink = addToFastLink;
        [self addSubview:addToFastLink];        
    }
    return self;
}


@end
