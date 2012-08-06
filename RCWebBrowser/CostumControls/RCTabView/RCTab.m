//
//  RCTab.m
//  RCWebBrowser
//
//  Created by imac on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCTab.h"


//#define RCTAB_IMAGE_INACTIVE RC_IMAGE(@"on_label")
//#define RCTAB_IMAGE_ACTIVE RC_IMAGE(@"active_label")
//#define RCTAB_IMAGE_CLOSE_INACTIVE RC_IMAGE(@"button_close_tab_on_1")
//#define RCTAB_IMAGE_CLOSE_ACTIVE RC_IMAGE(@"button_close_tab_on_1_press")

@interface RCTab()
@property (nonatomic,retain) UIButton *closeButton;
@end    

@implementation RCTab
@synthesize delegate = _delegate;
@synthesize closeButton = _closeButton;
@synthesize titleLabel = _titleLabel;
-(void)closeButtonPressed:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(tabNeedsToClose:)]) {
        [self.delegate tabNeedsToClose:self];
    }
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *bgImage_selected = [[UIImageView alloc] initWithImage:RC_IMAGE(@"tab_active")];
        UIImageView *bgImage = [[UIImageView alloc] initWithImage:RC_IMAGE(@"tab_inactive")];
        [self setBackgroundView:bgImage];
        [self setSelectedBackgroundView:bgImage_selected];
        [bgImage release];
        [bgImage_selected release];
     
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(110, 9, 24, 24);
        [closeButton setBackgroundImage:RC_IMAGE(@"tab_close_nomal") forState:UIControlStateNormal];
        [closeButton setBackgroundImage:RC_IMAGE(@"tab_close_pressed") forState:(UIControlStateHighlighted|UIControlStateSelected)];
        [closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.closeButton = closeButton;
        [self.contentView addSubview:closeButton];
//        [self setAccessoryView:closeButton];
        [self.closeButton setHidden:YES];
        
//        self.textLabel.textAlignment = UITextAlignmentCenter;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 95, 42)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        [titleLabel release];
        
//        self.textLabel.backgroundColor = [UIColor clearColor];
//        self.textLabel.textColor = [UIColor blackColor];
    }
    
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.backgroundView addSubview:self.selectedBackgroundView];
        if ([self.delegate canCloseCell]) {
//            self.accessoryView.hidden = NO;
            self.closeButton.hidden = NO;
        }
    }else {
        [self.selectedBackgroundView removeFromSuperview];
//        self.accessoryView.hidden = YES;
        self.closeButton.hidden = YES;
    }
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    self.imageView.frame = CGRectMake(7,10,20,20);
//    self.imageView.bounds = CGRectMake(0,0,20,20);
//}
-(void)dealloc
{
    [_titleLabel release];
    [_closeButton release];
    [super dealloc];
}

@end
