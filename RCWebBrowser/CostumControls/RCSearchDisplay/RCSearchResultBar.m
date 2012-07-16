////
////  RCSearchResultBar.m
////  RCWebBrowser
////
////  Created by imac on 12-7-11.
////  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
////
//
//#import "RCSearchResultBar.h"
//
//
//
////@interface RCSearchResultBar()<UITextFieldDelegate> 
////@property (nonatomic,retain) UIButton *searchEngineButton;
////@property (nonatomic,retain) UIToolbar *keyBoardAccessory;
////@property (nonatomic,retain) NSArray *keyBoardButtons;
////@end
////
////
////@implementation RCSearchResultBar
////@synthesize searchEngineButton = _searchEngineButton;
////@synthesize inputField = _inputField;
////@synthesize cancelButton = _cancelButton;
////@synthesize keyBoardAccessory = _keyBoardAccessory;
////@synthesize KBAType = _KBAType;
////@synthesize keyBoardButtons = _keyBoardButtons;
////
////
////
////-(void)keyBoardAccessoryItemPressed:(UIBarButtonItem*)sender
////{
////    NSString *string = [sender title];
////    if (RCKeyBoardTypePrefix == self.KBAType ) {
////        self.inputField.text = [string  stringByAppendingString:self.inputField.text];
////        self.KBAType = RCkeyBoardTypeSuffix;
////    }else if (RCkeyBoardTypeSuffix == self.KBAType ) {
////        self.inputField.text = [self.inputField.text  stringByAppendingString:string];
////    }
////}
////
////-(void)makeKeyBoardAccessoryWithType:(RCKeyBoardAccessoryType)type
////{
////    NSArray *array;
////    if (RCKeyBoardTypePrefix == type) {
////        array = [NSArray arrayWithObjects:@"www.",@"m.",@"3g.",@"wap.", nil];
////    }else if (RCkeyBoardTypeSuffix == type) {
////        array = [NSArray arrayWithObjects:@".com",@".cn",@".net",@".com.cn", nil];
////    }else {
////        self.inputField.inputAccessoryView = nil;
////        [self.inputField reloadInputViews];
////        return;
////    }
////    
////    int i =0;
////    for (UIBarButtonItem* item in self.keyBoardButtons) {
////        [item setTitle:[array objectAtIndex:i]];
////        i++;
////    }
////    if (!self.inputField.inputAccessoryView) {
////        self.inputField.inputAccessoryView = self.keyBoardAccessory;
////        [self.inputField reloadInputViews];
////    }
////}
////-(void)setKBAType:(RCKeyBoardAccessoryType)KBAType
////{
////    if (_KBAType != KBAType) {
////        [self makeKeyBoardAccessoryWithType:KBAType];
////        _KBAType = KBAType;
////    }
////}
////
////
////
////
////
////
////-(id)initWithFrame:(CGRect)frame
////{
////    self = [super initWithFrame:frame];
////    if (self) {
////        //Search engine button
////        UIButton *searchEngineButton = [UIButton buttonWithType:UIButtonTypeCustom];
////        searchEngineButton.frame =CGRectMake(2, 2, 40, 40);
////        [searchEngineButton setImage:[UIImage imageNamed:@"add_fov"] forState:UIControlStateNormal];
////        [searchEngineButton setImage:[UIImage imageNamed:@"add_fov"] forState:UIControlStateHighlighted];
////        [self addSubview:searchEngineButton];
////        self.searchEngineButton = searchEngineButton;
////        
////        // url input
////        UITextField *locationField = [[UITextField alloc] initWithFrame:CGRectMake(44,7,230,30)];
////        locationField.delegate = self;
////        locationField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
////        locationField.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];
////        locationField.textAlignment = UITextAlignmentLeft;
////        locationField.borderStyle = UITextBorderStyleRoundedRect;
////        locationField.font = [UIFont fontWithName:@"Helvetica" size:15];
////        locationField.autocorrectionType = UITextAutocorrectionTypeNo;
////        locationField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
////        locationField.clearsOnBeginEditing = NO;
////        locationField.autocapitalizationType = UITextAutocapitalizationTypeNone;
////        locationField.autocorrectionType = UITextAutocorrectionTypeNo;
////        locationField.keyboardType = UIKeyboardTypeURL;
////        locationField.returnKeyType = UIReturnKeyGo;
////        locationField.clearButtonMode = UITextFieldViewModeWhileEditing;
////        [self addSubview:locationField];
////        self.inputField = locationField;
////        [locationField release];
////        
////        //keyboard accessory
////        UIToolbar *kb= [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
////        
////        NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:9];
////        UIBarButtonItem *flexibleSpaceButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
////                                                                                                  target:nil
////                                                                                                  action:nil] autorelease];
////        UIBarButtonItem *Button1 = [[[UIBarButtonItem alloc] initWithTitle:@"1" style:UIBarButtonItemStylePlain target:self action:@selector(keyBoardAccessoryItemPressed:)] autorelease];
////        UIBarButtonItem *Button2 = [[[UIBarButtonItem alloc] initWithTitle:@"2" style:UIBarButtonItemStylePlain target:self action:@selector(keyBoardAccessoryItemPressed:)] autorelease];
////        
////        UIBarButtonItem *Button3 = [[[UIBarButtonItem alloc] initWithTitle:@"3" style:UIBarButtonItemStylePlain target:self action:@selector(keyBoardAccessoryItemPressed:)] autorelease];   
////        
////        UIBarButtonItem *Button4 = [[[UIBarButtonItem alloc] initWithTitle:@"4" style:UIBarButtonItemStylePlain target:self action:@selector(keyBoardAccessoryItemPressed:)] autorelease];                 
////        
////        [buttons addObject:flexibleSpaceButtonItem];
////        [buttons addObject:Button1];
////        [buttons addObject:flexibleSpaceButtonItem];
////        [buttons addObject:Button2];
////        [buttons addObject:flexibleSpaceButtonItem];
////        [buttons addObject:Button3];
////        [buttons addObject:flexibleSpaceButtonItem];
////        [buttons addObject:Button4];
////        [buttons addObject:flexibleSpaceButtonItem];
////        
////        [kb setItems:buttons];
////        
////        self.keyBoardButtons = [NSArray arrayWithObjects:Button1,Button2,Button3,Button4, nil];
////        self.keyBoardAccessory = kb;                
////        self.KBAType = RCKeyBoardTypePrefix;
////        
////        
////        //cancel button
////        UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
////        cancelButton.frame = CGRectMake(276, 7, 45, 30);
////        [self addSubview:cancelButton];
////        self.cancelButton = cancelButton;
////        
////    }
////    return self;
////}
//
//
//
//
//@end
