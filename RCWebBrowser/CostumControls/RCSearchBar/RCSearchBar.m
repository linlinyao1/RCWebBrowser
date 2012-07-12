//
//  RCSearchBar.m
//  RCWebBrowser
//
//  Created by imac on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCSearchBar.h"

@interface RCSearchBar ()
@property (nonatomic,retain) UIButton *stopReloadButton;

@end

@implementation RCSearchBar
@synthesize delegate = _delegate;
@synthesize locationField = _locationField;
@synthesize stopReloadButton = _stopReloadButton;
@synthesize bookMarkButton = _bookMarkButton;
@synthesize bookMarkPop = _bookMarkPop;

-(void)hideViewWithOffset:(CGFloat)offset
{
    self.transform = CGAffineTransformMakeTranslation(0, -offset);
}
-(void)showView
{
    self.transform = CGAffineTransformIdentity;
}


-(void)bookMarkButtonPressed:(UIButton*)sender
{
    
    // Toggle popTipView when a standard UIButton is pressed
    if (nil == self.bookMarkPop) {
        RCBookMarkPop *pop = [[[RCBookMarkPop alloc] initWithFrame:CGRectMake(0, 0, 100, 50)] autorelease];
        pop.delegate = self.delegate;
        self.bookMarkPop = [[[CMPopTipView alloc] initWithCustomView:pop] autorelease];
        self.bookMarkPop.backgroundColor = [UIColor whiteColor];        
        [self.bookMarkPop presentPointingAtView:sender inView:self.superview animated:NO];
    }
    else {
        // Dismiss
        [self.bookMarkPop dismissAnimated:YES];
        self.bookMarkPop = nil;
    }	
}



-(void)loadView
{
    //bookmark button
    UIButton *bookMarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bookMarkButton.frame =CGRectMake(2, 2, 40, 40);
    [bookMarkButton setImage:[UIImage imageNamed:@"add_fov"] forState:UIControlStateNormal];
    [bookMarkButton setImage:[UIImage imageNamed:@"add_fov"] forState:UIControlStateHighlighted];
    [bookMarkButton addTarget:self action:@selector(bookMarkButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:bookMarkButton];
    self.bookMarkButton = bookMarkButton;
    
    // url input
    UITextField *locationField = [[UITextField alloc] initWithFrame:CGRectMake(44,7,266,30)];
//    locationField.delegate = self;
    locationField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    locationField.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];
    locationField.textAlignment = UITextAlignmentLeft;
    locationField.borderStyle = UITextBorderStyleRoundedRect;
    locationField.font = [UIFont fontWithName:@"Helvetica" size:15];
    locationField.autocorrectionType = UITextAutocorrectionTypeNo;
    locationField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    locationField.clearsOnBeginEditing = NO;
    locationField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    locationField.autocorrectionType = UITextAutocorrectionTypeNo;
    locationField.keyboardType = UIKeyboardTypeURL;
    locationField.returnKeyType = UIReturnKeyGo;
    locationField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:locationField];
    self.locationField = locationField;
    [locationField release];
    
    //reload/stop button
    UIButton *stopReloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stopReloadButton.bounds = CGRectMake(0, 0, 26, 30);
    [stopReloadButton setImage:[UIImage imageNamed:@"CIALBrowser.bundle/images/AddressViewReload.png"] forState:UIControlStateNormal];
    [stopReloadButton setImage:[UIImage imageNamed:@"CIALBrowser.bundle/images/AddressViewReload.png"] forState:UIControlStateHighlighted];
    stopReloadButton.showsTouchWhenHighlighted = NO;
    //        [stopReloadButton addTarget:self action:@selector(reloadOrStop:) forControlEvents:UIControlEventTouchUpInside];
    locationField.rightView = stopReloadButton;
    locationField.rightViewMode = UITextFieldViewModeUnlessEditing;
    self.stopReloadButton = stopReloadButton;
    
    
    [self restoreDefaultState];
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadView];
    }
    return self;
}

-(void)awakeFromNib
{
    [self loadView];
}

-(void)restoreDefaultState
{
    self.locationField.text = nil;
    self.locationField.placeholder = @"请输入网址";
    [self.bookMarkButton setEnabled:NO];
}


-(void)loadSearchDisplayView
{
    //Search engine button
    UIButton *searchEngineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchEngineButton.frame =CGRectMake(2, 2, 40, 40);
    [searchEngineButton setImage:[UIImage imageNamed:@"add_fov"] forState:UIControlStateNormal];
    [searchEngineButton setImage:[UIImage imageNamed:@"add_fov"] forState:UIControlStateHighlighted];
    [self addSubview:searchEngineButton];
//    self.searchEngineButton = searchEngineButton;
    
    // url input
    UITextField *locationField = [[UITextField alloc] initWithFrame:CGRectMake(44,7,266,30)];
    //    locationField.delegate = self;
    locationField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    locationField.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];
    locationField.textAlignment = UITextAlignmentLeft;
    locationField.borderStyle = UITextBorderStyleRoundedRect;
    locationField.font = [UIFont fontWithName:@"Helvetica" size:15];
    locationField.autocorrectionType = UITextAutocorrectionTypeNo;
    locationField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    locationField.clearsOnBeginEditing = NO;
    locationField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    locationField.autocorrectionType = UITextAutocorrectionTypeNo;
    locationField.keyboardType = UIKeyboardTypeURL;
    locationField.returnKeyType = UIReturnKeyGo;
    locationField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:locationField];
    self.locationField = locationField;
    [locationField release];
}
-(id)initForSearchDisplayWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSearchDisplayView];
    }
    return self;
}



@end
