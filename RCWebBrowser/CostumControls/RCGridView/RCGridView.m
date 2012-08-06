//
//  RCGridView.m
//  RCWebBrowser
//
//  Created by imac on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCGridView.h"
#import "QuartzCore/QuartzCore.h"

#define RCGRIDVIEW_INVALID_INDEX 9999
#define RCGRIDVIEW_ADDBUTTON_INDEX 9998

@interface RCGridView ()<RCGridViewCellDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,retain) UIScrollView *scrollView;
@property (nonatomic,retain) UIView *addButton;
@property (nonatomic,retain) RCGridViewCell *movingCell;
@property (nonatomic) CGPoint movingPosition;
@property (nonatomic,retain) NSMutableSet *resuePool;

@property (nonatomic,retain) UILongPressGestureRecognizer *longPress;
@property (nonatomic,retain) UITapGestureRecognizer *tap;
@property (nonatomic,retain) UIPanGestureRecognizer *pan;

-(NSInteger)indexForCellAtPoint:(CGPoint)point;
-(RCGridViewCell*)cellAtPoint:(CGPoint)point;

-(void)checkMovingCellPosition:(RCGridViewCell*)movingCell;

-(void)queueReusableCell:(RCGridViewCell*)cell;
@end


@implementation RCGridView
//public
@synthesize verticalCellGap = _verticalCellGap;
@synthesize horizonalCellGap = _horizonalCellGap;
@synthesize cellSize = _cellSize;
@synthesize minEdgeInsets = _minEdgeInsets;
@synthesize editing = _editing;
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize disableEditWhenTapInvalid = _disableEditWhenTapInvalid;
//private
@synthesize scrollView = _scrollView;
@synthesize addButton = _addButton;
@synthesize longPress = _longPress;
@synthesize tap  = _tap;
@synthesize pan = _pan;
@synthesize movingCell = _movingCell;
@synthesize movingPosition = _movingPosition;
@synthesize resuePool = _resuePool;
#pragma mark - setter & getter
-(void)setDataSource:(NSObject<RCGridViewDataSource> *)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
    }
    [self reloadData];
}

-(void)setEditing:(BOOL)editing
{
    if (_editing != editing) {
        _editing = editing;
        if (_editing) {
            if ([self.delegate respondsToSelector:@selector(gridViewStartEditing:)]) {
                [self.delegate gridViewStartEditing:self];
            }
        }else {
            if ([self.delegate respondsToSelector:@selector(gridViewEndEditing:)]) {
                [self.delegate gridViewEndEditing:self];
            }
        }
        for (RCGridViewCell *cell in [self.scrollView subviews]) {
            if (cell == self.addButton) {
                cell.hidden = _editing;
                continue;
            }
            if (![cell isKindOfClass:[RCGridViewCell class]]) {
                continue;
            }
            cell.editing = _editing;
        }
    }
}


#pragma mark - Main Body

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.scrollView = [[[UIScrollView alloc] initWithFrame:self.bounds] autorelease];
//        self.scrollView.canCancelContentTouches = NO;
//        self.scrollView.bounces = NO;
        [self addSubview:self.scrollView];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressed:)];
//        longPress.delegate = self;
        self.longPress = longPress;
        [self.scrollView addGestureRecognizer:longPress];
        [longPress release];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapped:)];
        tap.delegate = self;
        self.tap = tap;
        [self.scrollView addGestureRecognizer:tap];
        [tap release];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//        pan.delaysTouchesBegan = YES;
        self.pan = pan;
        pan.delegate = self;
        [self.scrollView addGestureRecognizer:pan];
        [pan release];
        
        //default setting
        self.cellSize = CGSizeMake(64, 64);
        self.minEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        self.verticalCellGap = 10;
        self.horizonalCellGap = 10;
    }
    return self;
}


-(void)reloadData
{
//    for (int i=0; i<[self.scrollView subviews].count; i++) {
//        RCGridViewCell* cell = [[self.scrollView subviews] objectAtIndex:i];
//        if (![cell isKindOfClass:[RCGridViewCell class]]) {
//            continue;
//        }
//        [self queueReusableCell:cell];
//        [cell removeFromSuperview];
//    }
//    [self.addButton removeFromSuperview];
    
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    
    NSInteger numberOfCells = [self.dataSource numberOfCellsInGridView:self];
    CGRect rect = CGRectMake(self.minEdgeInsets.left, self.minEdgeInsets.top, self.cellSize.width, self.cellSize.height);
    CGRect newRect = CGRectZero;
    
    for (int i=0; i<numberOfCells; i++) {
        RCGridViewCell* cell = [self.dataSource gridView:self ViewForCellAtIndex:i];
        cell.frame = rect;
        cell.delegate = self;
        cell.editing = self.isEditing;
        cell.index = i;
        [self.scrollView addSubview:cell];
        
        newRect = CGRectOffset(rect, self.cellSize.width+self.horizonalCellGap, 0);
        if (CGRectGetMaxX(newRect)>(self.frame.size.width-self.minEdgeInsets.right)) {
            rect = CGRectMake(self.minEdgeInsets.left, rect.origin.y+self.cellSize.height+self.verticalCellGap, rect.size.width, rect.size.height);
        }else {
            rect = newRect;
        }
    }
    if ([self.dataSource respondsToSelector:@selector(ViewForAddButton:)]) {
        UIView *addButton = [self.dataSource ViewForAddButton:self];
        addButton.frame = rect;
        if (self.isEditing) {
            addButton.hidden = YES;
        }
        [self.scrollView addSubview:addButton];
        self.addButton = addButton;
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(rect)+self.minEdgeInsets.bottom);
    }else {
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(newRect)+self.minEdgeInsets.bottom);
    }
}


-(void)queueReusableCell:(RCGridViewCell *)cell
{
    if (!cell) {
        return;
    }
    if (!self.resuePool) {
        self.resuePool = [NSMutableSet setWithCapacity:1];
    }
    [self.resuePool addObject:cell];
}

-(RCGridViewCell *)dequeueReusableCell
{
    RCGridViewCell* cell = [self.resuePool anyObject];
    if (cell) {
        [self.resuePool removeObject:cell];
    }
    return cell;
}


#pragma mark - RCGridViewCellDelegate
-(void)cellNeedToBeRemoved:(RCGridViewCell *)closeCell
{
    for (int i=0; i<[self.scrollView subviews].count; i++) {
        RCGridViewCell *cell = [[self.scrollView subviews] objectAtIndex:i];
        if ([cell isKindOfClass:[RCGridViewCell class]]) {
            if (CGRectEqualToRect(cell.frame, closeCell.frame)) {
                [self.delegate  gridView:self CellWillBeRemovedAtIndex:i];
                break;
            }
        }

    }
    
    [self reloadData];
}


-(void)cellTappedWhenEditing:(RCGridViewCell *)cell
{
    self.editing = NO;
}

#pragma mark - GestureRecognizer
                                       
-(void)handleLongPressed:(UILongPressGestureRecognizer*)Gesture
{
    switch (Gesture.state) {
        case UIGestureRecognizerStateBegan:{
            NSLog(@"long begain");
            CGPoint location = [Gesture locationInView:self.scrollView];
            NSInteger index = [self indexForCellAtPoint:location];
            if (index != RCGRIDVIEW_INVALID_INDEX) {
                if (!self.isEditing) {
                    self.editing = YES;
                }
                self.movingCell = [self cellAtPoint:location];
                self.movingPosition = self.movingCell.center;
                self.movingCell.layer.shadowOpacity = 0.7;
                self.movingCell.layer.shadowOffset = CGSizeMake(3, 3);
            } 
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
//            NSLog(@"long change");
        }
            break;
        case UIGestureRecognizerStateFailed:{
            NSLog(@"long fail");
        }
        case UIGestureRecognizerStateEnded:{
            [UIView beginAnimations:nil context:nil];
            self.movingCell.transform = CGAffineTransformIdentity;
            self.movingCell.center = self.movingPosition;
            [UIView commitAnimations];
            
            if ([self.delegate respondsToSelector:@selector(gridView:CellWillEndMoving:)]) {
                [self.delegate gridView:self CellWillEndMoving:self.movingCell];
            }
            self.movingCell.layer.shadowOpacity = 0;
            self.movingCell.layer.shadowOffset = CGSizeZero;

            self.movingCell = nil;
            self.movingPosition = CGPointZero;
        }
        default:
            break;
    }
    
}

-(void)handleTapped:(UITapGestureRecognizer*)Gesture
{
    NSLog(@"paning");
    if (Gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [Gesture locationInView:self.scrollView];
        NSInteger index = [self indexForCellAtPoint:location];
        if (index == RCGRIDVIEW_INVALID_INDEX) {
            if (self.disableEditWhenTapInvalid && self.isEditing) {
                self.editing = NO;
            }
        }else if (index == RCGRIDVIEW_ADDBUTTON_INDEX){
            if ([self.delegate respondsToSelector:@selector(addButtonTapped:)]) {
                [self.delegate addButtonTapped:self];
            }
        }else {
            if ([self.delegate respondsToSelector:@selector(gridView:CellTappedAtIndex:)]) {
                [self.delegate gridView:self CellTappedAtIndex:index];
            }
        }
    }
}
                                       

-(void)handlePan:(UIPanGestureRecognizer*)Gesture
{
    NSLog(@"pan start");
    if (!self.isEditing ) {//|| self.pan != Gesture
        return;
    }
    if (Gesture.state == UIGestureRecognizerStateBegan) {
        RCGridViewCell *cell = [self cellAtPoint:[Gesture locationInView:self.scrollView]];
        if (cell) {
//            self.scrollView.scrollEnabled = NO;
            if ([self.delegate respondsToSelector:@selector(gridView:CellTappedAtIndex:)]) {
                [self.delegate gridView:self CellWillBeMoved:cell];
            }
//            self.movingCell = cell;
//            self.movingPosition = cell.center;
            [self.scrollView bringSubviewToFront:cell];
            
        }else {
            self.movingCell = nil;
        }
    }
    if (Gesture.state == UIGestureRecognizerStateChanged) {
        if (self.movingCell) {
            CGPoint translation = [Gesture translationInView:self.scrollView];
            self.movingCell.transform = CGAffineTransformMakeTranslation(translation.x, translation.y);
            [self checkMovingCellPosition:self.movingCell];
        }
    }
    if (Gesture.state == UIGestureRecognizerStateEnded || Gesture.state == UIGestureRecognizerStateCancelled || Gesture.state == UIGestureRecognizerStateFailed) {
        [UIView beginAnimations:nil context:nil];
        self.movingCell.transform = CGAffineTransformIdentity;
        self.movingCell.center = self.movingPosition;
        [UIView commitAnimations];
//        self.scrollView.scrollEnabled = YES;
    }
}
                                       
                                       
                                       
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.tap) {
        if (self.isEditing && [self indexForCellAtPoint:[gestureRecognizer locationInView:self.scrollView]] != RCGRIDVIEW_INVALID_INDEX){
            return NO;
        }
    }
//    if (gestureRecognizer == self.pan) {//[gestureRecognizer isKindOfClass:[UIPanGestureRecognizer]]
//        NSLog(@"my pan");
//    }else {
//        NSLog(@"not my pan");
//    }
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


#pragma mark -private method

-(void)checkMovingCellPosition:(RCGridViewCell *)movingCell
{
    for (RCGridViewCell *cell in [self.scrollView subviews]) {
        if (![cell isKindOfClass:[RCGridViewCell class]] || [cell isEqual:movingCell] || cell == self.addButton) {
            continue;
        }
        if (CGRectContainsPoint(movingCell.frame, cell.center)) {
            CGPoint point = cell.center;
            [UIView beginAnimations:nil context:nil];
            cell.center = self.movingPosition;
            [UIView commitAnimations];
            self.movingPosition = point;
            [self.delegate gridView:self CellAtIndex:movingCell.index ExchangeWithCellAtIndex:cell.index];
            NSInteger index = cell.index;
            cell.index = movingCell.index;
            movingCell.index = index;
            return;
        }
    }
}

-(NSInteger)indexForCellAtPoint:(CGPoint)point
{
    for (RCGridViewCell *cell in [self.scrollView subviews]) {
        if (cell == self.addButton && CGRectContainsPoint(cell.frame, point)) {
            return RCGRIDVIEW_ADDBUTTON_INDEX;
        }
        if ([cell isKindOfClass:[RCGridViewCell class]]) {
            if (CGRectContainsPoint(cell.frame, point) || CGRectContainsPoint(cell.closeButton.frame, [cell convertPoint:point fromView:self.scrollView])) {//|| CGRectContainsPoint(, point)
                return cell.index;
            }
        }
//        NSLog(@"point : %@",NSStringFromCGPoint([cell convertPoint:point fromView:self.scrollView]));

    }
    return RCGRIDVIEW_INVALID_INDEX;
}

-(RCGridViewCell *)cellAtPoint:(CGPoint)point
{
    for (RCGridViewCell *cell in [self.scrollView subviews]) {
        if ([cell isKindOfClass:[RCGridViewCell class]]) {
            if (CGRectContainsPoint(cell.frame, point)) {
                return cell;
            }
        }
    }
    return nil;
}

-(void)dealloc
{
    [_scrollView release];
    [_addButton release];
    [_longPress release];
    [_tap release];
    [_pan release];
    [_movingCell release];
    [_resuePool release];
    [super dealloc];
}

@end
