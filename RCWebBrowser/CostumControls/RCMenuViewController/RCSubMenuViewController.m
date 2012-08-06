//
//  RCSubMenuViewController.m
//  RCWebBrowser
//
//  Created by imac on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCSubMenuViewController.h"
#import "BookmarkObject.h"
#import "PPRevealSideViewController.h"
#import "RCRecordData.h"
#import "RCViewController.h"
#import "RCBookMarkEditViewController.h"
#import "UIBarButtonItem+BackStyle.h"

@interface RCSubMenuViewController ()<UIAlertViewDelegate>
@property (nonatomic,retain) NSMutableArray* submenuItems;
@property (nonatomic) RCSubMenuType menuType;
@end

@implementation RCSubMenuViewController
@synthesize submenuItems = _submenuItems;
@synthesize menuType = _menuType;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.view.autoresizesSubviews = NO;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    header.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [header addSubview:titleLabel];
    if (self.menuType == RCSubMenuFavorite) {
        NSMutableArray *bookmarksArray = [RCRecordData recordDataWithKey:RCRD_BOOKMARK];
        self.submenuItems = [NSMutableArray arrayWithArray:bookmarksArray];   
        
        titleLabel.text = @"本地收藏";
        UIButton *edit = [UIButton buttonWithType:UIButtonTypeCustom];
        edit.frame = CGRectMake(130, 7, 53, 29);
        [edit setBackgroundImage:RC_IMAGE(@"MenuItemNomal") forState:UIControlStateNormal];
        edit.titleLabel.font = [UIFont systemFontOfSize:12];
        if (!self.tableView.isEditing) {
            [edit setTitle:@"编辑" forState:UIControlStateNormal];
        }else {
            [edit setTitle:@"完成" forState:UIControlStateNormal];
        }
        [edit addTarget:self action:@selector(favEdit:) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:edit];
    }else if (self.menuType == RCSubMenuHistory) {
        NSMutableArray *historyArray = [RCRecordData recordDataWithKey:RCRD_HISTORY];
        self.submenuItems = [NSMutableArray arrayWithArray:historyArray];
        
        titleLabel.text = @"历史记录";
        UIButton *clear = [UIButton buttonWithType:UIButtonTypeCustom];
        clear.frame = CGRectMake(130, 7, 53, 29);
        clear.titleLabel.font = [UIFont systemFontOfSize:12];
        [clear setBackgroundImage:RC_IMAGE(@"MenuItemNomal") forState:UIControlStateNormal];
        [clear setTitle:@"清空" forState:UIControlStateNormal];
        [clear addTarget:self action:@selector(clearHistory:) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:clear];
    }else if (self.menuType == RCSubMenuMostViewed) {
        NSMutableArray *historyArray = [RCRecordData recordDataWithKey:RCRD_HISTORY];
        [historyArray sortedArrayUsingComparator:^NSComparisonResult(BookmarkObject* obj1, BookmarkObject* obj2) {
            return [obj1.count compare:obj2.count];
        }];
        self.submenuItems = historyArray;
        
        titleLabel.text = @"最常访问";
        UIButton *clear = [UIButton buttonWithType:UIButtonTypeCustom];
        clear.frame = CGRectMake(130, 7, 53, 29);
        clear.titleLabel.font = [UIFont systemFontOfSize:12];
        [clear setBackgroundImage:RC_IMAGE(@"MenuItemNomal") forState:UIControlStateNormal];
        [clear setTitle:@"清空" forState:UIControlStateNormal];
        [clear addTarget:self action:@selector(clearMostViewed:) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:clear];
    }
    self.navigationItem.titleView = header;
    [self.tableView reloadData];
    
    [titleLabel release];
    [header release];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tableView.frame = CGRectMake(0, 0, 320-60, self.tableView.frame.size.height);
}


//
//-(void)makeRightBarButtonItemWithButton:(UIBarButtonItem*)button
//{
//    UIToolbar *tools = [[UIToolbar alloc]
//                        initWithFrame:CGRectMake(0.0f, 0.0f, 103.0f, 44.01f)]; // 44.01 shifts it up 1px for some reason
//    tools.clearsContextBeforeDrawing = NO;
//    tools.clipsToBounds = NO;
//    //                tools.tintColor = [UIColor colorWithWhite:0.305f alpha:0.0f]; // closest I could get by eye to black, translucent style.
//    // anyone know how to get it perfect?
//    tools.barStyle = UIBarStyleDefault;// clear background
//    tools.translucent = YES;
//    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
//    UIBarButtonItem *space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
//    space.width = self.tableView.revealSideInset.right+40;
//    [buttons addObject:button];
//    [buttons addObject:space];
//    [tools setItems:buttons];
//    UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc] initWithCustomView:tools] autorelease];
//    self.navigationItem.rightBarButtonItem = rightButton;
//}

-(id)initWithSubMenuType:(RCSubMenuType)type
{
    self.menuType = type;
    if (type != RCSubMenuSetting) {
        self = [super initWithStyle:UITableViewStylePlain];
    }else {
        self = [super initWithStyle:UITableViewStyleGrouped];
    }
    
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];

    return self;
}




-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:RC_IMAGE(@"MenuBG")] autorelease];    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    UIBarButtonItem *newBackButton = [UIBarButtonItem barButtonWithCustomImage:RC_IMAGE(@"MenuItemBack@2x") HilightImage:nil Title:@"返回" Target:self Action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = newBackButton;
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





-(void)favEdit:(UIButton*)sender
{
    if (!self.tableView.isEditing) {
        [self.tableView setEditing:YES animated:YES];
        [sender setTitle:@"完成" forState:UIControlStateNormal];
    }else {
        [self.tableView setEditing:NO animated:YES];
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
    }
}

-(void)clearHistory:(UIButton*)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认清空历史记录" message:@"清空后将不能找回" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清空", nil];
    [alert show];
    [alert release];
}
-(void)clearMostViewed:(UIButton*)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认清空最常访问" message:@"清空后将不能找回" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清空", nil];
    [alert show];
    [alert release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"取消"]) {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"清空"]) {
        [self.submenuItems removeAllObjects];
        [RCRecordData updateRecord:self.submenuItems ForKey:RCRD_HISTORY];
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.submenuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        
        UIImageView *separator = [[[UIImageView alloc] initWithImage:RC_IMAGE(@"MenuSeparateLine")] autorelease];
        separator.frame = CGRectMake(0, 42, 320-60, 2);
        [cell.contentView addSubview:separator];
        cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:RC_IMAGE(@"MenuCellSelection")] autorelease];
    }
//    cell.imageView.image = nil;
//    if (self.menuType == RCSubMenuFavorite) {
        cell.imageView.image = RC_IMAGE(@"subMenuIconFav");
//    }
    BookmarkObject *obj = [self.submenuItems objectAtIndex:indexPath.row];
    NSLog(@"count:%@",obj.count);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = obj.name;
    cell.detailTextLabel.text = obj.url.absoluteString;
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.submenuItems removeObjectAtIndex:indexPath.row];
        if (self.menuType == RCSubMenuFavorite) {
            [RCRecordData updateRecord:self.submenuItems ForKey:RCRD_BOOKMARK];
        }else {
            [RCRecordData updateRecord:self.submenuItems ForKey:RCRD_HISTORY];
        }
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";  
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.menuType != RCSubMenuSetting) {
        if (!self.tableView.editing) {
            [self.revealSideViewController popViewControllerAnimated:YES];
            RCViewController *rcVC = (RCViewController *)self.revealSideViewController.rootViewController;
            [rcVC loadURLWithCurrentTab:[NSURL  URLWithString:cell.detailTextLabel.text]];
        }else {
            RCBookMarkEditViewController *bmEdit = [[RCBookMarkEditViewController alloc] initWithNibName:@"RCBookMarkEditViewController" bundle:nil];
            bmEdit.index = indexPath.row;
            [self.navigationController pushViewController:bmEdit animated:YES];
            [bmEdit release];

        }
    }
}

-(void)dealloc
{
    [_submenuItems release];
    [super dealloc];
}

@end
