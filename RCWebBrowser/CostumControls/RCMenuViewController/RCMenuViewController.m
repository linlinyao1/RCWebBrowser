//
//  RCMenuViewController.m
//  RCWebBrowser
//
//  Created by imac on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCMenuViewController.h"
#import "RCSubMenuViewController.h"
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

//-(void)viewDidDisappear:(BOOL)animated
//{
//    [self.navigationController setNavigationBarHidden:NO];  
//}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGRect frame = self.tableView.frame;
    frame.size.width = frame.size.width - 60;
    self.tableView.frame = frame;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];  
}
- (void)viewDidLoad
{
    [super viewDidLoad];    
    self.menuItems = [NSArray arrayWithObjects:@"收藏夹",
                                              @"历史记录",
                                              @"最常访问",
                                              @"系统设置",
                                              nil];
//    self.tableView.backgroundColor = [UIColor colorWithPatternImage:RC_IMAGE(@"MenuBG")];
    self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:RC_IMAGE(@"MenuBG")] autorelease];
//    self.tableView.separatorColor = [UIColor colorWithPatternImage:RC_IMAGE(@"MenuSeperateLine")];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    
//    // Release any cached data, images, etc that aren't in use.
//}


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
        cell.accessoryView = [[[UIImageView alloc] initWithImage:RC_IMAGE(@"MenuDetailIndicate")] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        
        UIImageView *separator = [[[UIImageView alloc] initWithImage:RC_IMAGE(@"MenuSeparateLine")] autorelease];
        separator.frame = CGRectMake(0, 42, 320-60, 2);
        [cell.contentView addSubview:separator];
        
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        
        cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:RC_IMAGE(@"MenuCellSelection")] autorelease];
    }
    cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row];
    if ([cell.textLabel.text isEqualToString:@"收藏夹"]) {
        cell.imageView.image = RC_IMAGE(@"MenuIcon_BookMark");
    }else if ([cell.textLabel.text isEqualToString:@"历史记录"]) {
        cell.imageView.image = RC_IMAGE(@"MenuIcon_History");
    }else if ([cell.textLabel.text isEqualToString:@"最常访问"]) {
        cell.imageView.image = RC_IMAGE(@"MenuIcon_MostViewed");
    }else if ([cell.textLabel.text isEqualToString:@"系统设置"]) {
        cell.imageView.image = RC_IMAGE(@"MenuIcon_Setting");
    }
    
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
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

-(void)dealloc
{
    [_menuItems release];
    [super dealloc];
}


@end
