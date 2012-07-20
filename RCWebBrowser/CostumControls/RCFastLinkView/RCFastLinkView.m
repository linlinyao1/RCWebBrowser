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
#import "RCAddNewViewController.h"

#define FL_MARGIN  17
#define FL_GAP 10
#define FL_ICON_SIZE 64

static RCFastLinkView *_fastLinkView;

@interface RCFastLinkView ()<GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewActionDelegate>
@property (nonatomic,retain) NSMutableArray *objectList;
@property (nonatomic) BOOL isInEditMode;
@property (nonatomic) CGPoint movingPosition;
@property (nonatomic,retain) UIButton *addNew;
@property (nonatomic,retain) GMGridView* gridView;
@property (nonatomic,retain) UIScrollView* scrollView;
@end


@implementation RCFastLinkView
@synthesize objectList = _objectList;
@synthesize scrollBoard = _scrollBoard;
@synthesize isInEditMode = _isInEditMode;
@synthesize movingPosition = _movingPosition;
@synthesize addNew = _addNew;
@synthesize gridView = _gridView;
@synthesize scrollView = _scrollView;


-(BOOL)isEditing
{
    return self.gridView.isEditing;
}
-(void)repositionAddNewButton
{
    CGRect rect;
    UIView *cell = [self.gridView cellForItemAtIndex:self.objectList.count-1];
    if (cell) {
        rect = cell.frame;
        rect = CGRectOffset(rect, FL_ICON_SIZE+FL_GAP, 0);
        if (CGRectGetMaxX(rect)>(self.gridView.frame.size.width-FL_MARGIN)) {
            rect = CGRectOffset(rect, -rect.origin.x, FL_ICON_SIZE+FL_GAP);
        }
    }else {
        rect = CGRectMake(FL_MARGIN, FL_MARGIN, FL_ICON_SIZE, FL_ICON_SIZE);
    }

    self.addNew.frame = rect;
    self.addNew.hidden = NO;
    [self.gridView addSubview:self.addNew];
}

-(void)refresh
{
    NSMutableArray *array = [RCRecordData recordDataWithKey:RCRD_FASTLINK];
    self.objectList = [NSMutableArray arrayWithArray:array];
//    [self.objectList addObject:@"addNew"];
    [self.gridView reloadData];
    
    [self repositionAddNewButton];

}


-(BOOL)canBeSlided
{
    if (self.scrollView.contentOffset.x<self.frame.size.width) {
        return YES;
    }
    
    return NO;
}

-(void)addNewTapped
{
    RCAddNewViewController *addnewVC = [[[RCAddNewViewController alloc] init] autorelease];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        addNew button currently disabled
        self.addNew = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.addNew addTarget:self action:@selector(addNewTapped) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIScrollView *scrollView = [[[UIScrollView alloc] initWithFrame:self.bounds] autorelease];
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        UIWebView *html = [[UIWebView alloc]initWithFrame:scrollView.bounds];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"navigation" ofType:@"html"];
        [html loadHTMLString:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
        [scrollView addSubview:html];
        
        CGRect rect = CGRectOffset(html.frame, frame.size.width, 0);
        
    
        GMGridView *gmGridView = [[[GMGridView alloc] initWithFrame:rect] autorelease]; //self.bounds
        gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        gmGridView.backgroundColor = [UIColor clearColor];
        gmGridView.style = GMGridViewStylePush;
        gmGridView.itemSpacing = FL_GAP;
        gmGridView.minEdgeInsets = UIEdgeInsetsMake(FL_MARGIN, FL_MARGIN, FL_MARGIN, FL_MARGIN);
        gmGridView.actionDelegate = self;
        gmGridView.sortingDelegate = self;
//        gmGridView.transformDelegate = self;
        gmGridView.dataSource = self;
//        [self addSubview:gmGridView];
        [scrollView addSubview:gmGridView];
        self.gridView = gmGridView;
        gmGridView.backgroundColor = [UIColor blackColor];
        
        
        scrollView.contentSize = CGSizeMake(CGRectGetMaxX(gmGridView.frame), frame.size.height);
        scrollView.contentOffset = CGPointMake(gmGridView.frame.origin.x, 0);
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
    return self.objectList.count;
}

- (CGSize)sizeForItemsInGMGridView:(GMGridView *)gridView
{
    return CGSizeMake(FL_ICON_SIZE, FL_ICON_SIZE);
}

-(void)testButtonTap
{
    if (self.gridView.isEditing) {
        self.gridView.editing = NO;
    }
    [self repositionAddNewButton];
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{    
    CGSize size = [self sizeForItemsInGMGridView:gridView];

    GMGridViewCell *cell = [gridView dequeueReusableCell];  
//    if (index == self.objectList.count-1) {
//        if (!cell) {
//            cell = [[GMGridViewCell alloc] init];
//            cell.contentView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)] autorelease];
//            cell.contentView.backgroundColor = [UIColor blueColor];
//        }
//        return cell;
//    }    
    if (!cell) 
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        cell.contentView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)] autorelease];
    }    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    RCFastLinkObject* obj = [self.objectList objectAtIndex:index];
    RCFastLinkButton *iconButton = [[[RCFastLinkButton alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) Icon:obj.icon Name:obj.name] autorelease];
    [iconButton addTarget:self action:@selector(testButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:iconButton];

    return cell;
}

- (void)GMGridView:(GMGridView *)gridView deleteItemAtIndex:(NSInteger)index
{
    [self.objectList removeObjectAtIndex:index];
//    NSMutableArray *array = self.objectList;
//    [array removeLastObject];
    [RCRecordData updateRecord:self.objectList ForKey:RCRD_FASTLINK];
    if (self.objectList.count == 0) {
        self.gridView.editing = NO;
        [self performSelector:@selector(repositionAddNewButton) withObject:nil afterDelay:.5];
//        [self repositionAddNewButton];
    }
}

#pragma mark GMGridViewSortingDelegate
- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
{    
    self.addNew.hidden = YES;
    gridView.editing = YES;
    [UIView animateWithDuration:0.3 
                          delay:0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor orangeColor];
//                         cell.contentView.layer.shadowOpacity = 0.7;
                     } 
                     completion:^(BOOL finished) {
                     }
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
                     completion:^(BOOL finished) {    
                         
                     }
     ];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    return YES;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
    id object = [self.objectList objectAtIndex:oldIndex];
    [self.objectList removeObjectAtIndex:oldIndex];
//        [self.objectList removeObject:object];
    [self.objectList insertObject:object atIndex:newIndex];
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
    [self.objectList exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}




@end
