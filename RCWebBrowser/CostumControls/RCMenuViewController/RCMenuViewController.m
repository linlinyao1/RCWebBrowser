//
//  RCMenuViewController.m
//  RCWebBrowser
//
//  Created by imac on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCMenuViewController.h"
#import "RCSubMenuViewController.h"
#import "CustomCell.h"
#import "RCSettingMenuViewController.h"

@interface RCMenuViewController ()
@property (nonatomic,retain)NSArray* menuItems;
@end

@implementation RCMenuViewController
@synthesize menuItems = _menuItems;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGRect frame = self.tableView.frame;
    frame.size.width = frame.size.width - self.tableView.revealSideInset.right;
    self.tableView.frame = frame;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView addObserver:self 
                     forKeyPath:@"revealSideInset"
                        options:NSKeyValueObservingOptionNew
                        context:NULL];
    
    
    self.menuItems = [NSArray arrayWithObjects:@"收藏夹",
                                              @"历史记录",
                                              @"最常访问",
                                              @"系统设置",
                                              nil];
    
}

- (void)viewDidUnload
{
    [self.tableView removeObserver:self
                        forKeyPath:@"revealSideInset"];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    @try {
        [self.tableView removeObserver:self
                            forKeyPath:@"revealSideInset"];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"revealSideInset"]) {
        UIEdgeInsets newInset = self.tableView.contentInset;
        newInset.top = self.tableView.revealSideInset.top;
        newInset.bottom = self.tableView.revealSideInset.bottom;
        self.tableView.contentInset = newInset;
    }
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;    
    cell.revealSideInset = self.tableView.revealSideInset;
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    if (indexPath.row == 3) {
        RCSettingMenuViewController *detailViewController = [[RCSettingMenuViewController alloc] initWithStyle:UITableViewStyleGrouped];
        detailViewController.tableView.contentInset = self.tableView.contentInset;
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];   
    }else {
        RCSubMenuViewController *detailViewController = [[RCSubMenuViewController alloc] initWithSubMenuType:indexPath.row+1];
        detailViewController.tableView.contentInset = self.tableView.contentInset;
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
    
}

@end
