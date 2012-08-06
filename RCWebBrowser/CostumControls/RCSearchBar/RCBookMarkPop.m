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
@property (nonatomic,retain) UIButton *addToFavIcon;
@property (nonatomic,retain) UIButton *addToFastLinkIcon;

@end

@implementation RCBookMarkPop
@synthesize delegate = _delegate;
@synthesize bookmarksArray = _bookmarksArray;
@synthesize fastlinksArray = _fastlinksArray;
@synthesize addToFav = _addToFav;
@synthesize addToFastLink = _addToFastLink;
@synthesize addToFavIcon = _addToFavIcon;
@synthesize addToFastLinkIcon = _addToFastLinkIcon;

-(void)addToFav:(UIButton*)sender
{
    BookmarkObject *curObj = [self.delegate currentWebInfo];
    BookmarkObject *existObj = [self checkBookMarkExist];
    if (!existObj) {
        [self.bookmarksArray addObject:curObj];
        [sender setTitle:@"从收藏夹移除" forState:UIControlStateNormal];
        [self.addToFavIcon setBackgroundImage:RC_IMAGE(@"bmpop_removefav") forState:UIControlStateNormal];
        [self.delegate highlightBookMarkButton:YES];
    }else {
        [self.bookmarksArray removeObject:existObj];
        [sender setTitle:@"添加到收藏" forState:UIControlStateNormal];
        [self.addToFavIcon setBackgroundImage:RC_IMAGE(@"bmpop_addfav") forState:UIControlStateNormal];
        if ([self.addToFastLink.titleLabel.text isEqualToString: @"从快速启动移除"]) {
            [self.delegate highlightBookMarkButton:YES];
        }else {
            [self.delegate highlightBookMarkButton:NO];
        }
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
        [self.addToFastLinkIcon setBackgroundImage:RC_IMAGE(@"bmpop_removefastlink") forState:UIControlStateNormal];
        [self.delegate highlightBookMarkButton:YES];
        [flObj release];
    }else {
        [self.fastlinksArray removeObject:existObj];
        [sender setTitle:@"添加到快速启动" forState:UIControlStateNormal];
        [self.addToFastLinkIcon setBackgroundImage:RC_IMAGE(@"bmpop_addfastlink") forState:UIControlStateNormal];

        if ([self.addToFav.titleLabel.text isEqualToString: @"从收藏夹移除"]) {
            [self.delegate highlightBookMarkButton:YES];
        }else {
            [self.delegate highlightBookMarkButton:NO];
        }
    }
    [RCRecordData updateRecord:self.fastlinksArray ForKey:RCRD_FASTLINK];
    
}


-(BookmarkObject*)checkBookMarkExist
{
    NSMutableArray *bookmarksArray = self.bookmarksArray;
    BookmarkObject *curObj = [self.delegate currentWebInfo];
    for (BookmarkObject * bookmark in bookmarksArray) {
        NSString* urlString = bookmark.url.absoluteString;
        if ([urlString hasSuffix:@"/"]) {
            urlString = [urlString substringToIndex:urlString.length-1];
        } 
        if ([urlString isEqual:curObj.url.absoluteString]) {
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
        NSString* urlString = fastlink.url.absoluteString;
        if ([urlString hasSuffix:@"/"]) {
            urlString = [urlString substringToIndex:urlString.length-1];
        } 
        if ([urlString isEqual:curObj.url.absoluteString]) {
            return fastlink;
        }
    }
    return nil;
}

-(void)updateBttonState
{
    if (![self checkBookMarkExist]) {
        [self.addToFav setTitle:@"添加到收藏" forState:UIControlStateNormal];
        [self.addToFavIcon setBackgroundImage:RC_IMAGE(@"bmpop_addfav") forState:UIControlStateNormal];
    }else {
        [self.addToFav setTitle:@"从收藏夹移除" forState:UIControlStateNormal];
        [self.addToFavIcon setBackgroundImage:RC_IMAGE(@"bmpop_removefav") forState:UIControlStateNormal];
    }
    
    if (![self checkFastLinkExist]) {
        [self.addToFastLink setTitle:@"添加到快速启动" forState:UIControlStateNormal];
        [self.addToFastLinkIcon setBackgroundImage:RC_IMAGE(@"bmpop_addfastlink") forState:UIControlStateNormal];
    }else {
        [self.addToFastLink setTitle:@"从快速启动移除" forState:UIControlStateNormal];
        [self.addToFastLinkIcon setBackgroundImage:RC_IMAGE(@"bmpop_removefastlink") forState:UIControlStateNormal];

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
        
        UIButton* addToFavIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        addToFavIcon.frame = CGRectMake(0, 3, 28, 28);
        [self addSubview:addToFavIcon];
        self.addToFavIcon = addToFavIcon;
        
        UIButton* addToFav = [UIButton buttonWithType:UIButtonTypeCustom];
        addToFav.frame = CGRectMake(CGRectGetMaxX(addToFavIcon.frame), 0, frame.size.width-addToFavIcon.frame.size.width, frame.size.height/2);
        [addToFav setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        addToFav.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [addToFav setBackgroundImage:RC_IMAGE(@"bookMarkPopButtonPressed") forState:UIControlStateHighlighted];
        [addToFav addTarget:self action:@selector(addToFav:) forControlEvents:UIControlEventTouchUpInside];
        self.addToFav = addToFav;
        [self addSubview:addToFav];
        
//        UIImageView *separator = [[[UIImageView alloc] initWithImage:RC_IMAGE(@"MenuSeparateLine")] autorelease];
        UIView *separator = [[[UIView alloc] init] autorelease];
        separator.frame = CGRectMake(0, CGRectGetMaxY(addToFav.frame), frame.size.width, 1);
        separator.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self addSubview:separator];
        
        
        UIButton* addToFastLinkIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        addToFastLinkIcon.frame = CGRectMake(0, frame.size.height/2+3, 28, 28);
        [self addSubview:addToFastLinkIcon];
        self.addToFastLinkIcon = addToFastLinkIcon;
        
        UIButton* addToFastLink = [UIButton buttonWithType:UIButtonTypeCustom];
        addToFastLink.frame = CGRectMake(CGRectGetMaxX(addToFastLinkIcon.frame), frame.size.height/2, frame.size.width - addToFastLinkIcon.frame.size.width, frame.size.height/2);
        [addToFastLink setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [addToFastLink setBackgroundImage:RC_IMAGE(@"bookMarkPopButtonPressed") forState:UIControlStateHighlighted];
        [addToFastLink addTarget:self action:@selector(addToFastLink:) forControlEvents:UIControlEventTouchUpInside];
        addToFastLink.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.addToFastLink = addToFastLink;
        [self addSubview:addToFastLink];        
    }
    return self;
}


-(void)dealloc
{
    [_bookmarksArray release];
    [_fastlinksArray release];
    [_addToFav release];
    [_addToFastLink release];
    [super dealloc];
}

@end
