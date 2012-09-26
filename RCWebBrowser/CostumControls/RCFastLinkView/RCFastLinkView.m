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
#import "RCAddNewViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "RCGridView.h"

#define FL_MARGIN  17
#define FL_GAP 10
#define FL_ICON_SIZE 64

static RCFastLinkView *_fastLinkView;

@interface RCFastLinkView ()<UIWebViewDelegate,RCGridViewDataSource,RCGridViewDelegate,UIScrollViewDelegate>
@property (nonatomic,retain) NSMutableArray *objectList;
@property (nonatomic) BOOL isInEditMode;
@property (nonatomic) CGPoint movingPosition;
@property (nonatomic,retain) UIButton *addNew;
@property (nonatomic,retain) RCGridView* gridView;
@property (nonatomic,retain) UIScrollView *scrollBoard;
@property (nonatomic,retain) UIWebView *htmlNav;
@property (nonatomic,retain) UIImageView *indicator;
@end


@implementation RCFastLinkView
@synthesize objectList = _objectList;
@synthesize scrollBoard = _scrollBoard;
@synthesize isInEditMode = _isInEditMode;
@synthesize movingPosition = _movingPosition;
@synthesize addNew = _addNew;
@synthesize gridView = _gridView;
@synthesize htmlNav = _htmlNav;
@synthesize delegate = _delegate;
@synthesize indicator = _indicator;
-(BOOL)editing
{
    return self.gridView.isEditing;
}
-(void)setEding:(BOOL)editing
{
    self.gridView.editing = editing;
}

-(void)repositionAddNewButton
{

}

-(void)refresh
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSMutableArray *array = [RCRecordData recordDataWithKey:RCRD_FASTLINK];
//        self.objectList = [NSMutableArray arrayWithArray:array];        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.gridView reloadData];
//            self.gridView.editing = NO;
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"navigation" ofType:@"html"];
//            [self.htmlNav loadHTMLString:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
//
//        });         
//    });
    
    NSMutableArray *array = [RCRecordData recordDataWithKey:RCRD_FASTLINK];
//    if (self.objectList.count != array.count) {
//        self.objectList = [NSMutableArray arrayWithArray:array];
//        [self.gridView reloadData];
//    }else {
////        for (RCFastLinkObject *obj1 in array) {
////            BOOL flag = NO;
////            for (RCFastLinkObject *obj2 in self.objectList) {
////                if ([obj1.url isEqual:obj2]) {
////                    break;
////                }
////            }
////            
////        }
//    }
    self.objectList = [NSMutableArray arrayWithArray:array];
    [self.gridView reloadData];
    
    self.gridView.editing = NO;
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"navigation" ofType:@"html"];
//    [self.htmlNav loadHTMLString:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
}


-(BOOL)canBeSlided
{
    if (self.scrollBoard.contentOffset.x<self.frame.size.width) {
        return YES;
    }
    
    return NO;
}


-(void)scrollPage
{
    if (self.scrollBoard.contentOffset.x>0) {
        [self.scrollBoard scrollRectToVisible:self.htmlNav.frame animated:YES];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"navigation" ofType:@"html"];
        [self.htmlNav loadHTMLString:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
    }else {
        [self.scrollBoard scrollRectToVisible:self.gridView.frame animated:YES];
    }
}


-(void)addNewTapped
{
    RCAddNewViewController *addnewVC = [[RCAddNewViewController alloc] initWithNibName:@"RCAddNewViewController" bundle:nil];
    addnewVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentModalViewController:addnewVC animated:YES];
    [addnewVC release];

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        
        self.backgroundColor = [UIColor colorWithPatternImage:RC_IMAGE(@"fastlinkBG")];

//        
        UIScrollView *scrollView = [[[UIScrollView alloc] initWithFrame:self.bounds] autorelease];
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollBoard = scrollView;
        
        UIWebView *html = [[[UIWebView alloc]initWithFrame:self.bounds] autorelease];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"navigation" ofType:@"html"];
        [html loadHTMLString:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
        [self.scrollBoard addSubview:html];
        html.delegate = self;
        html.backgroundColor = [UIColor clearColor];
        html.opaque = NO;
        self.htmlNav = html;
        
        
        CGRect rect = CGRectOffset(self.bounds, frame.size.width, 0);
//        rect.size.height = self.bounds.size.height-23;
        
        RCGridView *gridView = [[RCGridView alloc] initWithFrame:rect];
        gridView.cellSize = CGSizeMake(FL_ICON_SIZE, FL_ICON_SIZE);
        gridView.minEdgeInsets = UIEdgeInsetsMake(FL_MARGIN, FL_MARGIN, FL_MARGIN, FL_MARGIN);
        gridView.horizonalCellGap = FL_GAP;
        gridView.verticalCellGap = FL_GAP;
        gridView.disableEditWhenTapInvalid = YES;
        gridView.dataSource = self;
        gridView.delegate = self;
        [self.scrollBoard addSubview:gridView];
        self.gridView = gridView;
        [gridView release];
//        
        scrollView.contentSize = CGSizeMake(CGRectGetMaxX(gridView.frame), frame.size.height);
        scrollView.contentOffset = CGPointMake(gridView.frame.origin.x, 0);
        
        
        UIImageView *indicatorBG = [[UIImageView alloc] initWithImage:RC_IMAGE(@"indicatorBG")];
//        indicatorBG.alpha = 0.7;
        indicatorBG.frame = CGRectMake(0, self.bounds.size.height-23, 320, 23);
        
        UIImageView *indicator = [[UIImageView alloc] initWithImage:RC_IMAGE(@"indicator_second")];
        indicator.frame = CGRectMake(0, 0, 26, 10);
        indicator.center = CGPointMake(160, 13);
        [indicatorBG addSubview:indicator];
        self.indicator = indicator;
        [indicator release];
        [self addSubview:indicatorBG];
        [indicatorBG release];
    }
    return self;
}

+(RCFastLinkView*)defaultPage
{
    if (!_fastLinkView) {
        _fastLinkView = [[RCFastLinkView alloc] initWithFrame:CGRectMake(0, 0, 320, 332)];
    }
    return _fastLinkView;
}



-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [self.delegate openLink:request.URL];
        return NO;
    }
    return YES;
}



#pragma mark - RCGridViewDataSource


-(void)iconButtonPressed:(UIButton*)sender
{
    if (self.gridView.isEditing) {
        self.gridView.editing = NO;
    }
}

-(RCGridViewCell *)gridView:(RCGridView *)gridView ViewForCellAtIndex:(NSInteger)index
{
    
    RCGridViewCell* cell = [[[RCGridViewCell alloc] initWithFrame:CGRectMake(0, 0, FL_ICON_SIZE, FL_ICON_SIZE)] autorelease];
    
    RCFastLinkObject* obj = [self.objectList objectAtIndex:index];
    UIImage *icon = nil;
    if (obj.isDefault) {
        icon = RC_IMAGE(obj.iconName);
    }else {
        icon = obj.icon;
    }

    RCFastLinkButton *iconButton = [[RCFastLinkButton alloc] initWithFrame:CGRectMake(0, 0, FL_ICON_SIZE, FL_ICON_SIZE) Icon:icon Name:obj.name];
    if ([obj.url.absoluteString isEqualToString:@"http://m.2345.com/"] && [obj.name isEqualToString:@"2345"] && [obj.iconName isEqualToString:@"2345Nav.png"]) {
        cell.disableCloseButton =YES;
    }
    
    [iconButton addTarget:self action:@selector(iconButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:iconButton];
    

    UILabel *nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 47, 54, 15)] autorelease];
    nameLabel.backgroundColor = [UIColor colorWithPatternImage:RC_IMAGE(@"fastlink_textBG")];
    nameLabel.opaque = NO;
    nameLabel.textAlignment = UITextAlignmentCenter;
    nameLabel.text = obj.name;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:10];
    [cell.contentView addSubview:nameLabel];
    [iconButton release];
    return cell;
}

-(NSInteger)numberOfCellsInGridView:(RCGridView *)gridView
{
    return self.objectList.count;
}

-(UIView *)ViewForAddButton:(RCGridView *)gridView
{
    UIImageView* addButton = [[[UIImageView alloc] initWithImage:RC_IMAGE(@"fastlink_addNew")] autorelease];
    addButton.userInteractionEnabled = YES;
    return addButton;
}


#pragma mark - RCGridViewDelegate

-(void)gridView:(RCGridView *)gridView CellWillBeRemovedAtIndex:(NSInteger)index
{
    [self.objectList removeObjectAtIndex:index];
    [RCRecordData updateRecord:self.objectList ForKey:RCRD_FASTLINK];
}

-(void)gridView:(RCGridView *)gridView CellAtIndex:(NSInteger)index1 ExchangeWithCellAtIndex:(NSInteger)index2
{
    [self.objectList exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
    [RCRecordData updateRecord:self.objectList ForKey:RCRD_FASTLINK];
}

-(void)gridView:(RCGridView *)gridView CellTappedAtIndex:(NSInteger)index
{
    NSLog(@"tapped at index : %d",index);
    RCFastLinkObject *flObj = [self.objectList objectAtIndex:index];
    [self.delegate openLink:flObj.url];    
}

-(void)gridView:(RCGridView *)gridView CellWillBeMoved:(RCGridViewCell *)cell
{
    cell.layer.shadowOpacity = 0.3;
    cell.layer.shadowOffset = CGSizeMake(0, 8);
}

-(void)gridView:(RCGridView *)gridView CellWillEndMoving:(RCGridViewCell *)cell
{
    cell.layer.shadowOpacity = 0.3;
    cell.layer.shadowOffset = CGSizeMake(0, 1);
}

-(void)addButtonTapped:(RCGridView *)gridView
{
    [self addNewTapped];
}

-(void)gridViewStartEditing:(RCGridView *)gridView
{
    self.scrollBoard.scrollEnabled = NO;
    [self.delegate fastLinkStartEdting];
}
-(void)gridViewEndEditing:(RCGridView *)gridView
{
    self.scrollBoard.scrollEnabled = YES;
    [self.delegate fastLinkEndEdting];
}



#pragma mark uiscrollviewdelegate

-(void)refreshIndicator
{
    if (self.scrollBoard.contentOffset.x>0) {        
        self.indicator.image = RC_IMAGE(@"indicator_second");
    }else {
        self.indicator.image = RC_IMAGE(@"indicator_first");
    }
    [self.indicator setNeedsDisplay];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self refreshIndicator];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self refreshIndicator];
}


-(void)dealloc
{
    [_objectList release];
    [_scrollBoard release];
    [_addNew release];
    [_gridView release];
    [_htmlNav release];
    [_indicator release];
    [super dealloc];
}
//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"navigation" ofType:@"html"];
//    [self.htmlNav loadHTMLString:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
//}

//#pragma mark GMGridViewActionDelegate
//
//
//- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
//{
//    NSLog(@"Tap on empty space");
//}
//
//- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
//{
//    NSLog(@"Did tap at index %d", position);
//    if (gridView.isEditing) {
//        gridView.editing = NO;
//        return;
//    }
////    id obj = [self.objectList objectAtIndex:position];
////    if ([obj isKindOfClass:[NSString class]] && [obj isEqualToString:@"addNew"]) {
////        RCAddNewViewController *addnewVC = [[RCAddNewViewController alloc] initWithNibName:@"RCAddNewViewController" bundle:nil];
////        addnewVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
////        [[[UIApplication sharedApplication] keyWindow].rootViewController presentModalViewController:addnewVC animated:YES];
////        [addnewVC release];
////    }else {
////        RCFastLinkObject *flObj = (RCFastLinkObject *)obj;
////        [self.delegate openLink:flObj.url];
////    }
//}
//
//-(void)GMGridViewDidTapInvalidPosition:(GMGridView *)gridView
//{
//    if (gridView.isEditing) {
//        gridView.editing = NO;
//        return;
//    }
//}
//
//#pragma mark GMGridViewDataSource
//
//
//- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
//{
//    return self.objectList.count;
//}
//
//- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
//{
//    return CGSizeMake(FL_ICON_SIZE, FL_ICON_SIZE);
//}
//
//-(void)testButtonTap
//{
//    if (self.gridView.isEditing) {
//        self.gridView.editing = NO;
//        self.scrollBoard.scrollEnabled = YES;
//    }
//    [self repositionAddNewButton];
//}
//
//- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
//{    
//    CGSize size = CGSizeMake(FL_ICON_SIZE, FL_ICON_SIZE);
//
//    GMGridViewCell *cell = [gridView dequeueReusableCell];   
//    if (!cell) 
//    {
//        cell = [[[GMGridViewCell alloc] init] autorelease];
//        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
//        cell.deleteButtonOffset = CGPointMake(-15, -15);
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//        view.backgroundColor = [UIColor clearColor];
//        view.layer.masksToBounds = YES;
//        view.layer.cornerRadius = 5;
//        cell.contentView = view;
//    }
//    RCFastLinkObject* obj = [self.objectList objectAtIndex:index];
//    RCFastLinkButton *iconButton = [[RCFastLinkButton alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) Icon:obj.icon Name:obj.name];
//    [iconButton addTarget:self action:@selector(testButtonTap) forControlEvents:UIControlEventTouchUpInside];
//    [cell.contentView addSubview:iconButton];
////    cell.contentView = iconButton;
//    [iconButton release];
//    return cell;
//}
//
//- (void)GMGridView:(GMGridView *)gridView deleteItemAtIndex:(NSInteger)index
//{
//    [self.objectList removeObjectAtIndex:index];
////    NSMutableArray *array = self.objectList;
////    [array removeLastObject];
//    [RCRecordData updateRecord:self.objectList ForKey:RCRD_FASTLINK];
//    if (self.objectList.count == 0) {
//        self.gridView.editing = NO;
//        [self performSelector:@selector(repositionAddNewButton) withObject:nil afterDelay:.5];
//        [self repositionAddNewButton];
//    }
//}
//
//#pragma mark GMGridViewSortingDelegate
//- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
//{    
//    self.addNew.hidden = YES;
//    gridView.editing = YES;
//    self.scrollBoard.scrollEnabled = NO;
//    [UIView animateWithDuration:0.3 
//                          delay:0 
//                        options:UIViewAnimationOptionAllowUserInteraction 
//                     animations:^{
////                         cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width*1.2, cell.frame.size.height*1.2);
////                         cell.contentView.backgroundColor = [UIColor orangeColor];
//                         cell.contentView.layer.shadowOpacity = 0.7;
//                     } 
//                     completion:^(BOOL finished) {
//                     }
//     ];
//}
//
//- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
//{
//    [UIView animateWithDuration:0.3 
//                          delay:0 
//                        options:UIViewAnimationOptionAllowUserInteraction 
//                     animations:^{  
////                         cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width/1.2, cell.frame.size.height/1.2);
////                         cell.contentView.backgroundColor = [UIColor redColor];
//                         cell.contentView.layer.shadowOpacity = 0;
//                     }
//                     completion:^(BOOL finished) {    
//
//                     }
//     ];
//}
//
//- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
//{
//    return NO;
//}
//
//- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
//{
//    id object = [self.objectList objectAtIndex:oldIndex];
////    [self.objectList removeObjectAtIndex:oldIndex];
//        [self.objectList removeObject:object];
//    [self.objectList insertObject:object atIndex:newIndex];
//}
//
//- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
//{
//    [self.objectList exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
//}




@end
