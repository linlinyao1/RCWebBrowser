//
//  RCAddNewCustomCell.m
//  RCWebBrowser
//
//  Created by imac on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCAddNewCustomCell.h"

@implementation RCAddNewCustomCell
@synthesize leftIcon = _leftIcon;
@synthesize rightIcon = _rightIcon;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.leftIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftIcon = [[[RCAddNewCustomCellButton alloc] initWithFrame:CGRectMake(30, 13, 64, 64)] autorelease];
//        self.leftIcon.frame = CGRectMake(0, 3, 64, 64);
        [self.contentView addSubview:self.leftIcon];
        
        self.rightIcon = [[[RCAddNewCustomCellButton alloc] initWithFrame:CGRectMake(120, 13, 64, 64)] autorelease];
//        self.rightIcon = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.rightIcon.frame = CGRectMake(70, 3, 64, 64);
        [self.contentView addSubview:self.rightIcon];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}



@end



@implementation RCAddNewCustomCellButton
@synthesize url = _url;
@synthesize checkMark = _checkMark;
@synthesize mark = _mark;
@synthesize nameLabel = _nameLabel;
@synthesize imageName = _imageName;


-(void)setMark:(BOOL)mark
{
    if (mark) {
        [self addSubview:self.checkMark];
    }else {
        [self.checkMark removeFromSuperview];
    }
    _mark = mark;
}

-(void)setImageName:(NSString*)imageName
{
    if (_imageName!=imageName) {
        _imageName = imageName;
        [self setImage:RC_IMAGE(imageName) forState:UIControlStateNormal];
    }
}

-(UIImageView *)checkMark
{
    if (!_checkMark) {
        _checkMark = [[UIImageView alloc] initWithImage:RC_IMAGE(@"addNew_exit")];
        _checkMark.frame = CGRectOffset(_checkMark.bounds, 35, 0);
//        _checkMark.frame = self.bounds;
    }
    return _checkMark;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *textBG = [[[UIImageView alloc] initWithImage:RC_IMAGE(@"fastlink_textBG")] autorelease];
        textBG.frame = CGRectMake(5, 47, 54, 15);
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 54, 15)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = UITextAlignmentCenter;
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont systemFontOfSize:10];
        self.nameLabel = nameLabel;
        [nameLabel release];
        [textBG addSubview:nameLabel];
        [self addSubview:textBG];
    }
    return self;
}




@end