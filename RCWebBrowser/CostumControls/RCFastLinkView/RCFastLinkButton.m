//
//  RCFastLinkButton.m
//  RCWebBrowser
//
//  Created by imac on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCFastLinkButton.h"

@interface RCFastLinkButton ()
@property (nonatomic,retain) UIButton *closeButton;
@end

@implementation RCFastLinkButton
@synthesize closeButton = _closeButton;
@synthesize url = _url;


-(id)initWithFrame:(CGRect)frame Icon:(UIImage *)icon Name:(NSString *)name
{
    self = [self initWithFrame:frame];
    if (self) {
        if (name) {
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 52, 64, 12)];
            nameLabel.text = name;
            nameLabel.backgroundColor = [UIColor grayColor];
            nameLabel.textColor = [UIColor whiteColor];
            nameLabel.font = [UIFont systemFontOfSize:10];
            [self addSubview:nameLabel];
//            self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;  
//            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//            self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//            self.titleLabel.backgroundColor = [UIColor grayColor];
//            self.titleLabel.textColor = [UIColor whiteColor];
//            self.titleLabel.font = [UIFont systemFontOfSize:11];
//            [self setTitle:name forState:UIControlStateNormal];
//            self.titleLabel.textAlignment = UITextAlignmentCenter;
//            [self.titleLabel sizeThatFits:CGSizeMake(self.frame.size.width, self.titleLabel.frame.size.height)];
//            [self.titleLabel sizeToFit];
        }
        if (icon) {
            [self setBackgroundImage:icon forState:UIControlStateNormal];
        }
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


@end
