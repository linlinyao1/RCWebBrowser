//
//  RCSettingMenuViewController.m
//  RCWebBrowser
//
//  Created by imac on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCSettingMenuViewController.h"

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
    return OptionSectionsCount;
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
            rows = OptionNiteModeCount;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    if ([indexPath section] == OptionSectionSearchEngine)
    {
        switch ([indexPath row]) 
        {
            case OptionSearchEngineType:
                {
                    cell.textLabel.text = @"当前搜索引擎";
                    
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
    }else if ([indexPath section] == OptionSectionNiteMode) {
        switch ([indexPath row]) 
        {
            case OptionNiteModeOnOff:
                {
                    cell.textLabel.text = @"夜间模式";
                    UISwitch *editingSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    //                [editingSwitch addTarget:self action:@selector(editingSwitchChanged:) forControlEvents:UIControlEventValueChanged];                
                    cell.accessoryView = editingSwitch;
                }
                break;
        }
    }else if ([indexPath section] == OptionSectionBackground) {
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
