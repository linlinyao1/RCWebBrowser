//
//  RCFastLinkView.m
//  RCWebBrowser
//
//  Created by imac on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCFastLinkView.h"
#import "RCFastLinkObject.h"
#import "RCFastLinkButton.h"
#import "RCRecordData.h"

#define FL_MARGIN  17
#define FL_GAP 10
#define FL_ICON_SIZE 64

static RCFastLinkView *_fastLinkView;

@interface RCFastLinkView ()<RCFastLinkButtonDelegate>
@property (nonatomic,retain) NSMutableArray *objectList;
@property (nonatomic) BOOL isInEditMode;
@property (nonatomic) CGPoint movingPosition;
@end

@implementation RCFastLinkView
@synthesize objectList = _objectList;
@synthesize scrollBoard = _scrollBoard;
@synthesize isInEditMode = _isInEditMode;
@synthesize movingPosition = _movingPosition;


-(void)reloadIcons//:(NSArray*)items
{
    self.objectList = [RCRecordData recordDataWithKey:RCRD_FASTLINK];
    NSArray *items = self.objectList;
    [[self.scrollBoard subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGRect rect = CGRectMake(FL_MARGIN, FL_MARGIN, FL_ICON_SIZE, FL_ICON_SIZE);
    
    for (RCFastLinkObject *obj in items) {
//    for (int i=0; i<60; i++) {
//        UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        RCFastLinkButton *iconButton = [[[RCFastLinkButton alloc] initWithFrame:rect Icon:obj.icon Name:obj.name] autorelease];
        iconButton.frame = rect;
        iconButton.delegate = self;

        [self.scrollBoard addSubview:iconButton];
        
        rect = CGRectOffset(rect, FL_ICON_SIZE+FL_GAP, 0);
        if (CGRectGetMaxX(rect)>(320-FL_MARGIN)) {
            rect = CGRectOffset(rect, FL_MARGIN-rect.origin.x, FL_MARGIN+FL_ICON_SIZE);
        }
    }
    self.scrollBoard.contentSize = CGSizeMake(320, CGRectGetMaxY(rect));
    
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blueColor];
        self.scrollBoard = [[UIScrollView alloc] initWithFrame:frame];
//        self.scrollBoard.showsVerticalScrollIndicator = no
        self.objectList = [NSMutableArray arrayWithCapacity:20];
        [self addSubview:self.scrollBoard];
        
//        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//        NSData * fastlinks = [defaults objectForKey:@"fastlinks"];
//        NSMutableArray *fastlinksArray;
//        if (fastlinks) {
//            fastlinksArray = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:fastlinks]];
//            self.objectList = fastlinksArray;
////            RCFastLinkObject *flObj = [fastlinksArray objectAtIndex:[fastlinksArray count]-1];        
////            UIImage *image = flObj.icon;
////            UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)] autorelease];
////            imageView.backgroundColor = [UIColor whiteColor];
////            imageView.image = image;
////            [self addSubview:imageView];
//        } 
        
        [self reloadIcons];        
 
    }
    return self;
}

+(id)defaultPage
{
    if (!_fastLinkView) {
        _fastLinkView = [[RCFastLinkView alloc] initWithFrame:CGRectMake(0, 0, 320, 328)];
    }
    return _fastLinkView;
}

#pragma mark - RCFastLinkButtonDelegate

-(void)button:(RCFastLinkButton *)mButton MovedToLocation:(CGPoint)location
{
    for (RCFastLinkButton *button in [self.scrollBoard subviews]) {
        if (button != mButton && CGRectContainsPoint(button.frame, location)) {
            CGPoint center = button.center;
            [UIView beginAnimations:nil context:nil];
                button.center =  self.movingPosition;
            [UIView commitAnimations];
            self.movingPosition = center;
            return;
        }
    }
}
-(void)button:(RCFastLinkButton *)button DidEndMovingAtCenter:(CGPoint)center
{
    [UIView beginAnimations:nil context:nil];
        button.center =  self.movingPosition;
    [UIView commitAnimations];
}
-(void)button:(RCFastLinkButton *)button WillBeginMovingAtCenter:(CGPoint)center
{
    self.movingPosition = center;
}

-(void)editModeEnter
{
    if (self.isInEditMode) {
        return;
    }
    self.isInEditMode = YES;
    
    [UIView animateWithDuration:.5 animations:^{
        for (RCFastLinkButton *button in [self.scrollBoard subviews]) {
            button.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }
    }];
}

-(void)editModeExit
{
    if (!self.isInEditMode) {
        return;
    }
    self.isInEditMode = NO;
    
        [UIView animateWithDuration:.5 animations:^{
            for (RCFastLinkButton *button in [self.scrollBoard subviews]) {
                button.transform = CGAffineTransformIdentity;
            }
        }];
}

-(BOOL)isEditMode
{
    return self.isInEditMode;
}


@end
