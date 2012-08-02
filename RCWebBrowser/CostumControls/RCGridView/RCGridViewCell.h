//
//  RCGridViewCell.h
//  RCWebBrowser
//
//  Created by imac on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol RCGridViewCellDelegate;


@interface RCGridViewCell : UIView
@property (nonatomic,retain) UIView *contentView;
@property (nonatomic,retain) UIImageView *backgroundView;
@property (nonatomic) NSInteger index;
@property (nonatomic,getter = isEditing) BOOL editing;
@property (nonatomic,retain) UIButton *contentButton;
@property (nonatomic,retain) UIButton *closeButton;

@property (nonatomic,assign) NSObject<RCGridViewCellDelegate> *delegate;
@end

@protocol RCGridViewCellDelegate <NSObject>

-(void)cellNeedToBeRemoved:(RCGridViewCell*)cell;
-(void)cellTappedWhenEditing:(RCGridViewCell*)cell;
@end