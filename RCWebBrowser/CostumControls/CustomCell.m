//
//  CustomCell.m
//  PPRevealSideViewController
//
//  Created by Marian PAUL on 17/02/12.
//  Copyright (c) 2012 Marian PAUL aka ipodishima — iPuP SARL. All rights reserved.
//

#import "CustomCell.h"
#import "PPRevealSideViewController.h"

@implementation CustomCell
@synthesize myLabel = _myLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        _disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        [self.contentView addSubview:_disclosureButton];
//        _disclosureButton.frame = CGRectMake(0, 0, 40, 40);
//        self.textLabel.backgroundColor = [UIColor clearColor];
//        
//        _myLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _myLabel.backgroundColor = [UIColor clearColor];
//        _myLabel.numberOfLines = 2;
//        
//        [self.contentView addSubview:_myLabel];
        
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];    
    
//    for (UIView *view in [self subviews]) {
//        if (CGRectGetMaxX(view.frame)>self.frame.size.width-self.revealSideInset.right) {
//            view.frame = CGRectOffset(view.frame, -self.revealSideInset.right, 0);
//        }
////        view.frame = CGRectOffset(view.frame, self.revealSideInset.right - self.revealSideInset.left, self.revealSideInset.bottom - self.revealSideInset.top);
////        view.frame = CGRectMake(view.frame.origin.x + self.revealSideInset.left,
////                                view.frame.origin.y + self.revealSideInset.top,
////                                view.frame.size.width - self.revealSideInset.left - self.revealSideInset.right,
////                                view.frame.size.height - self.revealSideInset.left - self.revealSideInset.right)
//    };
//    CGRect frame = self.frame;
//    frame.size.width = 
//    CGRect newFrame = _disclosureButton.frame;
//    newFrame.origin.x = CGRectGetWidth(self.contentView.frame)- 5.0 /*margin*/ - self.revealSideInset.right - CGRectGetWidth(newFrame);
//    newFrame.origin.y = floorf((CGRectGetHeight(self.frame) - CGRectGetHeight(_disclosureButton.frame))/2.0);
//    _disclosureButton.frame = newFrame;
//    
//    CGFloat margin = 3.0;
//    
//    _myLabel.frame = CGRectMake(margin, 
//                                margin, 
//                                CGRectGetMinX(newFrame)-2*margin,
//                                CGRectGetHeight(self.frame) - 2*margin);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) dealloc {
    self.myLabel = nil;
#if !PP_ARC_ENABLED
    [super dealloc];
#endif
}

@end
