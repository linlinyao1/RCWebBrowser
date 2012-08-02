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
#import "RCRecordData.h"
#import "RCFastLinkObject.h"
#import "UIView+ScreenShot.h"
#import "SCNavigationBar.h"
#import "EGOCache.h"

@interface RCViewController ()<UITextFieldDelegate,RCTabViewDelegate,UIWebViewDelegate,RCBookMarkPopDelegate,RCSearchBarDelegate,RCFastLinkViewDelegate,UIAlertViewDelegate>
@property (nonatomic,retain) NSMutableArray *openedWebs; //arrary of UIWebView, corresponding to tabs
@property (nonatomic,retain) CMPopTipView *bookMarkPop;
@property (nonatomic) BOOL isSliding;
@property (nonatomic,retain) UINavigationController *menuViewController;
-(void)updateBackForwordState:(RCWebView*)web;
@end

@implementation RCViewController
@synthesize tabView = _tabView;
@synthesize searchBar = _searchBar;
@synthesize broswerView = _broswerView;
@synthesize bottomToolBar = _bottomToolBar;
@synthesize openedWebs = _openedWebs;
@synthesize bookMarkPop = _bookMarkPop;
@synthesize isSliding = _isSliding;
@synthesize menuViewController = _menuViewController;

-(NSMutableArray *)openedWebs
{
    if (!_openedWebs) {
        RCWebView *web = [[[RCWebView alloc] initWithFrame:self.broswerView.bounds] autorelease];
        web.delegate = self;
        _openedWebs = [[NSMutableArray alloc] initWithObjects:web, nil];
    }
    return _openedWebs;
}



- (void) preloadLeft {
    RCMenuViewController *menuVC = [[RCMenuViewController alloc] initWithStyle:UITableViewStylePlain];
//    UINavigationController *nav = [SCNavigationBar customizedNavigationControllerWithNomalImage:RC_IMAGE(@"searchBarBG") AndLandLandscapeImage:nil];
//    [nav setViewControllers:[NSArray arrayWithObject:menuVC]];

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:menuVC];
    nav.navigationBar.barStyle = UIBarStyleBlack;
    [menuVC release];
//    [nav setNavigationBarHidden:YES];  
    [self.revealSideViewController preloadViewController:nav
                                                 forSide:PPRevealSideDirectionLeft
                                              withOffset:60];
    self.menuViewController = nav;
    [nav release];
}

-(void)openLink:(NSURL *)URL
{
    if (URL) {
        [self loadURLWithCurrentTab:URL];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    if ([self.openedWebs count] == 1) {
        [self.tabView.tabTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self didSelectedTabAtIndex:0];
    }
    [self updateBackForwordState:[self.openedWebs objectAtIndex:[self.tabView.tabTable indexPathForSelectedRow].row]];
    [[RCFastLinkView defaultPage] refresh];
}

-(void)viewDidAppear:(BOOL)animated
{
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(preloadLeft) object:nil];
//    [self performSelector:@selector(preloadLeft) withObject:nil afterDelay:0.3];
    [self performSelector:@selector(preloadLeft)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];  
    [RCFastLinkView defaultPage].delegate = self;
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_tabView release];
    [_broswerView release];
    [_bottomToolBar release];
    [_searchBar release];
    [_openedWebs release];
    [super dealloc];
}

#pragma mark - PPRevealSideViewControllerDelegate

- (PPRevealSideDirection)pprevealSideViewController:(PPRevealSideViewController*)controller directionsAllowedForPanningOnView:(UIView*)view {
    
//    if ([view isKindOfClass:NSClassFromString(@"UIWebBrowserView")]) return PPRevealSideDirectionLeft | PPRevealSideDirectionRight;
    
//    return PPRevealSideDirectionLeft | PPRevealSideDirectionRight | PPRevealSideDirectionTop | PPRevealSideDirectionBottom;
    return PPRevealSideDirectionLeft;
}
- (BOOL) pprevealSideViewController:(PPRevealSideViewController *)controller shouldDeactivateGesture:(UIGestureRecognizer*)gesture forView:(UIView*)view;
{
    //not a good place to detect touches, but currently no other way to do
//    NSLog(@"broswerView: %@",NSStringFromCGRect(self.broswerView.bounds));
//    NSLog(@"view: %@",NSStringFromCGRect(view.bounds));
//    if (CGRectEqualToRect(self.searchBar.bounds, view.bounds) || CGRectEqualToRect(self.tabView.bounds, view.bounds) || CGRectEqualToRect(self.bottomToolBar.bounds, view.bounds)) {
////    if (!CGRectContainsRect(self.broswerView.frame, [view convertRect:view.frame toView:self.view]) ) {
//        [[RCFastLinkView defaultPage] setEding:NO];
//    }
    ///////////////////////////////////////////////////////////////////////
    
    if (self.isSliding) {
        return NO;
    }
    
    BOOL result = YES;

    NSIndexPath *index = [self.tabView.tabTable indexPathForSelectedRow];
    RCWebView *web = [self.openedWebs objectAtIndex:index.row];
    if ([web canBeSlided]) {
        result = NO;
    }
    if (CGRectContainsRect(self.tabView.frame, view.frame)) {
        result = YES;
    }    
    
    return result;
}

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller willPushController:(UIViewController *)pushedController
{
    NSLog(@"will push");
    self.searchBar.userInteractionEnabled = NO;
    self.isSliding = YES;
    self.broswerView.userInteractionEnabled = NO;
    self.bottomToolBar.userInteractionEnabled = NO;
}

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller willPopToController:(UIViewController *)centerController
{
    NSLog(@"will pop");
    self.searchBar.userInteractionEnabled = YES;
    self.isSliding = NO;
    self.broswerView.userInteractionEnabled = YES;
    self.bottomToolBar.userInteractionEnabled = YES;
}


#pragma mark - Bottom Bar
-(void)backButtonPressed
{
    NSIndexPath *index = [self.tabView.tabTable indexPathForSelectedRow];
    RCWebView *web = [self.openedWebs objectAtIndex:index.row];
    
    [web goBack];
    if (web.isDefaultPage) {
        [self fullScreenButtonPressed:NO];
        [self.tabView resotreCurrentTab];
    }
//    [self updateBackForwordState:web];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateBackForwordState:) object:web];
    [self performSelector:@selector(updateBackForwordState:) withObject:web afterDelay:.1];
}
-(void)forwardButtonPressed
{
    NSIndexPath *index = [self.tabView.tabTable indexPathForSelectedRow];
    RCWebView *web = [self.openedWebs objectAtIndex:index.row];
    
    [web goForward];
    
//    [self updateBackForwordState:web];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateBackForwordState:) object:web];
    [self performSelector:@selector(updateBackForwordState:) withObject:web afterDelay:.1];
}
-(void)menuButtonPressed
{
//    RCMenuViewController *menuVC = [[RCMenuViewController alloc] initWithStyle:UITableViewStylePlain];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:menuVC];
//    [nav setNavigationBarHidden:YES];
    [self.revealSideViewController pushViewController:self.menuViewController onDirection:PPRevealSideDirectionLeft withOffset:60 animated:YES];    
}
-(void)homeButtonPressed
{
    RCWebView *web = (RCWebView *)[self currentWeb];
    if (web.isDefaultPage) {
        [[RCFastLinkView defaultPage] scrollPage];
    }else {
        [web turnOnDefaultPage];
        
        
        [self.bottomToolBar enableBackOrNot:NO];
        [self.bottomToolBar enableForwardOrNot:[web canGoForward]];
        [self.searchBar stopLoadProgress];
        [self.tabView resotreCurrentTab];
    }
}
-(void)fullScreenButtonPressed:(BOOL)hideOrNot
{
    NSIndexPath *index = [self.tabView.tabTable indexPathForSelectedRow];
    RCWebView *web = [self.openedWebs objectAtIndex:index.row];
    if (web.isLoading) {
        return;
    }
    
    [self.bottomToolBar preHideBar:(!web.isDefaultPage)];// && hideOrNot
    
    if (hideOrNot && !web.isDefaultPage) {
        self.broswerView.frame = CGRectMake(0,
                                            self.broswerView.frame.origin.y,
                                            self.broswerView.frame.size.width,
                                            460);
        web.frame = self.broswerView.bounds;
    }
    
    [UIView animateWithDuration:.2
                     animations:^{                         
                         if (hideOrNot) {
                             [self.bottomToolBar hideBar];
                             if (!web.isDefaultPage) {
                                 [self.tabView hideViewWithOffset:self.tabView.frame.size.height];
                                 [self.searchBar hideViewWithOffset:self.tabView.frame.size.height+self.searchBar.frame.size.height];
                                 self.broswerView.transform = CGAffineTransformMakeTranslation(0, -self.tabView.frame.size.height-self.searchBar.frame.size.height);
//                                 self.broswerView.frame = CGRectMake(0,
//                                                                     0,
//                                                                     self.broswerView.frame.size.width,
//                                                                     460);
//                                 web.frame = self.broswerView.bounds;
                             }
                             //hide nav
                             //shorten web size
                         }else {
                             [self.bottomToolBar showBar];
                             [self.tabView showView];
                             [self.searchBar showView];
                             self.broswerView.transform = CGAffineTransformIdentity;
//                             self.broswerView.frame = CGRectMake(0,
//                                                                 82,
//                                                                 self.broswerView.frame.size.width,
//                                                                 332);
//                             web.frame = self.broswerView.bounds;
                             //show nav
                             //enhance web size
                         }                                                  
                     }completion:^(BOOL success){
                         if (!hideOrNot) {
                             self.broswerView.frame = CGRectMake(0,
                                                                 82,
                                                                 self.broswerView.frame.size.width,
                                                                 332);
                             web.frame = self.broswerView.bounds;
                         }
                         
                     }];

}

-(void)updateBackForwordState:(RCWebView *)web
{
    
//    UIImage *image = nil;
    if (web.loading) {
        [self.searchBar.stopReloadButton setImage:RC_IMAGE(@"search_stop_nomal") forState:UIControlStateNormal];
        [self.searchBar.stopReloadButton setImage:RC_IMAGE(@"search_stop_pressed") forState:UIControlStateHighlighted];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self.searchBar startLoadingProgress];
    } else {
        [self.searchBar.stopReloadButton setImage:RC_IMAGE(@"search_reload_nomal") forState:UIControlStateNormal];
        [self.searchBar.stopReloadButton setImage:RC_IMAGE(@"search_reload_pressed") forState:UIControlStateHighlighted];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.searchBar stopLoadProgress];
    }
    
    if (web.request.URL.absoluteString.length) {
        self.searchBar.locationField.text = web.request.URL.absoluteString;
    }
    
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
        self.searchBar.locationField.rightView.userInteractionEnabled = NO;
    }else {
        self.searchBar.locationField.rightView.userInteractionEnabled = YES;
        [self.searchBar.bookMarkButton setEnabled:YES];

        NSMutableArray *fastlinksArray = [RCRecordData recordDataWithKey:RCRD_FASTLINK];
        BookmarkObject *curObj = [self currentWebInfo];
        for (RCFastLinkObject * fastlink in fastlinksArray) {
            if ([fastlink.url.absoluteString isEqual:curObj.url.absoluteString]) {
                [self.searchBar.bookMarkButton setImage:RC_IMAGE(@"search_addfav_hilite") forState:UIControlStateNormal];
                return;
            }
        }
        NSMutableArray *bookmarksArray = [RCRecordData recordDataWithKey:RCRD_BOOKMARK];
        for (BookmarkObject * bookmark in bookmarksArray) {
            if ([bookmark.url.absoluteString isEqual:curObj.url.absoluteString]) {
                [self.searchBar.bookMarkButton setImage:RC_IMAGE(@"search_addfav_hilite") forState:UIControlStateNormal];
                return;
            }
        }
        [self.searchBar.bookMarkButton setImage:RC_IMAGE(@"search_addfav_nomal") forState:UIControlStateNormal];
    }
}




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
//    [web loadRequest:[NSURLRequest requestWithURL:url]];
}


-(void)addToHistory:(BookmarkObject*)record
{
    NSMutableArray *historyArray = [RCRecordData recordDataWithKey:RCRD_HISTORY];    
    BOOL saveURL = YES;
//    NSString *recordString = record.url.absoluteString;
//    if ([recordString hasSuffix:@"/"]) {
//        recordString = [recordString substringToIndex:recordString.length-1];
//        record.url = [NSURL URLWithString:recordString];
//    }
    
    // Check that the URL is not already in the history list
    for (BookmarkObject * history in historyArray) {
        if ([history.url.absoluteString isEqual:record.url.absoluteString]) {
            history.date = [NSDate date];
            history.count = [NSNumber numberWithInt: history.count.intValue+1];
            saveURL = NO;
            break;
        }
    }
    // Add the new URL in the list
    if (saveURL) {
        [historyArray addObject:record];
    }
    [RCRecordData updateRecord:historyArray ForKey:RCRD_HISTORY];
    
    
    NSMutableArray *fastlinksArray = [RCRecordData recordDataWithKey:RCRD_FASTLINK]; 
    // Check that the URL is not already in the bookmark list
    for (RCFastLinkObject * flObj in fastlinksArray) {
        if ([flObj.url.absoluteString isEqual:record.url.absoluteString]) {
            if (!flObj.isDefault) {
                flObj.icon = [UIView captureView:[self currentWeb]];
            }
            flObj.date = [NSDate date];
            [RCRecordData updateRecord:fastlinksArray ForKey:RCRD_FASTLINK];
            break;
        }
    }
}



-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"finished url:%@",webView.request.URL);
    NSString *urlString = webView.request.URL.absoluteString;
    if ([urlString hasSuffix:@"/"]) {
        urlString = [urlString substringToIndex:urlString.length-1];
//        record.url = [NSURL URLWithString:recordString];
    }
    
    self.searchBar.locationField.text = urlString;//webView.request.URL.absoluteString;
    [self.tabView resotreCurrentTab];
//    NSIndexPath *index = [self.tabView.tabTable indexPathForSelectedRow];
//    [self.tabView.tabTable reloadData];
//    [self.tabView.tabTable selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
    
//    BookmarkObject *record = [[[BookmarkObject alloc] initWithName:[webView stringByEvaluatingJavaScriptFromString:@"document.title"] andURL:webView.request.URL.absoluteURL] autorelease];
    BookmarkObject *record = [[BookmarkObject alloc] initWithName:[webView stringByEvaluatingJavaScriptFromString:@"document.title"] andURL:[NSURL URLWithString:urlString]];
    [self addToHistory:record];
    [record release];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateBackForwordState:) object:webView];
    [self performSelector:@selector(updateBackForwordState:) withObject:webView afterDelay:.1];
//    [self.searchBar stopLoadProgress];
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"start url: %@",webView.request.URL);
    [self updateBackForwordState:(RCWebView*)webView];
    [self.searchBar startLoadingProgress];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"request : %@",request.URL);
    if (![request.URL.absoluteString isEqualToString:@"about:blank"]) {
        self.searchBar.locationField.text = request.URL.absoluteString;
        if (!self.bottomToolBar.isBarShown && CGAffineTransformIsIdentity(self.tabView.transform)) {
            [self fullScreenButtonPressed:YES];
        }
        
    }
//    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
//       NSString *string =  [webView stringByEvaluatingJavaScriptFromString:@"window.open = function (open) { return function  (url, name, features) { window.location.href = url; return window; }; } (window.open);"];
//        NSLog(@"string : %@",string);
//    }
    return YES;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if([error code] != NSURLErrorCancelled) { 
        NSLog(@"fail to load, error: %@",error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络连接不正常，请检查网络" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateBackForwordState:) object:webView];
    [self performSelector:@selector(updateBackForwordState:) withObject:webView afterDelay:0];
    
}

//#pragma mark - – alertView:clickedButtonAtIndex:
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    NSLog(@"index %d",buttonIndex);
//    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
//}


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

-(UIImage *)faviconForTabAtIndex:(NSInteger)index
{
    return nil; // closed due to network delay
    
    RCWebView *web = [self.openedWebs objectAtIndex:index];
    if (web.isDefaultPage) {
        return nil;
    }
    NSURL *url = [[[NSURL alloc] initWithScheme:[web.request.URL scheme] host:[web.request.URL host] path:@"/favicon.ico"] autorelease];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                UITableViewCell *cell = [self.tabView.tabTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                cell.imageView.image = image;
                [cell.imageView setNeedsDisplay];
            });
        }
    });   
    
    return nil;
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    if (data) {
//        UIImage *image = [UIImage imageWithData:data];
//        return image;
//    }else {
//        return nil;
//    }
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
    if (self.openedWebs.count >=12) {
        UIAlertView *alert = [[UIAlertView  alloc] initWithTitle:nil message:@"已达到最大标签数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return NO;
    }
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


#pragma mark - RCSearchBar delegate
-(void)searchModeOn
{
    self.view.transform = CGAffineTransformMakeTranslation(0, -38);
}
-(void)searchModeOff
{
    self.view.transform = CGAffineTransformIdentity;
}

-(void)reloadOrStop:(UIButton *)sender
{
    UIWebView *webView = [self currentWeb];
    if (webView.loading){
        [webView stopLoading];
        [self.searchBar removePregress];
    }
    else {
        [webView reload]; 
    }   
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateBackForwordState:) object:webView];
//    [self performSelector:@selector(updateBackForwordState:) withObject:webView afterDelay:1.];
}

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



-(void)searchCompleteWithUrl:(NSURL *)url
{
    [self loadURLWithCurrentTab:url];
}
-(BookmarkObject *)currentWebInfo
{
    NSIndexPath *index = [self.tabView.tabTable indexPathForSelectedRow];
    
    NSString *name = [self.tabView.tabTable cellForRowAtIndexPath:index].textLabel.text;
    NSURL *url = ((UIWebView*)[self.openedWebs objectAtIndex:index.row]).request.URL;
    NSString *urlString = url.absoluteString;
    if ([urlString hasSuffix:@"/"]) {
        urlString = [urlString substringToIndex:urlString.length-1];
        url = [NSURL URLWithString:urlString];
    }
    
    BookmarkObject *object = [[[BookmarkObject alloc] initWithName:name andURL:url] autorelease];
    return object;
}
-(UIWebView *)currentWeb
{
    NSIndexPath *index = [self.tabView.tabTable indexPathForSelectedRow];
    return [self.openedWebs objectAtIndex:index.row];
}

-(void)highlightBookMarkButton:(BOOL)isHighlight
{
    if (isHighlight) {
        [self.searchBar.bookMarkButton setImage:RC_IMAGE(@"search_addfav_hilite") forState:UIControlStateNormal];
    }else {
        [self.searchBar.bookMarkButton setImage:RC_IMAGE(@"search_addfav_nomal") forState:UIControlStateNormal];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.searchBar.bookMarkPop) {
        [self.searchBar.bookMarkPop dismissAnimated:YES];
        self.searchBar.bookMarkPop = nil;
    }
    if (self.searchBar.searchEnginePop) {
        [self.searchBar.searchEnginePop dismissAnimated:YES];
        self.searchBar.searchEnginePop = nil;
    }
}

@end
