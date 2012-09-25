//
//  RCAddNewManully.m
//  RCWebBrowser
//
//  Created by imac on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCAddNewManully.h"
#import "RCRecordData.h"
#import "RCFastLinkObject.h"

@interface RCAddNewManully ()<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *nameField;
@property (retain, nonatomic) IBOutlet UITextField *urlField;


@end


@implementation RCAddNewManully
@synthesize nameField;
@synthesize urlField;


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField == self.urlField) {
        self.urlField.text = @"http://";
        return NO;
    }
    return YES;
}

-(id)initWithNib
{
    self = [[[[NSBundle mainBundle] loadNibNamed:@"RCAddNewManully" owner:self options:nil] objectAtIndex:0] retain];
    if (self) {
        // Initialization code
        self.nameField.delegate = self;
        self.urlField.delegate = self;
    }
    return self;
}

- (IBAction)confirm {
    
    if (!self.nameField.text.length) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入网站名称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }    
    
//    NSString * regex        = @"^http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?$";
//    NSString * regex        = @"^([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?$";
//    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    if (![pred evaluateWithObject:self.urlField.text]) {
    if (!self.urlField.text.length) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入网址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }else {
        NSURL *url = [NSURL URLWithString:self.urlField.text];
        if (!url.scheme.length) {
            url = [NSURL URLWithString:[@"http://" stringByAppendingString:self.urlField.text]];
        }
        NSString *name = self.nameField.text;
        NSMutableArray *flList = [RCRecordData recordDataWithKey:RCRD_FASTLINK];
        RCFastLinkObject *obj = [[[RCFastLinkObject alloc] initWithName:name andURL:url andIcon:nil] autorelease];
        [flList addObject:obj];
        [RCRecordData updateRecord:flList ForKey:RCRD_FASTLINK];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"添加成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        self.nameField.text = nil;
        self.urlField.text = nil;
    }
}

-(void)resignKeyboard
{
    [self.nameField resignFirstResponder];
    [self.urlField resignFirstResponder];
}


- (void)dealloc {
    [nameField release];
    [urlField release];
    [super dealloc];
}
@end
