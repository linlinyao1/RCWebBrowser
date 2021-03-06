//
//  RCAppDelegate.m
//  RCWebBrowser
//
//  Created by imac on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCAppDelegate.h"

#import "RCViewController.h"
#import "PPRevealSideViewController.h"
#import "MobClick.h"

@implementation RCAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    RCViewController *RCVC = [[RCViewController alloc] initWithNibName:@"RCViewController" bundle:nil];
    self.viewController = RCVC;
    [RCVC release];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    PPRevealSideViewController *revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:self.viewController];
    
    revealSideViewController.panInteractionsWhenClosed = PPRevealSideInteractionNone|PPRevealSideInteractionNavigationBar | PPRevealSideInteractionContentView;
    revealSideViewController.delegate = self.viewController;
    
//    [nav setNavigationBarHidden:YES];
    self.window.rootViewController = revealSideViewController;//self.viewController;
    [revealSideViewController release];
    [self.window makeKeyAndVisible];
    
    
    [MobClick startWithAppkey:@"501a19ab5270156736000014" reportPolicy:REALTIME channelId:nil];
    [MobClick checkUpdate];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
