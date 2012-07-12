//
//  RCViewController.m
//  RCWebBrowser
//
//  Created by imac on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCViewController.h"
#import "RCFastLinkView.h"
#import "RCMenuViewController.h"
#import "CMPopTipView.h"
#import "RCBookMarkPop.h"
#import "RCSearchResultViewController.h"
#import "RCNavigationBar.h"



@interface RCViewController ()<UITextFieldDelegate,RCTabViewDelegate,UIWebViewDelegate,RCBookMarkPopDelegate>
@property (nonatomic,retain) NSMutableArray *openedWebs; //arrary of UIWebView, corresponding to tabs
@property (nonatomic,retain) CMPopTipView *bookMarkPop;

-(void)updateBackForwordState:(RCWebView*)web;
@end

@implementation RCViewController
@synthesize tabView = _tabView;
@synthesize searchBar = _searchBar;
@synthesize broswerView = _broswerView;
@synthesize bottomToolBar = _bottomToolBar;
@synthesize openedWebs = _openedWebs;
@synthesize bookMarkPop = _bookMarkPop;

-(NSMutableArray *)openedWebs
{
    if (!_openedWebs) {
        RCWebView *web = [[[RCWebView alloc] initWithFrame:self.broswerView.bounds] autorelease];
        web.delegate = self;
        _openedWebs = [[NSMutableArray alloc] initWithObjects:web, nil];
    }
    return _openedWebs;
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([self.openedWebs count] == 1) {
        [self.tabView.tabTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self didSelectedTabAtIndex:0];
    }
    [self updateBackForwordState:[self.openedWebs objectAtIndex:[self.tabView.tabTable indexPathForSelectedRow].row]];
    

    
}
- (void)viewDidLoad
{
    [super viewDidLoad];    
    self.searchBar.locationField.delegate = self;
    
//    [self.searchBar.bookMarkButton addTarget:self action:@selector(bookMarkButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    [self.bottomToolBar.backButtonItem setTarget:self];
//    [self.bottomToolBar.backButtonItem setAction:@selector(goBack:)];
//    
//    [self.bottomToolBar.forwardButtonItem setTarget:self];
//    [self.bottomToolBar.forwardButtonItem setAction:@selector(goForward:)];
//    
//    [self.bottomToolBar.menuButtonItem setTarget:self];
//    [self.bottomToolBar.menuButtonItem setAction:@selector(goMenu:)];
//    
//    [self.bottomToolBar.fullScreenButtonItem setTarget:self];
//    [self.bottomToolBar.fullScreenButtonItem setAction:@selector(goFullScreen:)];

    
//    [self.revealSideViewController changeOffset:60
//                                   forDirection:PPRevealSideDirectionLeft];
//    RCNavigationBar* navBar = [[RCNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 88)];
//    [self.navigationController.navigationBar addSubview:self.tabView];
//    [self.navigationController.navigationBar addSubview:self.searchBar];
//    self.navigationController.navigationBar.frame = CGRectMake(0, 0, 320, 88);
}

- (void)viewDidUnload
{
    [self setTabView:nil];
    [self setBroswerView:nil];
    [self setBottomToolBar:nil];
    [self setSearchBar:nil];
    for (UIWebView *web in self.openedWebs) {
        [web stopLoading];
        web.delegate = nil;
    }
    self.openedWebs = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [_tabView release];
    [_broswerView release];
    [_bottomToolBar release];
    [_searchBar release];
    [_openedWebs release];
    [super dealloc];
}

#pragma mark - Search Bar


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSURL *url = [NSURL URLWithString:textField.text];
    // if user didn't enter "http", add it the the url
    if (!url.scheme.length) {
        url = [NSURL URLWithString:[@"http://" stringByAppendingString:textField.text]];
    }
    NSLog(@"last : %@",[url lastPathComponent]);
    textField.text = [url absoluteString];

    NSInteger index = [self.tabView.tabTable indexPathForSelectedRow].row;
    RCWebView *web = [self.openedWebs objectAtIndex:index];
    
    if (web.isDefaultPage) {
        [web turnOffDefaultPage];
    }

    [web loadRequest:[NSURLRequest requestWithURL:url]];
    [self.broswerView addSubview:web];
    
    [textField resignFirstResponder];
    
    [self updateBackForwordState:web];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    RCSearchResultViewController *aVC = [[RCSearchResultViewController alloc] initWithStyle:UITableViewStylePlain];
    [self presentModalViewController:aVC animated:YES];
    return NO;
}
//-(void)bookMarkButtonPressed:(UIButton*)sender
//{
//
//    // Toggle popTipView when a standard UIButton is pressed
//    if (nil == self.bookMarkPop) {
//        RCBookMarkPop *testView = [[[RCBookMarkPop alloc] initWithFrame:CGRectMake(0, 0, 100, 50)] autorelease];
////        testView.backgroundColor = [UIColor whiteColor];
//        self.bookMarkPop = [[[CMPopTipView alloc] initWithCustomView:testView] autorelease];
//        
////        [self.bookMarkPop setDisableTapToDismiss:YES];
//        self.bookMarkPop.delegate = self;
//        [self.bookMarkPop presentPointingAtView:sender inView:self.view animated:NO];
//    }
//    else {
//        // Dismiss
//        [self.bookMarkPop dismissAnimated:YES];
//        self.bookMarkPop = nil;
//    }	
//    
//}
-(BookmarkObject *)currentWebInfo
{
    NSIndexPath *index = [self.tabView.tabTable indexPathForSelectedRow];
    
    NSString *name = [self.tabView.tabTable cellForRowAtIndexPath:index].textLabel.text;
    NSLog(@"cell name:%@",name);
    NSURL *url = ((UIWebView*)[self.openedWebs objectAtIndex:index.row]).request.URL;
    
    BookmarkObject *object = [[BookmarkObject alloc] initWithName:name andURL:url];
    return object;
}

//-(void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
//{
//    self.bookMarkPop = nil;
//}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.searchBar.bookMarkPop) {
        [self.searchBar.bookMarkPop dismissAnimated:YES];
        self.searchBar.bookMarkPop = nil;
    }
}


#pragma mark - Bottom Bar
-(void)backButtonPressed
{
    NSIndexPath *index = [self.tabView.tabTable indexPathForSelectedRow];
    RCWebView *web = [self.openedWebs objectAtIndex:index.row];
    
    [web goBack];
    
    [self updateBackForwordState:web];
    
    //    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateLocationField) object:nil];
    //    [self performSelector:@selector(updateLocationField) withObject:nil afterDelay:1.];
    
}
-(void)forwardButtonPressed
{
    NSIndexPath *index = [self.tabView.tabTable indexPathForSelectedRow];
    RCWebView *web = [self.openedWebs objectAtIndex:index.row];
    
    [web goForward];
    
    [self updateBackForwordState:web];    
}
-(void)menuButtonPressed
{
    RCMenuViewController *menuVC = [[RCMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:menuVC];
    [nav setNavigationBarHidden:YES];
    [self.revealSideViewController pushViewController:nav onDirection:PPRevealSideDirectionLeft withOffset:60 animated:YES];    
}
-(void)homeButtonPressed
{
    
}
-(void)fullScreenButtonPressed:(BOOL)hideOrNot
{
    NSIndexPath *index = [self.tabView.tabTable indexPathForSelectedRow];
    RCWebView *web = [self.openedWebs objectAtIndex:index.row];
    [self.bottomToolBar preHideBar:!web.isDefaultPage];
    
    [UIView animateWithDuration:.5
                     animations:^{                         
                         if (hideOrNot) {
                             [self.bottomToolBar hideBar];
                             if (!web.isDefaultPage) {
                                 [self.tabView hideViewWithOffset:self.tabView.frame.size.height];
                                 [self.searchBar hideViewWithOffset:self.tabView.frame.size.height+self.searchBar.frame.size.height];
                                 self.broswerView.transform = CGAffineTransformMakeTranslation(0, -self.tabView.frame.size.height-self.searchBar.frame.size.height);
                                 self.broswerView.frame = CGRectMake(self.broswerView.frame.origin.x,
                                                                     self.broswerView.frame.origin.y,
                                                                     self.broswerView.frame.size.width,
                                                                     480);
                                 web.frame = self.broswerView.bounds;
                             }

                             //hide nav
                             //shorten web size
                         }else {
                             [self.bottomToolBar showBar];
                             [self.tabView showView];
                             [self.searchBar showView];
                             self.broswerView.transform = CGAffineTransformIdentity;
                             self.broswerView.frame = CGRectMake(self.broswerView.frame.origin.x,
                                                                 self.broswerView.frame.origin.y,
                                                                 self.broswerView.frame.size.width,
                                                                 328);
                             web.frame = self.broswerView.bounds;

                             //show nav
                             //enhance web size
                         }                         
                         
                         
                         
                     }completion:^(BOOL success){
                         
                     }];

}

-(void)updateBackForwordState:(RCWebView *)web
{
    
    [self.bottomToolBar enableBackOrNot:[web canGoBack]];
    [self.bottomToolBar enableForwardOrNot:[web canGoForward]];
//    if ([web canGoBack]) {
//        self.bottomToolBar.backButtonItem.enabled = YES;
//    }else {
//        self.bottomToolBar.backButtonItem.enabled = NO;
//    }
//    
//    if ([web canGoForward]) {
//        self.bottomToolBar.forwardButtonItem.enabled = YES;
//    }else {
//        self.bottomToolBar.forwardButtonItem.enabled = NO;
//    }
//    [self.tabView.tabTable reloadData];
    
    if (web.isDefaultPage) {
        [self.searchBar restoreDefaultState];
    }else {
        [self.searchBar.bookMarkButton setEnabled:YES];
    }
}





//- (void)goBack:(id) sender {
////    NSIndexPath *index = [self.tabView.tabTable indexPathForSelectedRow];
////    RCWebView *web = [self.openedWebs objectAtIndex:index.row];
////    
////    [web goBack];
////    
////    [self updateBackForwordState:web];
//    
////    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateLocationField) object:nil];
////    [self performSelector:@selector(updateLocationField) withObject:nil afterDelay:1.];
//}

//- (void)goForward:(id) sender {
//    NSIndexPath *index = [self.tabView.tabTable indexPathForSelectedRow];
//    RCWebView *web = [self.openedWebs objectAtIndex:index.row];
//    
//    [web goForward];
//
//    [self updateBackForwordState:web];
//
////    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateLocationField) object:nil];
////    [self performSelector:@selector(updateLocationField) withObject:nil afterDelay:1.];
//}

//- (void)goMenu:(id) sender {
////    RCMenuViewController *menuVC = [[RCMenuViewController alloc] initWithStyle:UITableViewStylePlain];
////    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:menuVC];
////    [nav setNavigationBarHidden:YES];
////    [self.revealSideViewController pushViewController:nav onDirection:PPRevealSideDirectionLeft withOffset:60 animated:YES];
//}

//-(void)goFullScreen:(id)sender{
//  [UIView animateWithDuration:.5
//                   animations:^{
//                       self.bottomToolBar.transform = CGAffineTransformMakeTranslation(320, 0);
//                   }completion:^(BOOL success){
//                       
//                   }];
//}

#pragma mark - UIWebViewDelegate && web revelent stuff
-(void)loadURLWithCurrentTab:(NSURL *)url
{
    NSIndexPath *index = [self.tabView.tabTable indexPathForSelectedRow];
    RCWebView* web = [self.openedWebs objectAtIndex:index.row];
    
    self.searchBar.locationField.text = [url absoluteString];
    
    if (web.isDefaultPage) {
        [web turnOffDefaultPage];
    }
    
    [web loadRequest:[NSURLRequest requestWithURL:url]];
    [self.broswerView addSubview:web];
    [web loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)addToHistory:(BookmarkObject*)record
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSData * bookmarks = [defaults objectForKey:@"history"];
    NSMutableArray *bookmarksArray;
    
    if (bookmarks) {
        bookmarksArray = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:bookmarks]];
    } else {
        bookmarksArray = [[NSMutableArray alloc] initWithCapacity:1];        
    } 
    
    BOOL saveURL = YES;
    // Check that the URL is not already in the bookmark list
    for (BookmarkObject * bookmark in bookmarksArray) {
        if ([bookmark.url.absoluteString isEqual:record.url.absoluteString]) {
            saveURL = NO;
            break;
        }
    }
    
    // Add the new URL in the list
    if (saveURL) {
        [bookmarksArray addObject:record];
    }
    
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:bookmarksArray] forKey:@"history"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.searchBar.locationField.text = webView.request.URL.absoluteString;
    NSIndexPath *index = [self.tabView.tabTable indexPathForSelectedRow];
    [self.tabView.tabTable reloadData];
    [self.tabView.tabTable selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    BookmarkObject *record = [[[BookmarkObject alloc] initWithName:[webView stringByEvaluatingJavaScriptFromString:@"document.title"] andURL:webView.request.URL.absoluteURL] autorelease];
    [self addToHistory:record];
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"start url: %@",webView.request.URL);
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (![request.URL.absoluteString isEqualToString:@"about:blank"]) {
        self.searchBar.locationField.text = request.URL.absoluteString;
    }
//    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
//       NSString *string =  [webView stringByEvaluatingJavaScriptFromString:@"window.open = function (open) { return function  (url, name, features) { window.location.href = url; return window; }; } (window.open);"];
//        NSLog(@"string : %@",string);
//    }
    return YES;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if([error code] == NSURLErrorCancelled) return; 
    NSLog(@"fail to load, error: %@",error);
}

#pragma mark - RCTabViewDelegate

-(NSInteger)numberOfTabs
{
    return [self.openedWebs count];
}

-(NSString *)titleForTabAtIndex:(NSInteger)index
{
    RCWebView *web = [self.openedWebs objectAtIndex:index];
    if (web.isDefaultPage) {
        return @"新标签页";
    }
    NSString *title = [web stringByEvaluatingJavaScriptFromString:@"document.title"];
    return title;
}

-(void)didSelectedTabAtIndex:(NSInteger)index
{
    RCWebView *web = [self.openedWebs objectAtIndex:index];
    if (web.isDefaultPage) {
        [web turnOnDefaultPage];
    }
    [self.broswerView addSubview:web];

    [self updateBackForwordState:web];
}

-(void)didDeselectedTabAtIndex:(NSInteger)index
{
    UIView *view = [self.openedWebs objectAtIndex:index];
    [view removeFromSuperview];
    
    
}

-(BOOL)tabShouldAdd
{
    RCWebView *web = [[[RCWebView alloc] initWithFrame:self.broswerView.bounds] autorelease];
    web.delegate = self;
    [self.openedWebs addObject:web];
    [self updateBackForwordState:web];
    return YES;
}

-(BOOL)tabShouldCloseAtIndex:(NSInteger)index
{
    [self.openedWebs removeObjectAtIndex:index];
    
    return YES;
}

@end
