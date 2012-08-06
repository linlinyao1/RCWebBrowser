//
//  RCToolBar.m
//  RCWebBrowser
//
//  Created by imac on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCToolBar.h"
#import "UMFeedback.h"
#import "MobClick.h"

@interface RCToolBar()

@property (nonatomic,retain) IBOutlet UIView* backView;
@property (nonatomic,retain) IBOutlet UIView* frontView;

@property (nonatomic,retain) IBOutlet UIButton *backButtonItem;
@property (nonatomic,retain) IBOutlet UIButton *backButtonItem2;
@property (nonatomic,retain) IBOutlet UIButton *forwardButtonItem;
@property (nonatomic,retain) IBOutlet UIButton *menuButtonItem;
@property (nonatomic,retain) IBOutlet UIButton *homeButtonItem;
@property (nonatomic,retain) IBOutlet UIButton *suggestionButtonItem;
@property (nonatomic,retain) IBOutlet UIButton *fullScreenButtonItem;
@property (nonatomic,retain) IBOutlet UIButton *fullScreenButtonItem2;


@end

@implementation RCToolBar

@synthesize backButtonItem = _backButtonItem, backButtonItem2 = _backButtonItem2;
@synthesize forwardButtonItem = _forwardButtonItem;
@synthesize menuButtonItem = _menuButtonItem;
@synthesize homeButtonItem = _homeButtonItem;
@synthesize suggestionButtonItem = _suggestionButtonItem;
@synthesize fullScreenButtonItem = _fullScreenButtonItem, fullScreenButtonItem2 = _fullScreenButtonItem2;
@synthesize backView = _backView;
@synthesize frontView = _frontView;
@synthesize delegate = _delegate;
@synthesize isBarShown = _isBarShown;

-(void)enableBackOrNot:(BOOL)enable
{
    [self.backButtonItem setEnabled:enable];
    [self.backButtonItem2 setEnabled:enable];
}
-(void)enableForwardOrNot:(BOOL)enable
{
    [self.forwardButtonItem setEnabled:enable];
}

- (IBAction)suggestionButtonPressed {
    [UMFeedback showFeedback:[[UIApplication sharedApplication] keyWindow].rootViewController withAppkey:@"501a19ab5270156736000014"];
}

- (IBAction)backButtonPressed {
    [self.delegate backButtonPressed];
}

- (IBAction)forwardButtonPressed {
    [self.delegate forwardButtonPressed];
}

- (IBAction)menuButtonPressed {
    [self.delegate menuButtonPressed];
}

- (IBAction)homeButtomPressed {
    [self.delegate homeButtonPressed];
}

- (IBAction)fullScreenButtonPressed {
    [self.delegate fullScreenButtonPressed:CGAffineTransformIsIdentity(self.frontView.transform)];
}

-(void)preHideBar:(BOOL)transparent
{
    if (transparent) {
        self.backView.backgroundColor = [UIColor clearColor];
        self.suggestionButtonItem.hidden = YES;
    }else {
        self.backView.backgroundColor = [UIColor colorWithPatternImage:RC_IMAGE(@"toolBarBG_Back")];
        self.suggestionButtonItem.hidden = NO;
    }
}
-(void)hideBar
{
    self.frontView.transform = CGAffineTransformMakeTranslation(self.frame.size.width, 0);
    self.isBarShown = NO;

}
-(void)showBar
{
    self.frontView.transform = CGAffineTransformIdentity;
    self.isBarShown = YES;
}


-(void)loadFrontView
{
//    self.frontView = [[[UIView alloc] initWithFrame:self.frame] autorelease];
//    
//    UIButton *backButtonItem = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    backButtonItem.frame = CGRectMake(0, 7, 60 , 30);
//    
//    UIButton *forwardButtonItem = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    forwardButtonItem.frame = CGRectOffset(backButtonItem.frame, 64, 0);
//    
//    UIButton *menuButtonItem = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    menuButtonItem.frame = CGRectOffset(forwardButtonItem.frame, 64, 0);
//    
//    UIButton *homeButtonItem = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    homeButtonItem.frame = CGRectOffset(menuButtonItem.frame, 64, 0);
//    
//    UIButton *fullScreenButtonItem = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    fullScreenButtonItem.frame = CGRectOffset(homeButtonItem.frame, 64, 0);
//
//    [self.frontView addSubview:backButtonItem];
//    [self.frontView addSubview:forwardButtonItem];
//    [self.frontView addSubview:menuButtonItem];
//    [self.frontView addSubview:homeButtonItem];
//    [self.frontView addSubview:homeButtonItem];

//    self.barStyle = UIBarStyleBlack;
//    self.translucent = YES;
//    [self sizeToFit];
//    self.autoresizesSubviews = NO;

//    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
//    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:11];
//    UIBarButtonItem *flexibleSpaceButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
//                                                                                              target:nil
//                                                                                              action:nil] autorelease];
//    UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CIALBrowser.bundle/images/browserBack.png"]
//                                                       style:UIBarButtonItemStylePlain
//                                                      target:nil
//                                                       action:nil] autorelease];
//    UIBarButtonItem *forwardButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CIALBrowser.bundle/images/browserForward.png"]
//                                                          style:UIBarButtonItemStylePlain
//                                                         target:nil
//                                                          action:nil]autorelease];
//    UIBarButtonItem *menuButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
//                                                                      target:nil
//                                                                      action:nil] autorelease];
//    UIBarButtonItem *homeButtonItem  = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks
//                                                                                         target:nil
//                                                                                         action:nil] autorelease];
//    
//    UIBarButtonItem *fullScreenButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
//                                                                                                          target:nil
//                                                                                                          action:nil] autorelease];
//    
//    [buttons addObject:flexibleSpaceButtonItem];
//    [buttons addObject:backButtonItem];
//    [buttons addObject:flexibleSpaceButtonItem];
//    [buttons addObject:forwardButtonItem];
//    [buttons addObject:flexibleSpaceButtonItem];
//    [buttons addObject:menuButtonItem];
//    [buttons addObject:flexibleSpaceButtonItem];
//    [buttons addObject:homeButtonItem];
//    [buttons addObject:flexibleSpaceButtonItem];
//    [buttons addObject:fullScreenButtonItem];
//    [buttons addObject:flexibleSpaceButtonItem];
//    
//    [self setItems:buttons];
    
//    self.backButtonItem = backButtonItem;
//    self.forwardButtonItem = forwardButtonItem;
//    self.menuButtonItem = menuButtonItem;
//    self.homeButtonItem = homeButtonItem;
//    self.fullScreenButtonItem = fullScreenButtonItem;
    
}


-(void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    self.backView.backgroundColor = [UIColor clearColor];//[UIColor colorWithPatternImage:RC_IMAGE(@"toolBarBG")];
    self.frontView.backgroundColor = [UIColor colorWithPatternImage:RC_IMAGE(@"toolBarBG")];
    [self addSubview:self.backView];
    [self addSubview:self.frontView];
    self.isBarShown = YES;
}


-(void)dealloc
{
    [super dealloc];
    [self.backView release];
    [self.frontView release];
    [self.backButtonItem release];
    [self.backButtonItem2 release];
    [self.forwardButtonItem release];
    [self.menuButtonItem release];
    [self.homeButtonItem release];
    [self.suggestionButtonItem release];
    [self.fullScreenButtonItem release];
    [self.fullScreenButtonItem2 release];
}

@end
