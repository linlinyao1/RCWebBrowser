//
//  RCAddNewViewController.m
//  RCWebBrowser
//
//  Created by imac on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCAddNewViewController.h"
#import "GMGridView.h"

typedef enum {
    AddNewSitesCommon = 0,
    AddNewSitesBBS,
    AddNewSitesLife,
    AddNewSitesTool,
    AddNewSitesMan,
    AddNewSitesWoman,
    AddNewSitesShopping,
    AddNewSitesManul,
    
    AddNewSitesCount
} AddNewSites;




@interface RCAddNewViewController () <UITableViewDelegate,UITableViewDataSource,GMGridViewDataSource,GMGridViewActionDelegate>
@property (nonatomic,retain)UITableView* channelTable;
@property (nonatomic,retain)GMGridView* siteTable;
@property (nonatomic,retain)NSMutableArray* listSites;
@end

@implementation RCAddNewViewController
@synthesize channelTable = _channelTable;
@synthesize siteTable = _siteTable;
@synthesize listSites = _listSites;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization  
    }
    return self;
}

-(void)loadView
{
    self.listSites = [NSMutableArray arrayWithCapacity:1];
    
    
    UITableView *tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 110, 480) style:UITableViewStylePlain] autorelease];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.channelTable = tableView;
    [self.view addSubview:tableView];
    
    GMGridView *gmGridView = [[[GMGridView alloc] initWithFrame:CGRectMake(110, 0, 210, 480)] autorelease]; //self.bounds
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    gmGridView.style = GMGridViewStylePush;
    gmGridView.itemSpacing = 10;
    gmGridView.minEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    gmGridView.actionDelegate = self;
    gmGridView.dataSource = self;
    gmGridView.backgroundColor = [UIColor whiteColor];
    self.siteTable = gmGridView;
    [self.view addSubview:gmGridView];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return AddNewSitesCount;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    switch (indexPath.row) {
        case AddNewSitesCommon:
            cell.textLabel.text = @"常用网站";
            break;
        case AddNewSitesBBS:
            cell.textLabel.text = @"社区论坛";
            break;
        case AddNewSitesLife:
            cell.textLabel.text = @"生活旅行";
            break;
        case AddNewSitesTool:
            cell.textLabel.text = @"常用工具";
            break;
        case AddNewSitesMan:
            cell.textLabel.text = @"男性频道";
            break;
        case AddNewSitesWoman:
            cell.textLabel.text = @"女性频道";
            break;
        case AddNewSitesShopping:
            cell.textLabel.text = @"购物频道";
            break;
        case AddNewSitesManul:
            cell.textLabel.text = @"手工添加";
            break;
    }
//    cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row];
//    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;    
//    cell.revealSideInset = self.tableView.revealSideInset;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //test
    [self.listSites removeAllObjects];
    for (int i=0; i<(indexPath.row+1); i++) {
        [self.listSites addObject:[NSNumber numberWithInt:i]];
    }
    [self.siteTable reloadData];
}



#pragma mark - GMGridViewDataSource,GMGridViewActionDelegate

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %d", position);
}

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return self.listSites.count;
}

- (CGSize)sizeForItemsInGMGridView:(GMGridView *)gridView
{
    return CGSizeMake(64, 64);
}

//-(void)testButtonTap
//{
//    if (self.gridView.isEditing) {
//        self.gridView.editing = NO;
//    }
//    [self repositionAddNewButton];
//}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{    
    CGSize size = [self sizeForItemsInGMGridView:gridView];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];   
    if (!cell) 
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        cell.contentView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)] autorelease];
    }    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.contentView.backgroundColor = [UIColor redColor];
    
    return cell;
}





@end
