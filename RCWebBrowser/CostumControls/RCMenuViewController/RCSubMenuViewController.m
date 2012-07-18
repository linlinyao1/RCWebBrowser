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


@interface RCSubMenuViewController ()
@property (nonatomic,retain) NSMutableArray* submenuItems;
@end

@implementation RCSubMenuViewController
@synthesize submenuItems = _submenuItems;


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
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tableView.frame = CGRectMake(0, 0, 260, self.tableView.frame.size.height);
}

-(void)makeRightBarButtonItemWithButton:(UIBarButtonItem*)button
{
    UIToolbar *tools = [[UIToolbar alloc]
                        initWithFrame:CGRectMake(0.0f, 0.0f, 103.0f, 44.01f)]; // 44.01 shifts it up 1px for some reason
    tools.clearsContextBeforeDrawing = NO;
    tools.clipsToBounds = NO;
    //                tools.tintColor = [UIColor colorWithWhite:0.305f alpha:0.0f]; // closest I could get by eye to black, translucent style.
    // anyone know how to get it perfect?
    tools.barStyle = UIBarStyleDefault;// clear background
    tools.translucent = YES;
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
    UIBarButtonItem *space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    space.width = self.tableView.revealSideInset.right+40;
    [buttons addObject:button];
    [buttons addObject:space];
    [tools setItems:buttons];
    UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc] initWithCustomView:tools] autorelease];
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(id)initWithSubMenuType:(RCSubMenuType)type
{
    if (type != RCSubMenuSetting) {
        self = [super initWithStyle:UITableViewStylePlain];
    }else {
        self = [super initWithStyle:UITableViewStyleGrouped];
    }
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];

    if (self) {
        switch (type) {
            case RCSubMenuFavorite:
            {
                NSMutableArray *bookmarksArray = [RCRecordData recordDataWithKey:RCRD_BOOKMARK];
                self.submenuItems = [NSMutableArray arrayWithArray:bookmarksArray];
            }
                break;
            case RCSubMenuHistory:
            {
                NSMutableArray *historyArray = [RCRecordData recordDataWithKey:RCRD_HISTORY];
                self.submenuItems = [NSMutableArray arrayWithArray:historyArray];
                
//                NSData * history = [defaults objectForKey:@"history"];
//                NSMutableArray *historyArray;
//                
//                if (history) {
//                    historyArray = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:history]];
//                }else {
//                    historyArray = [[NSMutableArray alloc] initWithCapacity:1];
//                    [historyArray sortUsingComparator:^NSComparisonResult(BookmarkObject *obj1, BookmarkObject *obj2) {
//                        return  [obj2.date compare:obj1.date];
//                    }];
//                }
//                self.submenuItems = [NSMutableArray arrayWithArray:historyArray];
            }
                break;
            case RCSubMenuMostViewed:
            {
                NSData * history = [defaults objectForKey:@"history"];
                NSMutableArray *historyArray;
                
                if (history) {
                    historyArray = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:history]];
                    [historyArray sortUsingComparator:^NSComparisonResult(BookmarkObject *obj1, BookmarkObject *obj2) {
                        return  [obj2.count compare:obj1.count];
                    }];
                }else {
                    historyArray = [[NSMutableArray alloc] initWithCapacity:1];
                }
                self.submenuItems = [NSMutableArray arrayWithArray:historyArray];
            }
                break;
            case RCSubMenuSetting:                
                
                break;
            default:
                NSLog(@"error");
                break;
        }
            
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
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    BookmarkObject *obj = [self.submenuItems objectAtIndex:indexPath.row];
    NSLog(@"count:%@",obj.count);
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
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
