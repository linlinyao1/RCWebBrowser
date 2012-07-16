//
//  RCSettingMenuViewController.m
//  RCWebBrowser
//
//  Created by imac on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCSettingMenuViewController.h"

@interface RCSettingMenuViewController ()
//@property (nonatomic,retain) NSArray *sectionTitles;
//@property (nonatomic,retain) NSArray *section1cells;
//@property (nonatomic,retain) NSArray *section2cells;
//@property (nonatomic,retain) NSArray *section3cells;
//@property (nonatomic,retain) NSArray *section4cells;
@end

@implementation RCSettingMenuViewController
//@synthesize section1cells = _section1cells;
//@synthesize section2cells = _section2cells;
//@synthesize section3cells = _section3cells;
//@synthesize section4cells = _section4cells;
//@synthesize sectionTitles = _sectionTitles;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    

    
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int rows;
    if (section == 0) {
        rows = 1;
    }else {
        rows = 3;
    }
    return rows;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == 0) {
        title = @"搜索引擎设置";
    }else if (section == 1) {
        title = @"隐私信息保护";
    }else if (section == 2) {
        title = @"个人体验";
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = @"当前搜索引擎";
    }else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"清除历史记录";
            }
            break;
            case 1:
            {
                cell.textLabel.text = @"清除Cookies";
            }
            break;
            case 2:
            {
                cell.textLabel.text = @"清除全部缓存";
            }
            break;    
            default:
                break;
        }
    }else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"产品使用许可协议";
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"用户体验改进计划";
            }
                break;
            case 2:
            {
                cell.textLabel.text = @"意见反馈";
            }
                break;    
            default:
                break;
        }
    }else if (indexPath.section == 3) {
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"关于2345";
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"给2345浏览器打分";
            }
                break;
            case 2:
            {
                cell.textLabel.text = @"检查更新";
            }
                break;    
            default:
                break;
        }
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
