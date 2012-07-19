//
//  RCTabView.m
//  RCWebBrowser
//
//  Created by imac on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCTabView.h"
#import "RCTab.h"

#define ADDBUTTON_WIDTH 32
#define ADDBUTTON_HEIGHT 38
#define TAB_GAP 0

@interface RCTabView ()<RCTabDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) UIButton* addButton;
@property (nonatomic,retain) NSMutableArray *tabItems;
-(void)setUpViews:(CGRect)frame;
@end

@implementation RCTabView
@synthesize tabTable = _tabTable;
@synthesize addButton = _addButton;
@synthesize tabItems = _tabItems;
@synthesize delegate = _delegate;




-(void)hideViewWithOffset:(CGFloat)offset
{
    self.transform = CGAffineTransformMakeTranslation(0, -offset);
}
-(void)showView
{
    self.transform = CGAffineTransformIdentity;
}

-(void)setUpViews:(CGRect)frame
{
    self.tabItems = [NSMutableArray arrayWithObjects:@"new",nil];
    
    [self setBackgroundColor:[UIColor blackColor]];
    
    UITableView *table = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    table.separatorStyle = UITableViewCellSelectionStyleNone;
    table.showsHorizontalScrollIndicator = NO;
    table.showsVerticalScrollIndicator = NO;
    table.rowHeight = 107;
    table.dataSource = self;
    table.delegate = self;
    table.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);  
    table.frame = frame;
//    table.scrollEnabled = NO;
    table.backgroundColor = [UIColor blackColor];
    self.tabTable = table;
    [table release];
    [self addSubview:table];
    
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:RC_IMAGE(@"add_label") forState:UIControlStateNormal];
    [addButton setImage:RC_IMAGE(@"add_label_press") forState:UIControlStateHighlighted];
    addButton.frame = CGRectMake(107, 0, ADDBUTTON_WIDTH,ADDBUTTON_HEIGHT);
    [addButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    addButton.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
//    [self addSubview:addButton];
    self.addButton = addButton;
    
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUpViews:frame];
    }
    return self;
}
-(void)awakeFromNib
{
    [self setUpViews:self.frame];
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 32;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.addButton;
}


-(void)addButtonPressed:(UIButton*)sender
{
    if (![self.delegate tabShouldAdd]) {
        return;
    }

    NSIndexPath *index = [NSIndexPath indexPathForRow:[self.delegate numberOfTabs]-1 inSection:0];

    [self.tabTable insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationLeft];

// TODO: disable scroll when table content size smaller than frame. this must be done after the insert animation
//    if (self.tabTable.contentSize.height+107>=self.tabTable.frame.size.width){
//        self.tabTable.scrollEnabled = YES;
//    }
    [self.tabTable selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self.delegate didSelectedTabAtIndex:index.row]; // selectRowAtIndexPath wont call the delegate, so call it manually

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.delegate numberOfTabs];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifier = @"cell";
    RCTab *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[RCTab alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.delegate = self;
        cell.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [self.delegate titleForTabAtIndex:indexPath.row];
    cell.imageView.image = [self.delegate faviconForTabAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate didSelectedTabAtIndex:indexPath.row];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate didDeselectedTabAtIndex:indexPath.row];
}

-(void)tabNeedsToClose:(RCTab *)tab
{
    NSIndexPath *index = [self.tabTable indexPathForCell:tab];
    
    if (![self.delegate tabShouldCloseAtIndex:index.row]) {
        return;
    }

    [self.tabTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationLeft];
    
    if (index.row >= [self.delegate numberOfTabs]) {
        [self.tabTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:index.row-1 inSection:0 ] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self.delegate didSelectedTabAtIndex:index.row-1]; // selectRowAtIndexPath wont call the delegate, so call it manually
    }else {
        [self.tabTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:index.row inSection:0 ] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self.delegate didSelectedTabAtIndex:index.row]; // selectRowAtIndexPath wont call the delegate, so call it manually
    }
    
}

-(BOOL)canCloseCell
{
    if ([self.delegate numberOfTabs] == 1) {
        return NO;
    }
    return YES;
}


@end
