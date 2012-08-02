//
//  RCBookMarkEditViewController.h
//  RCWebBrowser
//
//  Created by imac on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCBookMarkEditViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *bookMarkNameField;
@property (retain, nonatomic) IBOutlet UITextField *bookMarkURLField;
@property (nonatomic) NSInteger index;
@end
