//
//  RCFastLinkButton.m
//  RCWebBrowser
//
//  Created by imac on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCFastLinkButton.h"
#import "QuartzCore/QuartzCore.h"


@interface RCFastLinkButton ()
@end

@implementation RCFastLinkButton
@synthesize url = _url;


-(id)initWithFrame:(CGRect)frame Icon:(UIImage *)icon Name:(NSString *)name
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor clearColor];
//        self.layer.cornerRadius = 6;
//        self.layer.masksToBounds = YES;
//        [self setBackgroundImage:RC_IMAGE(@"fastlinkButtonBG") forState:UIControlStateNormal];
//        if (name) {
//            UIImageView *textBG = [[UIImageView alloc] initWithImage:RC_IMAGE(@"fastlink_textBG")];
//            textBG.frame = CGRectMake(5, 47, 54, 15);
//            
//            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 54, 15)];
//            nameLabel.backgroundColor = [UIColor clearColor];
//            nameLabel.textAlignment = UITextAlignmentCenter;
//            nameLabel.text = name;
//            nameLabel.textColor = [UIColor whiteColor];
//            nameLabel.font = [UIFont systemFontOfSize:10];
//            [textBG addSubview:nameLabel];
//            [nameLabel release];
//            [self addSubview:textBG];
//            [textBG release];
//        }
        if (icon) {
            [self setBackgroundImage:icon forState:UIControlStateNormal];
        }else {
            [self setBackgroundImage:RC_IMAGE(@"defaultButtonBG") forState:UIControlStateNormal];
        }
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)dealloc
{
    [_url release];
    [super dealloc];
}

@end
