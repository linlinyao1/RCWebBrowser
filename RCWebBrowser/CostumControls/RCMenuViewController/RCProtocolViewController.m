//
//  RCProtocolViewController.m
//  RCWebBrowser
//
//  Created by imac on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCProtocolViewController.h"
#import "UIBarButtonItem+BackStyle.h"

@interface RCProtocolViewController ()

@end

@implementation RCProtocolViewController
@synthesize textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:RC_IMAGE(@"MenuBG")];    
    UIBarButtonItem *newBackButton = [UIBarButtonItem barButtonWithCustomImage:RC_IMAGE(@"MenuItemBack@2x") HilightImage:nil Title:@"返回" Target:self Action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = newBackButton;
}

- (void)viewDidUnload
{
    [self setTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [textView release];
    [super dealloc];
}
@end
