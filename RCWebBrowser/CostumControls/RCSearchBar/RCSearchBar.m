//
//  RCSearchBar.m
//  RCWebBrowser
//
//  Created by imac on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCSearchBar.h"
#import "JSONKit.h"
#import "RCRecordData.h"
#import "RCSearchEnginePop.h"

#import "YLProgressBar.h"

@interface RCSearchBar ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,RCSearchEnginePopDelegate>
@property (nonatomic,retain) UIButton *searchEngineButton;
@property (nonatomic,retain) UIButton *cancelButton;
@property (nonatomic,retain) UIToolbar *keyBoardAccessory;
@property (nonatomic,retain) NSArray *keyBoardButtons;
@property (nonatomic,retain) UITableView *searchResultTable;
@property (nonatomic,retain) NSMutableArray *listContent;			// The master content.
@property (nonatomic,retain) NSMutableArray *historys;
@property (nonatomic,retain) YLProgressBar *progressBar;
@end

@implementation RCSearchBar
@synthesize delegate = _delegate;
@synthesize locationField = _locationField;
@synthesize stopReloadButton = _stopReloadButton;
@synthesize bookMarkButton = _bookMarkButton;
@synthesize bookMarkPop = _bookMarkPop;
@synthesize searchEnginePop = _searchEnginePop;
@synthesize searchEngineButton = _searchEngineButton;
@synthesize cancelButton = _cancelButton;
@synthesize keyBoardAccessory = _keyBoardAccessory;
@synthesize KBAType = _KBAType;
@synthesize keyBoardButtons = _keyBoardButtons;
@synthesize searchResultTable = _searchResultTable;
@synthesize listContent = _listContent;
@synthesize historys = _historys;
@synthesize progressBar = _progressBar;


-(NSMutableArray *)listContent
{
    if (!_listContent) {
        _listContent = [[NSMutableArray alloc] initWithCapacity:1];
        
        NSMutableArray *historyArray = [RCRecordData recordDataWithKey:RCRD_HISTORY];
        [historyArray sortUsingComparator:^NSComparisonResult(BookmarkObject *obj1, BookmarkObject *obj2) {
            return  [obj2.date compare:obj1.date];
        }];
        self.historys = historyArray;
    }
    return _listContent;
}



-(void)hideViewWithOffset:(CGFloat)offset
{
    self.transform = CGAffineTransformMakeTranslation(0, -offset);
}
-(void)showView
{
    self.transform = CGAffineTransformIdentity;
}


- (void)reloadOrStop:(id) sender {
    [self.delegate reloadOrStop:sender];
}


-(void)setLoadingProgress:(CGFloat)progress
{
    if (progress>=1) {
        [UIView animateWithDuration:.2 animations:^{
            self.progressBar.progress = 1;
        }completion:^(BOOL finished) {
            [self.progressBar removeFromSuperview];
        }];
    }else if (progress<=0) {
        [self.progressBar removeFromSuperview];
    }else {
        if (![[self.locationField subviews] containsObject:self.progressBar]) {
            [self.locationField addSubview:self.progressBar];
        }
        self.progressBar.progress = progress;
    }
}


-(void)bookMarkButtonPressed:(UIButton*)sender
{
    
    // Toggle popTipView when a standard UIButton is pressed
    if (nil == self.bookMarkPop) {
        RCBookMarkPop *pop = [[[RCBookMarkPop alloc] initWithFrame:CGRectMake(0, 0, 100, 50)] autorelease];
        pop.delegate = self.delegate;
        [pop updateBttonState];
        self.bookMarkPop = [[[CMPopTipView alloc] initWithCustomView:pop] autorelease];
        self.bookMarkPop.backgroundColor = [UIColor whiteColor];        
        [self.bookMarkPop presentPointingAtView:sender inView:self.superview animated:NO];
    }
    else {
        // Dismiss
        [self.bookMarkPop dismissAnimated:YES];
        self.bookMarkPop = nil;
    }	
}
-(void)searchEngineButtonPressed:(UIButton*)sender
{
    // Toggle popTipView when a standard UIButton is pressed
    if (nil == self.searchEnginePop) {
        [self.locationField resignFirstResponder];
        RCSearchEnginePop *pop = [[[RCSearchEnginePop alloc] initWithFrame:CGRectMake(0, 0, 100, 150) style:UITableViewStylePlain] autorelease];
        pop.notification = self;
        self.searchEnginePop = [[[CMPopTipView alloc] initWithCustomView:pop] autorelease];
        self.searchEnginePop.backgroundColor = [UIColor whiteColor];      
        
        [self.searchEnginePop presentPointingAtView:sender inView:self.superview animated:NO];
    }
    else {
        // Dismiss
        [self.searchEnginePop dismissAnimated:YES];
        self.searchEnginePop = nil;
    }
}


-(void)loadView
{
    //bookmark button
    UIButton *bookMarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bookMarkButton.frame =CGRectMake(2, 2, 40, 40);
    [bookMarkButton setImage:[UIImage imageNamed:@"add_fov"] forState:UIControlStateNormal];
    [bookMarkButton setImage:[UIImage imageNamed:@"add_fov"] forState:UIControlStateHighlighted];
    [bookMarkButton addTarget:self action:@selector(bookMarkButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:bookMarkButton];
    self.bookMarkButton = bookMarkButton;
    
    // url input
    UITextField *locationField = [[UITextField alloc] initWithFrame:CGRectMake(44,7,266,30)];
    locationField.delegate = self;
    locationField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    locationField.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];
    locationField.textAlignment = UITextAlignmentLeft;
    locationField.borderStyle = UITextBorderStyleRoundedRect;
    locationField.font = [UIFont fontWithName:@"Helvetica" size:15];
    locationField.autocorrectionType = UITextAutocorrectionTypeNo;
    locationField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    locationField.clearsOnBeginEditing = NO;
    locationField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    locationField.autocorrectionType = UITextAutocorrectionTypeNo;
    locationField.keyboardType = UIKeyboardTypeURL;
    locationField.returnKeyType = UIReturnKeyGo;
    locationField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:locationField];
    self.locationField = locationField;
    [locationField release];
    
    // progressBar
    YLProgressBar *progressBar = [[YLProgressBar alloc] initWithFrame:locationField.bounds];
    progressBar.userInteractionEnabled = NO;
    self.progressBar = progressBar;
    
    
    //reload/stop button
    UIButton *stopReloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stopReloadButton.bounds = CGRectMake(0, 0, 26, 30);
    [stopReloadButton setImage:[UIImage imageNamed:@"CIALBrowser.bundle/images/AddressViewReload.png"] forState:UIControlStateNormal];
    [stopReloadButton setImage:[UIImage imageNamed:@"CIALBrowser.bundle/images/AddressViewReload.png"] forState:UIControlStateHighlighted];
    stopReloadButton.showsTouchWhenHighlighted = NO;
    [stopReloadButton addTarget:self action:@selector(reloadOrStop:) forControlEvents:UIControlEventTouchUpInside];
    locationField.rightView = stopReloadButton;
    locationField.rightViewMode = UITextFieldViewModeUnlessEditing;
    self.stopReloadButton = stopReloadButton;
    
    // searchEngineButton
    UIButton *searchEngineButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    searchEngineButton.bounds = CGRectMake(0, 0, 16, 16);
    [searchEngineButton addTarget:self action:@selector(searchEngineButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    NSNumber *setype = [[NSUserDefaults standardUserDefaults]objectForKey:SE_UDKEY];
    UIImage *image = [RCSearchEnginePop imageForSEType:setype.intValue];
    [searchEngineButton setBackgroundImage:image forState:UIControlStateNormal];
    self.locationField.leftView = searchEngineButton;
    self.locationField.leftViewMode = UITextFieldViewModeNever;
    self.searchEngineButton = searchEngineButton;
    
    //cancelButton
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake(320, 7, 30, 30);
    [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    self.cancelButton = cancelButton;
    
    //keyboard accessory
    UIToolbar *kb= [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:9];
    UIBarButtonItem *flexibleSpaceButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                              target:nil
                                                                                              action:nil] autorelease];
    UIBarButtonItem *Button1 = [[[UIBarButtonItem alloc] initWithTitle:@"1" style:UIBarButtonItemStylePlain target:self action:@selector(keyBoardAccessoryItemPressed:)] autorelease];
    UIBarButtonItem *Button2 = [[[UIBarButtonItem alloc] initWithTitle:@"2" style:UIBarButtonItemStylePlain target:self action:@selector(keyBoardAccessoryItemPressed:)] autorelease];
    
    UIBarButtonItem *Button3 = [[[UIBarButtonItem alloc] initWithTitle:@"3" style:UIBarButtonItemStylePlain target:self action:@selector(keyBoardAccessoryItemPressed:)] autorelease];   
    
    UIBarButtonItem *Button4 = [[[UIBarButtonItem alloc] initWithTitle:@"4" style:UIBarButtonItemStylePlain target:self action:@selector(keyBoardAccessoryItemPressed:)] autorelease];                 
    
    [buttons addObject:flexibleSpaceButtonItem];
    [buttons addObject:Button1];
    [buttons addObject:flexibleSpaceButtonItem];
    [buttons addObject:Button2];
    [buttons addObject:flexibleSpaceButtonItem];
    [buttons addObject:Button3];
    [buttons addObject:flexibleSpaceButtonItem];
    [buttons addObject:Button4];
    [buttons addObject:flexibleSpaceButtonItem];
    
    [kb setItems:buttons];
    
    self.keyBoardButtons = [NSArray arrayWithObjects:Button1,Button2,Button3,Button4, nil];
    self.keyBoardAccessory = kb;                
    self.KBAType = RCKeyBoardTypePrefix;

    
    //end
    [self restoreDefaultState];
}

-(void)loadDataWithText:(NSString*)text
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *tempArray = [[[NSMutableArray alloc] init] autorelease];
        
        if (!text.length) {
            for (int i=0; i<MIN(self.historys.count, 10); i++) {
                [tempArray addObject:[self.historys objectAtIndex:i]];
            }
        }else {
            int i =0;
            for (BookmarkObject *obj in self.historys) {
                if ([obj.url.absoluteString rangeOfString:text].length) {
                    if (i>10) {
                        break;
                    }
                    [tempArray addObject:obj];
                    i++;
                }
            } 
            //for baidu search
            NSString *query = [NSString stringWithFormat:@"http://unionsug.baidu.com/su?wd=%@",text];
            query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:query]];      
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);//
            NSString* string = [[NSString alloc] initWithData:data encoding:enc];
            if (string) {
                string = [string stringByReplacingCharactersInRange:[string rangeOfString:@"window.baidu.sug("] withString:@""];
                string = [string stringByReplacingCharactersInRange:[string rangeOfString:@");"] withString:@""];
                string = [string stringByReplacingOccurrencesOfString:@"q:" withString:@"\"q\":"];
                string = [string stringByReplacingOccurrencesOfString:@"p:" withString:@"\"p\":"];
                string = [string stringByReplacingOccurrencesOfString:@"s:" withString:@"\"s\":"];
            }

            
            NSDictionary *jsonDic = [string mutableObjectFromJSONString];
            NSArray *baiduArray = [jsonDic objectForKey:@"s"];
            [tempArray addObjectsFromArray:baiduArray];{
                
            }

        }  
        dispatch_async(dispatch_get_main_queue(), ^{
            //                [self.listContent removeAllObjects];
            self.listContent = tempArray;
            [self.searchResultTable reloadData];   
        }); 
    });
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadView];
    }
    return self;
}

-(void)awakeFromNib
{
    [self loadView];
}

-(void)restoreDefaultState
{
    self.locationField.text = nil;
    self.locationField.placeholder = @"请输入网址";
    [self.bookMarkButton setEnabled:NO];
}




-(void)cancelButtonPressed:(UIButton*)sender
{
    if ([self.locationField isFirstResponder]) {
        [self.locationField resignFirstResponder];
    }
    
    [self turnOffSearchMode];
}


-(void)preTurnOnSearchMode
{
//    [self.bookMarkButton setHidden:YES];
}
-(void)turnOnSearchMode
{
    [UIView animateWithDuration:.5 
                     animations:^{
                         self.locationField.leftViewMode = UITextFieldViewModeAlways;
                         self.locationField.rightViewMode = UITextFieldViewModeNever;
                         self.bookMarkButton.transform = CGAffineTransformMakeTranslation(-CGRectGetMaxX(self.bookMarkButton.frame), 0);
                         self.locationField.transform = CGAffineTransformMakeTranslation(-42, 0);
                         self.cancelButton.transform = CGAffineTransformMakeTranslation(-self.cancelButton.frame.size.width, 0);
                         self.searchResultTable.transform = CGAffineTransformMakeTranslation(0, -self.searchResultTable.frame.size.height);
                         [self.delegate searchModeOn];
                     }completion:^(BOOL completed){   
                         [self loadDataWithText:self.locationField.text];
//                         [self.locationField setSelectedTextRange:[self.locationField textRangeFromPosition:self.locationField.beginningOfDocument toPosition:self.locationField.endOfDocument]];
//                         [self.locationField selectAll:self];
//                         [[UIMenuController sharedMenuController] setMenuVisible: NO animated:NO];
                     }
     ];

}

-(void)turnOffSearchMode
{
    [UIView animateWithDuration:.5 
                     animations:^{
                         self.locationField.leftViewMode = UITextFieldViewModeNever;
                         self.locationField.rightViewMode = UITextFieldViewModeUnlessEditing;
                         self.bookMarkButton.transform = CGAffineTransformIdentity;
                         self.locationField.transform = CGAffineTransformIdentity;
                         self.cancelButton.transform = CGAffineTransformIdentity;
                         self.searchResultTable.transform = CGAffineTransformIdentity;
                         [self.delegate searchModeOff];
                     }completion:^(BOOL completed){
                         [self.searchResultTable removeFromSuperview];
                         self.searchResultTable = nil;
                         self.listContent = nil;
                         
                     }];
}


#pragma mark - RCSearchEnginePopDelegate
-(void)searchNeedUpdate
{
    NSNumber *setype = [[NSUserDefaults standardUserDefaults]objectForKey:SE_UDKEY];
    UIImage *image = [RCSearchEnginePop imageForSEType:setype.intValue];
    [self.searchEngineButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.searchEnginePop dismissAnimated:YES];
    self.searchEnginePop = nil;
}

#pragma mark - uitextfield delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!self.searchResultTable) {
        self.searchResultTable = [[[UITableView alloc] initWithFrame:CGRectMake(0, 480, 320, 480-88)] autorelease];
        self.searchResultTable.delegate = self;
        self.searchResultTable.dataSource = self;
        [self.superview addSubview:self.searchResultTable];
        [self turnOnSearchMode];
    }
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self loadDataWithText:newString];
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self loadDataWithText:nil];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSURL *url = [NSURL URLWithString:textField.text];
    NSLog(@"url:%@",textField.text);
    // if user didn't enter "http", add it the the url
    if (!url.scheme.length) {
        url = [NSURL URLWithString:[@"http://" stringByAppendingString:textField.text]];
    }
//    if ([url.host hasPrefix:@"www."]) {
//        NSLog(@"www");
//    }
//    if ([url.host hasSuffix:@".com"]) {
//        NSLog(@".com");
//    }
    
    [self.delegate searchCompleteWithUrl:url];
    [textField resignFirstResponder];
    [self turnOffSearchMode];
    return YES;
}


#pragma mark - for search 


-(void)keyBoardAccessoryItemPressed:(UIBarButtonItem*)sender
{
    NSString *string = [sender title];
    if (RCKeyBoardTypePrefix == self.KBAType ) {
        self.locationField.text = [string  stringByAppendingString:self.locationField.text];
        self.KBAType = RCkeyBoardTypeSuffix;
    }else if (RCkeyBoardTypeSuffix == self.KBAType ) {
        self.locationField.text = [self.locationField.text  stringByAppendingString:string];
    }
}

-(void)makeKeyBoardAccessoryWithType:(RCKeyBoardAccessoryType)type
{
    NSArray *array;
    if (RCKeyBoardTypePrefix == type) {
        array = [NSArray arrayWithObjects:@"www.",@"m.",@"3g.",@"wap.", nil];
    }else if (RCkeyBoardTypeSuffix == type) {
        array = [NSArray arrayWithObjects:@".com",@".cn",@".net",@".com.cn", nil];
    }else {
        self.locationField.inputAccessoryView = nil;
        [self.locationField reloadInputViews];
        return;
    }
    
    int i =0;
    for (UIBarButtonItem* item in self.keyBoardButtons) {
        [item setTitle:[array objectAtIndex:i]];
        i++;
    }
    if (!self.locationField.inputAccessoryView) {
        self.locationField.inputAccessoryView = self.keyBoardAccessory;
        [self.locationField reloadInputViews];
    }
}


-(void)setKBAType:(RCKeyBoardAccessoryType)KBAType
{
    if (_KBAType != KBAType) {
        [self makeKeyBoardAccessoryWithType:KBAType];
        _KBAType = KBAType;
    }
}



#pragma mark - uitableview delegate & data source

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.locationField isFirstResponder]) {
        [self.locationField resignFirstResponder];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    NSLog(@"class: %@",[self.listContent class]);
    return [self.listContent count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
    if ([[self.listContent objectAtIndex:indexPath.row] isKindOfClass:[BookmarkObject class]]) {
        BookmarkObject *obj = [self.listContent objectAtIndex:indexPath.row];
        cell.textLabel.text = obj.name;
        cell.detailTextLabel.text = obj.url.absoluteString;
    }else{
        NSString *obj = [self.listContent objectAtIndex:indexPath.row];
        cell.textLabel.text = obj;
        cell.detailTextLabel.text = nil;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSURL *url;
    if ([[self.listContent objectAtIndex:indexPath.row] isKindOfClass:[BookmarkObject class]]) {
        url = [NSURL URLWithString:cell.detailTextLabel.text];
    }else{
        NSString *obj = [self.listContent objectAtIndex:indexPath.row];
        NSNumber *setype = [[NSUserDefaults standardUserDefaults]objectForKey:SE_UDKEY];
        url = [RCSearchEnginePop urlForSEType:setype.intValue WithKeyWords:obj];
    }
    
    [self.delegate searchCompleteWithUrl:url];
    [self.locationField resignFirstResponder];
    [self turnOffSearchMode];
}




@end
