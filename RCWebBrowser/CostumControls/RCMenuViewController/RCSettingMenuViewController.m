//
//  RCSettingMenuViewController.m
//  RCWebBrowser
//
//  Created by imac on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCSettingMenuViewController.h"
#import "RCRecordData.h"
#import "RCSearchEnginePop.h"
#import "RCSearchEngineSettingViewController.h"

typedef enum {
    OptionSectionSearchEngine = 0,
    OptionSectionPrivate,
    OptionSectionNiteMode,    
    OptionSectionBackground,
    OptionSectionUE,
    OptionSectionAbout,

    OptionSectionsCount
} OptionsTypeSections;


typedef enum {
    OptionSearchEngineType = 0,
    
    OptionSearchEngineCount
} OptionSearchEngine;

typedef enum {
    OptionPrivateHistory = 0,
    OptionPrivateCookies,
    OptionPrivateCache,

    OptionPrivateCount
} OptionPrivate;



typedef enum {
    OptionNiteModeOnOff = 0,
    
    OptionNiteModeCount
} OptionNiteMode;

typedef enum {
    OptionBackgroundSelect = 0,
    
    OptionBackgroundCount
} OptionBackground;

typedef enum {
    OptionUEProtocol = 0,
    OptionUEImprove,
    OptionUESuggestion,
    
    OptionUECount
} OptionUE;

typedef enum {
    OptionAbout2345 = 0,
    OptionAboutRating,
    OptionAboutUpdate,
    
    OptionAboutCount
} OptionAbout;



@interface RCSettingMenuViewController ()<UIAlertViewDelegate>
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.tableView.frame = CGRectMake(0, 0, 320-60, self.tableView.frame.size.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:RC_IMAGE(@"MenuBG")] autorelease];   
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
    NSLog(@"%@",[[UIDevice currentDevice] systemVersion]);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(setBrightness:)]) {
        return OptionSectionsCount;
    }else {
        return OptionSectionsCount-1;
    }
//    return OptionSectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int rows = 0;
    switch (section) {
        case OptionSectionSearchEngine:
            rows = OptionSearchEngineCount;
            break;
        case OptionSectionPrivate:
            rows = OptionPrivateCount;
            break;
        case OptionSectionNiteMode:
            if (([[UIScreen mainScreen] respondsToSelector:@selector(setBrightness:)])) {
                rows = OptionNiteModeCount;
            }else {
                rows = 0;
            }
            break;
        case OptionSectionBackground:
            rows = OptionBackgroundCount;
            break;
        case OptionSectionUE:
            rows = OptionUECount;
            break;
        case OptionSectionAbout:
            rows = OptionAboutCount;
            break;
    }    
    return rows;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    if (section == OptionSectionSearchEngine) {
        title = @"搜索引擎设置";
    }else if (section == OptionSectionPrivate) {
        title = @"隐私信息保护";
    }else if (section == OptionSectionBackground) {
        title = @"选择背景";
    }else if (section == OptionSectionUE) {
        title = @"个人体验";
    }
    return title;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == OptionSectionSearchEngine||
        section == OptionSectionPrivate||
        section == OptionSectionBackground||
        section == OptionSectionUE) {
        return 44;
    }
    return 10;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    if (section == OptionSectionSearchEngine) {
        title = @"搜索引擎设置";
    }else if (section == OptionSectionPrivate) {
        title = @"隐私信息保护";
    }else if (section == OptionSectionBackground) {
        title = @"选择背景";
    }else if (section == OptionSectionUE) {
        title = @"个人体验";
    }
    UILabel *titleLebel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)] autorelease];
//    titleLebel.font = [UIFont systemFontOfSize:12];
    titleLebel.text = title;
    titleLebel.textColor = [UIColor whiteColor];
    titleLebel.backgroundColor = [UIColor clearColor];
    
    return titleLebel;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryView = nil;
//    cell.backgroundColor = [UIColor colorWithRed:251/255 green:251/255 blue:251/255 alpha:1];
    cell.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0.98 alpha:1];
    
    if ([indexPath section] == OptionSectionSearchEngine)
    {
        switch ([indexPath row]) 
        {
            case OptionSearchEngineType:
                {
                    cell.textLabel.text = @"当前搜索引擎";
                    UIView *detail = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 65, 44)] autorelease];
                    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, -2, 35, tableView.rowHeight)];
                    title.text = [RCSearchEnginePop titleForSEType:[[[NSUserDefaults standardUserDefaults] objectForKey:SE_UDKEY] intValue]];
                    title.backgroundColor = [UIColor clearColor];
                    [detail addSubview:title];
                    [title release];
                
                    UIImageView *indicator = [[UIImageView alloc] initWithImage:RC_IMAGE(@"MenuDetailIndicate")];
                    indicator.frame = CGRectMake(35, 7, 29, 29);
                    [detail addSubview:indicator];
                    [indicator release];
                    cell.accessoryView = detail;
                }
                break;
        }
    }else if ([indexPath section] == OptionSectionPrivate) {
        switch ([indexPath row]) 
        {
            case OptionPrivateHistory:
                {
                    cell.textLabel.text = @"清除历史记录";                
                }
                break;
            case OptionPrivateCookies:
                {
                    cell.textLabel.text = @"清除Cookies";                
                }
                break;
            case OptionPrivateCache:
                {
                    cell.textLabel.text = @"清除全部缓存";                
                }
                break;
        }
    }
    else if ([indexPath section] == OptionSectionNiteMode) {
        switch ([indexPath row]) 
        {
            case OptionNiteModeOnOff:
                {
                    cell.textLabel.text = @"夜间模式";
                    UISwitch *editingSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    //                [editingSwitch addTarget:self action:@selector(editingSwitchChanged:) forControlEvents:UIControlEventValueChanged];                
                    cell.accessoryView = editingSwitch;
                    [[UIScreen mainScreen]setBrightness:1.0];
                }
                break;
        }
    }
    else if ([indexPath section] == OptionSectionBackground) {
        switch ([indexPath row]) 
        {
            case OptionBackgroundSelect:
                {
                    cell.textLabel.text = @"背景"; // to be continue
                }
                break;
        }
    }else if ([indexPath section] == OptionSectionUE) {
        switch ([indexPath row]) 
        {
            case OptionUEProtocol:
                {
                    cell.textLabel.text = @"产品使用许可协议"; // to be continue
                }
                break;
            case OptionUEImprove:
                {
                    cell.textLabel.text = @"用户体验改进计划"; // to be continue
                }
                break;
            case OptionUESuggestion:
                {
                    cell.textLabel.text = @"意见反馈"; // to be continue
                }
                break;
        }
    }else if ([indexPath section] == OptionSectionAbout) {
        switch ([indexPath row]) 
        {
            case OptionAbout2345:
            {
                cell.textLabel.text = @"关于2345"; // to be continue
            }
                break;
            case OptionAboutRating:
            {
                cell.textLabel.text = @"给2345浏览器打分"; // to be continue
            }
                break;
            case OptionAboutUpdate:
            {
                cell.textLabel.text = @"检查更新"; // to be continue
            }
                break;
        }
    }
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([indexPath section] == OptionSectionSearchEngine)
    {
        switch ([indexPath row]) 
        {
            case OptionSearchEngineType:
            {
//                cell.textLabel.text = @"当前搜索引擎";
                RCSearchEngineSettingViewController *aVC = [[RCSearchEngineSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
                [self.navigationController pushViewController:aVC animated:YES];
                [aVC release];
            }
                break;
        }
    }else if ([indexPath section] == OptionSectionPrivate) {
        switch ([indexPath row]) 
        {
            case OptionPrivateHistory:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认清空历史记录" message:@"清空后将不能找回" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清空", nil];
                [alert show];
            }
                break;
            case OptionPrivateCookies:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认清空Cookies" message:@"清空后将不能找回" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清空", nil];
                [alert show];
            }
                break;
            case OptionPrivateCache:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认清空缓存" message:@"清空后将不能找回" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清空", nil];
                [alert show];
            }
                break;
        }
    }
#if defined (__GNUC__) && (__GNUC__ >= 5)
else if ([indexPath section] == OptionSectionNiteMode) {
        switch ([indexPath row]) 
        {
            case OptionNiteModeOnOff:
            {
//                cell.textLabel.text = @"夜间模式";
//                UISwitch *editingSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//                //                [editingSwitch addTarget:self action:@selector(editingSwitchChanged:) forControlEvents:UIControlEventValueChanged];                
//                cell.accessoryView = editingSwitch;
            }
                break;
        }
    }
#endif
else if ([indexPath section] == OptionSectionBackground) {
        switch ([indexPath row]) 
        {
            case OptionBackgroundSelect:
            {
//                cell.textLabel.text = @"背景"; // to be continue
            }
                break;
        }
    }else if ([indexPath section] == OptionSectionUE) {
        switch ([indexPath row]) 
        {
            case OptionUEProtocol:
            {
//                cell.textLabel.text = @"产品使用许可协议"; // to be continue
            }
                break;
            case OptionUEImprove:
            {
//                cell.textLabel.text = @"用户体验改进计划"; // to be continue
            }
                break;
            case OptionUESuggestion:
            {
//                cell.textLabel.text = @"意见反馈"; // to be continue
            }
                break;
        }
    }else if ([indexPath section] == OptionSectionAbout) {
        switch ([indexPath row]) 
        {
            case OptionAbout2345:
            {
//                cell.textLabel.text = @"关于2345"; // to be continue
            }
                break;
            case OptionAboutRating:
            {
//                cell.textLabel.text = @"给2345浏览器打分"; // to be continue
            }
                break;
            case OptionAboutUpdate:
            {
//                cell.textLabel.text = @"检查更新"; // to be continue
            }
                break;
        }
    }
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = alertView.title;
    if ([title isEqualToString:@"确认清空历史记录"]) {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"清空"]) {
            [RCRecordData updateRecord:nil ForKey:RCRD_HISTORY];
        }
    }else if ([title isEqualToString:@"确认清空Cookies"]) {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"清空"]) {
            NSHTTPCookie *cookie;
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (cookie in [storage cookies]) {
                [storage deleteCookie:cookie];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }else if ([title isEqualToString:@"确认清空缓存"]) {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"清空"]) {
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
        }
    }
    
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}







@end
