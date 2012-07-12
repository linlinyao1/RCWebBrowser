//
//  RCTab.m
//  RCWebBrowser
//
//  Created by imac on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCTab.h"


#define RCTAB_IMAGE_INACTIVE RC_IMAGE(@"on_label")
#define RCTAB_IMAGE_ACTIVE RC_IMAGE(@"active_label")
#define RCTAB_IMAGE_CLOSE_INACTIVE RC_IMAGE(@"button_close_tab_on_1")
#define RCTAB_IMAGE_CLOSE_ACTIVE RC_IMAGE(@"button_close_tab_on_1_press")

@interface RCTab()

@end    

@implementation RCTab
@synthesize delegate = _delegate;

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
        UIImageView *bgImage_selected = [[UIImageView alloc] initWithImage:RC_IMAGE(@"active_label")];
        UIImageView *bgImage = [[UIImageView alloc] initWithImage:RC_IMAGE(@"on_label")];
        [self setBackgroundView:bgImage];
        [self setSelectedBackgroundView:bgImage_selected];
        [bgImage release];
        [bgImage_selected release];
     
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(0, 0, 21.5, 23);
        [closeButton setBackgroundImage:RCTAB_IMAGE_CLOSE_INACTIVE forState:UIControlStateNormal];
        [closeButton setBackgroundImage:RCTAB_IMAGE_CLOSE_ACTIVE forState:(UIControlStateHighlighted|UIControlStateSelected)];
        [closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self setAccessoryView:closeButton];
        [self.accessoryView setHidden:YES];
        
        self.textLabel.textAlignment = UITextAlignmentCenter;
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
    }
    
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.backgroundView addSubview:self.selectedBackgroundView];
        if ([self.delegate canCloseCell]) {
            self.accessoryView.hidden = NO;
        }
    }else {
        [self.selectedBackgroundView removeFromSuperview];
        self.accessoryView.hidden = YES;
    }
}


@end
