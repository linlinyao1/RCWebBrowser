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
@synthesize delegate = _delegate;
@synthesize closeButton = _closeButton;
@synthesize url = _url;

-(void)closeButtonPressed:(UIButton*)sender
{
    NSLog(@"button at %@ need to be closed",NSStringFromCGRect(self.frame));
    [self.delegate buttonNeedToBeRemoved:self];
}


-(void)enterEditMode
{
    if (!self.closeButton) {
        self.closeButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
        [self.closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:self.closeButton];
    self.transform = CGAffineTransformMakeScale(0.8, 0.8);
}

-(void)exitEditMode
{
    if (self.closeButton) {
        [self.closeButton removeFromSuperview];
    }
    self.transform = CGAffineTransformIdentity;
}


-(void)longPress:(UILongPressGestureRecognizer*)gesture
{   

    [self.delegate editModeEnter];
}

-(void)pan:(UIPanGestureRecognizer*)gesture
{
    if (![self.delegate isEditMode]) {
        return;
    }
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.delegate button:self WillBeginMovingAtCenter:self.center];    
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        [self.delegate button:self DidEndMovingAtCenter:self.center];
    }else {
        CGPoint location = [gesture locationInView:[self superview]];
        self.center = location;
        [self.delegate button:self MovedToLocation:location];
    }

}

-(void)buttonTapped:(UIButton*)sender
{
    if ([self.delegate isEditMode]) {
        [self.closeButton removeFromSuperview];
        [self.delegate editModeExit];
    }else {
    }
}

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
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPress];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
        
        [self addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}


@end
