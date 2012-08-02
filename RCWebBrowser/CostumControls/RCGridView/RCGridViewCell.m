//
//  RCGridViewCell.m
//  RCWebBrowser
//
//  Created by imac on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCGridViewCell.h"

@interface RCGridViewCell ()
//@property (nonatomic,retain) UILabel *title;
@end


@implementation RCGridViewCell
@synthesize contentView = _contentView;
@synthesize backgroundView = _backgroundView;
@synthesize closeButton = _closeButton;
@synthesize editing = _editing;
@synthesize delegate = _delegate;
@synthesize index = _index;
@synthesize contentButton = _contentButton;
//@synthesize title = _title;
-(void)setEditing:(BOOL)editing
{
    if (_editing != editing) {
        _editing = editing;
        self.closeButton.hidden = !_editing;
    }
}

-(void)setIndex:(NSInteger)index
{
    if (_index != index) {
        _index = index;
//        self.title.text = [NSString stringWithFormat:@"%d",index];
    }
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundView = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
        [self addSubview:self.backgroundView];
        
        self.contentView = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
        self.contentView.userInteractionEnabled = YES;
        [self addSubview:self.contentView];
        
//        self.contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.contentButton.frame = self.bounds;
////        [self.contentButton setBackgroundImage:RC_IMAGE(@"defaultButtonBG") forState:UIControlStateNormal];
//        [self.contentButton addTarget:self action:@selector(contentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:self.contentButton];
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeButton.frame = CGRectMake(-7, -7, 29, 29);
        [self.closeButton setBackgroundImage:RC_IMAGE(@"closeX.png") forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeButton];
        self.closeButton.hidden = YES;
        
//        UILabel *title = [[UILabel alloc] initWithFrame:self.bounds];
//        title.backgroundColor = [UIColor clearColor];
//        [self addSubview:title];
//        title.textColor = [UIColor blackColor];
//        self.title = title;
//        self.title.text = [NSString stringWithFormat:@"%d",self.index];
    }
    return self;
}



-(void)closeButtonPressed:(UIButton*)sender
{
    [self.delegate cellNeedToBeRemoved:self];
}

-(void)contentButtonPressed:(UIButton*)sender
{
    [self.delegate cellTappedWhenEditing:self];
}
@end
