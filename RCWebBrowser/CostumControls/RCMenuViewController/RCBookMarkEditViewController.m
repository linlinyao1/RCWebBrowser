//
//  RCBookMarkEditViewController.m
//  RCWebBrowser
//
//  Created by imac on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCBookMarkEditViewController.h"
#import "RCRecordData.h"
#import "BookmarkObject.h"

@interface RCBookMarkEditViewController ()
@property (nonatomic,retain) NSMutableArray *bookMarkArray;
@end

@implementation RCBookMarkEditViewController
@synthesize bookMarkNameField;
@synthesize bookMarkURLField;
@synthesize index = _index;
@synthesize bookMarkArray = _bookMarkArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)editBookMark:(UIButton*)sender
{
    BookmarkObject *obj = [self.bookMarkArray objectAtIndex:self.index];
    obj.name = self.bookMarkNameField.text;
    obj.url = [NSURL URLWithString:self.bookMarkURLField.text];
    [self.bookMarkArray replaceObjectAtIndex:self.index withObject:obj];
    [RCRecordData updateRecord:self.bookMarkArray ForKey:RCRD_BOOKMARK];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSMutableArray *bookMarks = [RCRecordData recordDataWithKey:RCRD_BOOKMARK];
    BookmarkObject *obj = [bookMarks objectAtIndex:self.index];
    self.bookMarkNameField.text = obj.name;
    self.bookMarkURLField.text = obj.url.absoluteString;
    self.bookMarkArray = bookMarks;
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    header.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"编辑收藏";
    [header addSubview:titleLabel];
    [titleLabel release];
    
    UIButton *edit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    edit.frame = CGRectMake(130, 0, 44, 44);
    [edit setTitle:@"完成" forState:UIControlStateNormal];
    [edit addTarget:self action:@selector(editBookMark:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:edit];
    
    self.navigationItem.titleView = header;
    [header release];
}

- (void)viewDidUnload
{
    [self setBookMarkNameField:nil];
    [self setBookMarkURLField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [bookMarkNameField release];
    [bookMarkURLField release];
    [super dealloc];
}
@end
