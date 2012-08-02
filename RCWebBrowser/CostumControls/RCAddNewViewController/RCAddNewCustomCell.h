//
//  RCAddNewCustomCell.h
//  RCWebBrowser
//
//  Created by imac on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCAddNewCustomCellButton : UIButton
@property (nonatomic,retain) NSURL *url;
@property (nonatomic,retain) UILabel *nameLabel;
@property (nonatomic,retain) UIImageView *checkMark;
@property (nonatomic,copy) NSString* imageName;
@property (nonatomic) BOOL mark;
@end

@interface RCAddNewCustomCell : UITableViewCell
@property (nonatomic,retain) RCAddNewCustomCellButton *leftIcon;
@property (nonatomic,retain) RCAddNewCustomCellButton *rightIcon;
@end


