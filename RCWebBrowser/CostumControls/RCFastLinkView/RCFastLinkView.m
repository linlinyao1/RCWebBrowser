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
#import "GMGridView.h"


#define FL_MARGIN  17
#define FL_GAP 10
#define FL_ICON_SIZE 64

static RCFastLinkView *_fastLinkView;

@interface RCFastLinkView ()<GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewActionDelegate>
@property (nonatomic,retain) NSMutableArray *objectList;
@property (nonatomic) BOOL isInEditMode;
@property (nonatomic) CGPoint movingPosition;
@property (nonatomic,retain) UIButton *addNew;
@end

@implementation RCFastLinkView
@synthesize objectList = _objectList;
@synthesize scrollBoard = _scrollBoard;
@synthesize isInEditMode = _isInEditMode;
@synthesize movingPosition = _movingPosition;
@synthesize addNew = _addNew;

-(void)reloadIcons//:(NSArray*)items
{
    self.objectList = [RCRecordData recordDataWithKey:RCRD_FASTLINK];
    NSArray *items = self.objectList;
    [[self.scrollBoard subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGRect rect = CGRectMake(FL_MARGIN, FL_MARGIN, FL_ICON_SIZE, FL_ICON_SIZE);
    
    for (RCFastLinkObject *obj in items) {
        NSLog(@"origin positoin : %@",NSStringFromCGRect(rect));
        RCFastLinkButton *iconButton = [[[RCFastLinkButton alloc] initWithFrame:rect Icon:obj.icon Name:obj.name] autorelease];
        iconButton.frame = rect;
//        iconButton.delegate = self;

        [self.scrollBoard addSubview:iconButton];
        
        rect = CGRectOffset(rect, FL_ICON_SIZE+FL_GAP, 0);
        if (CGRectGetMaxX(rect)>(320-FL_MARGIN)) {
            rect = CGRectOffset(rect, FL_MARGIN-rect.origin.x, FL_MARGIN+FL_ICON_SIZE);
        }
    }
    
    UIButton *addNew = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addNew.frame = rect;
    [addNew setTitle:@"添加" forState:UIControlStateNormal];
    [self.scrollBoard addSubview:addNew];
    self.addNew = addNew;
    
    self.scrollBoard.contentSize = CGSizeMake(320, CGRectGetMaxY(rect));
    
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.backgroundColor = [UIColor blueColor];
//        self.scrollBoard = [[UIScrollView alloc] initWithFrame:frame];
////        self.scrollBoard.showsVerticalScrollIndicator = no
//        self.objectList = [NSMutableArray arrayWithCapacity:20];
//        [self addSubview:self.scrollBoard];
//        
//        [self reloadIcons];       
        
        self.objectList = [RCRecordData recordDataWithKey:RCRD_FASTLINK];

        GMGridView *gmGridView = [[[GMGridView alloc] initWithFrame:self.bounds] autorelease];
        gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        gmGridView.backgroundColor = [UIColor clearColor];
        gmGridView.style = GMGridViewStylePush;
        gmGridView.itemSpacing = FL_GAP;
        gmGridView.minEdgeInsets = UIEdgeInsetsMake(FL_MARGIN, FL_MARGIN, FL_MARGIN, FL_MARGIN);
//        gmGridView.centerGrid = YES;
        gmGridView.actionDelegate = self;
        gmGridView.sortingDelegate = self;
//        gmGridView.transformDelegate = self;
        gmGridView.dataSource = self;
        [self addSubview:gmGridView];

        
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



#pragma mark GMGridViewActionDelegate

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %d", position);
}

#pragma mark GMGridViewDataSource


- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [self.objectList count];
}

- (CGSize)sizeForItemsInGMGridView:(GMGridView *)gridView
{
    return CGSizeMake(FL_ICON_SIZE, FL_ICON_SIZE);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    //NSLog(@"Creating view indx %d", index);
    
    CGSize size = [self sizeForItemsInGMGridView:gridView];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell) 
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.backgroundColor = [UIColor redColor];
//        view.layer.masksToBounds = NO;
//        view.layer.cornerRadius = 8;
//        view.layer.shadowColor = [UIColor grayColor].CGColor;
//        view.layer.shadowOffset = CGSizeMake(5, 5);
//        view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
//        view.layer.shadowRadius = 8;
        
        cell.contentView = view;
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
//    UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
//    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    label.text = (NSString *)[_data objectAtIndex:index];
//    label.textAlignment = UITextAlignmentCenter;
//    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [UIColor blackColor];
//    label.font = [UIFont boldSystemFontOfSize:20];
//    [cell.contentView addSubview:label];
    
    return cell;
}

- (void)GMGridView:(GMGridView *)gridView deleteItemAtIndex:(NSInteger)index
{
    [self.objectList removeObjectAtIndex:index];
}

#pragma mark GMGridViewSortingDelegate
- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3 
                          delay:0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor orangeColor];
//                         cell.contentView.layer.shadowOpacity = 0.7;
                     } 
                     completion:nil
     ];
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3 
                          delay:0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{  
                         cell.contentView.backgroundColor = [UIColor redColor];
//                         cell.contentView.layer.shadowOpacity = 0;
                     }
                     completion:nil
     ];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    return YES;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
    NSObject *object = [self.objectList objectAtIndex:oldIndex];
    [self.objectList removeObject:object];
    [self.objectList insertObject:object atIndex:newIndex];
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
    [self.objectList exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}








#pragma mark - RCFastLinkButtonDelegate

-(void)buttonNeedToBeRemoved:(RCFastLinkButton *)button
{
    

//    for (RCFastLinkButton* obj in self.objectList) {
//        if ([obj.url.absoluteString isEqualToString:button.url.absoluteString]) {
//            [self.objectList removeObject:obj];
//            break;
//        }
//    }
//    [RCRecordData updateRecord:self.objectList ForKey:RCRD_FASTLINK];    
//    [UIView animateWithDuration:.5 animations:^{
//        CGRect rect = button.frame;
//        [button removeFromSuperview];
//            for (RCFastLinkButton* flButton in [self.scrollBoard subviews])
//            {
//                NSLog(@"new positoin : %@",NSStringFromCGRect(rect));
//                if ([flButton isKindOfClass:[UIButton class]]) {
//                    CGRect tempRect = flButton.frame;
//                    flButton.frame = rect;
//                    rect = CGRectOffset(tempRect, -(FL_ICON_SIZE+FL_GAP), 0);
//                    if (rect.origin.x<(0+FL_MARGIN)) {
//                        rect = CGRectOffset(rect, 320 - FL_MARGIN, -(FL_MARGIN+FL_ICON_SIZE));
//                    }
//                    //            NSLog(@"buton : %@, position : %@",NSStringFromClass([flButton class]), NSStringFromCGRect(flButton.frame));
//                }
//            }        
//    }];
}


-(void)button:(RCFastLinkButton *)mButton MovedToLocation:(CGPoint)location
{
    for (RCFastLinkButton *button in [self.scrollBoard subviews]) {
        if (button != mButton && button!=self.addNew && CGRectContainsPoint(button.frame, location)) {
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
    [self.scrollBoard bringSubviewToFront:button];
}

-(void)editModeEnter
{
    if (self.isInEditMode) {
        return;
    }
    self.isInEditMode = YES;
    
    [UIView animateWithDuration:.5 animations:^{
        for (RCFastLinkButton *button in [self.scrollBoard subviews]) {
            if ([button respondsToSelector:@selector(enterEditMode)]) {
                [button enterEditMode];
            }
//            UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
//            [button addSubview:closeButton];
//            button.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }
        self.addNew.transform = CGAffineTransformMakeScale(0.8, 0.8);
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
//                button.transform = CGAffineTransformIdentity;
                if ([button respondsToSelector:@selector(exitEditMode)]) {
                    [button exitEditMode];
                }
            }
            self.addNew.transform = CGAffineTransformIdentity;
        }];
}

-(BOOL)isEditMode
{
    return self.isInEditMode;
}


@end
