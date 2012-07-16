////
////  RCSearchResultViewController.m
////  RCWebBrowser
////
////  Created by imac on 12-7-11.
////  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
////
//
//#import "RCSearchResultViewController.h"
//#import "RCSearchResultBar.h"
//#import "RCViewController.h"
//#import "PPRevealSideViewController.h"
////@interface UITableView (RCSearchResultViewController)
////-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
////@end
////
////@implementation UITableView (RCSearchResultViewController)
////
////-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
////{
////    [super touchesBegan:touches withEvent:event];
////}
////
////@end
//
//
//@interface RCSearchResultViewController ()<UITextFieldDelegate>
//@property (nonatomic,retain) NSArray *listContent;			// The master content.
//@property (nonatomic,retain) RCSearchResultBar *searchBar;
//@end
//
//@implementation RCSearchResultViewController
//@synthesize listContent = _listContent;
//@synthesize searchBar = _searchBar;
//
//
//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//        self.searchBar = [[[RCSearchResultBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)] autorelease];
//        self.searchBar.backgroundColor = [UIColor blackColor];
//        self.searchBar.inputField.delegate =self;
//        [self.searchBar.cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return self;
//}
//
////-(void)viewDidlAppear:(BOOL)animated
////{
////    [super viewDidAppear:animated];
////    [self.searchBar.inputField becomeFirstResponder];
////}
////-(void)viewWillAppear:(BOOL)animated
////{
////    [super viewWillAppear:animated];
////    [self.searchBar.inputField becomeFirstResponder];
////}
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//
//    self.listContent = [NSMutableArray arrayWithObjects:
//                        @"1", 
//                        @"2",
//                        @"3",
//                        @"4",
//                        @"5",
//                        @"6",
//                        @"7",
//                        @"8",
//                        @"9",
//                        @"1", 
//                        @"2",
//                        @"3",
//                        @"4",
//                        @"5",
//                        @"6",
//                        @"7",
//                        @"8",nil];
//    // Uncomment the following line to preserve selection between presentations.
//    // self.clearsSelectionOnViewWillAppear = NO;
// 
//    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//}
//
//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
//
//
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    if ([self.searchBar.inputField isFirstResponder]) {
//        [self.searchBar.inputField resignFirstResponder];
//    }
//}
//
//-(void)cancelButtonPressed:(UIButton*)sender
//{
//    if ([self.searchBar.inputField isFirstResponder]) {
//        [self.searchBar.inputField resignFirstResponder];
//    }else {
//        [self dismissModalViewControllerAnimated:YES];
//    }
//}
//#pragma mark - UITextField Delegate
//
//-(RCKeyBoardAccessoryType)checkInputContent:(NSString*)text
//{
//    //check if contain any chinese
//
//    for(int i=0; i< [text length];i++){
//        int a = [text characterAtIndex:i];
//        if( a > 0x4e00 && a < 0x9fff)
//            return RCKeyBoardTypeNone;
//    }
//    
//    NSRange foundObj=[text rangeOfString:@"." options:NSCaseInsensitiveSearch];
//    if(foundObj.length>0) { 
//        return RCkeyBoardTypeSuffix;
//    } else {
//        return RCKeyBoardTypePrefix;
//    }
//}
//
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    RCViewController* viewcontroller = (RCViewController*)self.parentViewController;
//    if ([viewcontroller isKindOfClass:[RCViewController class]]) {
//        NSURL *url = [NSURL URLWithString:textField.text];
//        NSLog(@"scheme : %@",url.scheme);
//        if (!url.scheme.length) {
//            url = [NSURL URLWithString:[@"http://" stringByAppendingString:textField.text]];
//        }
//        
//        [viewcontroller loadURLWithCurrentTab:url];
//    }
//
//    [self dismissModalViewControllerAnimated:YES];
//    
//    return YES;
//}
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSString* newstring = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    self.searchBar.KBAType = [self checkInputContent:newstring];
//    return YES;
//}
//
//#pragma mark - Table view data source
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Return the number of rows in the section.
//    return [self.listContent count];
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//	if (cell == nil)
//	{
//		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//	}
//    cell.textLabel.text = [self.listContent objectAtIndex:indexPath.row];
//
//    return cell;
//}
//
//
//
//
//
//
//#pragma mark - Table view delegate
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
////    [self.searchBar.inputField becomeFirstResponder];
//    return self.searchBar;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 40;   
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([self.searchBar.inputField isFirstResponder]) {
//        [self.searchBar.inputField resignFirstResponder];
//    }
//    // Navigation logic may go here. Create and push another view controller.
//    /*
//     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     [detailViewController release];
//     */
//}
//
//@end
