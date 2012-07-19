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


@interface RCViewController ()<UITextFieldDelegate,RCTabViewDelegate,UIWebViewDelegate,RCBookMarkPopDelegate,RCSearchBarDelegate>
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



- (void) preloadLeft {
    RCMenuViewController *menuVC = [[RCMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:menuVC];
    [menuVC release];
    [nav setNavigationBarHidden:YES];  
    
    [self.revealSideViewController preloadViewController:nav
                                                 forSide:PPRevealSideDirectionLeft
                                              withOffset:60];
    [nav release];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([self.openedWebs count] == 1) {
        [self.tabView.tabTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self didSelectedTabAtIndex:0];
    }
    [self updateBackForwordState:[self.openedWebs objectAtIndex:[self.tabView.tabTable indexPathForSelectedRow].row]];    
}

-(void)viewDidAppear:(BOOL)animated
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(preloadLeft) object:nil];
    [self performSelector:@selector(preloadLeft) withObject:nil afterDelay:0.3];
}

- (void)viewDidLoad
{
    [super viewDidLoad];  
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

#pragma mark - PPRevealSideViewControllerDelegate

- (PPRevealSideDirection)pprevealSideViewController:(PPRevealSideViewController*)controller directionsAllowedForPanningOnView:(UIView*)view {
    
//    if ([view isKindOfClass:NSClassFromString(@"UIWebBrowserView")]) return PPRevealSideDirectionLeft | PPRevealSideDirectionRight;
    
//    return PPRevealSideDirectionLeft | PPRevealSideDirectionRight | PPRevealSideDirectionTop | PPRevealSideDirectionBottom;
    return PPRevealSideDirectionLeft;
}
//- (BOOL) pprevealSideViewController:(PPRevealSideViewController *)controller shouldDeactivateGesture:(UIGestureRecognizer*)gesture forView:(UIView*)view;
//{
////    NSIndexPath *index = [self.tabView.tabTable indexPathForSelectedRow];
////    RCWebView *web = [self.openedWebs objectAtIndex:index.row];
////    if (web.isDefaultPage) {
////        <#statements#>
////    }
//    return YES;
//}
//- (UIViewController*) controllerForGesturesOnPPRevealSideViewController:(PPRevealSideViewController*)controller
//{
//    return self;
//}
- (void) pprevealSideViewController:(PPRevealSideViewController *)controller willPushController:(UIViewController *)pushedController
{
    
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
//                                 self.broswerView.transform = CGAffineTransformMakeTranslation(0, -self.tabView.frame.size.height-self.searchBar.frame.size.height);
                                 self.broswerView.frame = CGRectMake(0,
                                                                     0,
                                                                     self.broswerView.frame.size.width,
                                                                     460);
                                 web.frame = self.broswerView.bounds;
                             }
                             //hide nav
                             //shorten web size
                         }else {
                             [self.bottomToolBar showBar];
                             [self.tabView showView];
                             [self.searchBar showView];
//                             self.broswerView.transform = CGAffineTransformIdentity;
                             self.broswerView.frame = CGRectMake(0,
                                                                 88,
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
    
    UIImage *image = nil;
    if (web.loading) {
        image = [UIImage imageNamed:@"CIALBrowser.bundle/images/AddressViewStop.png"];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    } else {
        image = [UIImage imageNamed:@"CIALBrowser.bundle/images/AddressViewReload.png"];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    [self.searchBar.stopReloadButton setImage:image forState:UIControlStateNormal];
    
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
//    [web loadRequest:[NSURLRequest requestWithURL:url]];
    
    
}


-(void)addToHistory:(BookmarkObject*)record
{
    NSMutableArray *historyArray = [RCRecordData recordDataWithKey:RCRD_BOOKMARK];    
    BOOL saveURL = YES;
    // Check that the URL is not already in the bookmark list
    for (BookmarkObject * bookmark in historyArray) {
        if ([bookmark.url.absoluteString isEqual:record.url.absoluteString]) {
            bookmark.date = [NSDate date];
            bookmark.count = [NSNumber numberWithInt: bookmark.count.intValue+1];
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
            flObj.icon = [UIView captureView:[self currentWeb]];
            flObj.date = [NSDate date];
            [RCRecordData updateRecord:fastlinksArray ForKey:RCRD_FASTLINK];
            break;
        }
    }


}



-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"finished url:%@",webView.request.URL);
    self.searchBar.locationField.text = webView.request.URL.absoluteString;
    NSIndexPath *index = [self.tabView.tabTable indexPathForSelectedRow];
    [self.tabView.tabTable reloadData];
    [self.tabView.tabTable selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    BookmarkObject *record = [[[BookmarkObject alloc] initWithName:[webView stringByEvaluatingJavaScriptFromString:@"document.title"] andURL:webView.request.URL.absoluteURL] autorelease];
    [self addToHistory:record];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateBackForwordState:) object:webView];
    [self performSelector:@selector(updateBackForwordState:) withObject:webView afterDelay:1.];
//    [self updateBackForwordState:(RCWebView*)webView];
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"start url: %@",webView.request.URL);
    [self updateBackForwordState:(RCWebView*)webView];
//    [self.searchBar setLoadingProgress:0.15];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"request url:%@",request.URL);
    NSLog(@"main request url :%@",request.mainDocumentURL);
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
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateBackForwordState:) object:webView];
    [self performSelector:@selector(updateBackForwordState:) withObject:webView afterDelay:1.];
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

-(UIImage *)faviconForTabAtIndex:(NSInteger)index
{
    RCWebView *web = [self.openedWebs objectAtIndex:index];
    if (web.isDefaultPage) {
        return nil;
    }
    NSURL *url = [[[NSURL alloc] initWithScheme:[web.request.URL scheme] host:[web.request.URL host] path:@"/favicon.ico"] autorelease];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data) {
        UIImage *image = [UIImage imageWithData:data];
        return image;
    }else {
        return nil;
    }
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


#pragma mark - RCSearchBar delegate
-(void)searchModeOn
{
    self.view.transform = CGAffineTransformMakeTranslation(0, -44);
}
-(void)searchModeOff
{
    self.view.transform = CGAffineTransformIdentity;
}

-(void)reloadOrStop:(UIButton *)sender
{
    UIWebView *webView = [self currentWeb];
    if (webView.loading)
        [webView stopLoading];
    else [webView reload];    
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

//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    RCSearchResultViewController *aVC = [[RCSearchResultViewController alloc] initWithStyle:UITableViewStylePlain];
//    [self presentModalViewController:aVC animated:YES];
//    return NO;
//}
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

-(void)searchCompleteWithUrl:(NSURL *)url
{
    [self loadURLWithCurrentTab:url];
}
-(BookmarkObject *)currentWebInfo
{
    NSIndexPath *index = [self.tabView.tabTable indexPathForSelectedRow];
    
    NSString *name = [self.tabView.tabTable cellForRowAtIndexPath:index].textLabel.text;
    NSURL *url = ((UIWebView*)[self.openedWebs objectAtIndex:index.row]).request.URL;
    
    BookmarkObject *object = [[[BookmarkObject alloc] initWithName:name andURL:url] autorelease];
    return object;
}
-(UIWebView *)currentWeb
{
    NSIndexPath *index = [self.tabView.tabTable indexPathForSelectedRow];
    return [self.openedWebs objectAtIndex:index.row];
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
