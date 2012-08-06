//
//  RCSearchEngineSettingViewController.m
//  RCWebBrowser
//
//  Created by imac on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCSearchEngineSettingViewController.h"
#import "RCSearchEnginePop.h"
#import "UIBarButtonItem+BackStyle.h"

@interface RCSearchEngineSettingViewController ()

@end

@implementation RCSearchEngineSettingViewController

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
    [super viewDidDisappear:animated];
    self.tableView.frame = CGRectMake(0, 0, 320-60, self.tableView.frame.size.height);

}
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:RC_IMAGE(@"MenuBG")] autorelease];    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *newBackButton = [UIBarButtonItem barButtonWithCustomImage:RC_IMAGE(@"MenuItemBack@2x") HilightImage:nil Title:@"返回" Target:self Action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = newBackButton;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSInteger curSE = [[[NSUserDefaults standardUserDefaults] objectForKey:SE_UDKEY] intValue];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:curSE inSection:0] animated:NO scrollPosition:UITableViewRowAnimationNone];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:curSE inSection:0]];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return SETypeCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = [RCSearchEnginePop titleForSEType:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:indexPath.row] forKey:SE_UDKEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

@end
