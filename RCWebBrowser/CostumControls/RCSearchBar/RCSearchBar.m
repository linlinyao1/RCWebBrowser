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
#import "QuartzCore/QuartzCore.h"

@interface RCSearchBar ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,RCSearchEnginePopDelegate>
@property (nonatomic,retain) UIButton *searchEngineButton;
@property (nonatomic,retain) UIButton *cancelButton;
@property (nonatomic,retain) UIToolbar *keyBoardAccessory;
@property (nonatomic,retain) NSArray *keyBoardButtons;
@property (nonatomic,retain) UITableView *searchResultTable;
@property (nonatomic,retain) NSMutableArray *listContent;			// The master content.
@property (nonatomic,retain) NSMutableArray *historys;
@property (nonatomic,retain) UIImageView *progressBar;
@property (nonatomic,assign) NSTimer *progressTimer;
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


-(void)handleProgressTimer:(NSTimer*)sender
{
    if (!self.progressTimer) {
        [sender invalidate];
        return;
    }
    
    CGFloat progress = floorf(self.locationField.loadingProgress.floatValue*1000)/1000;
    if (progress <=0) {
        self.locationField.loadingProgress = @0;
        [sender invalidate];
        self.progressTimer = nil;
        return;
    }else if (progress > 1){
        self.locationField.loadingProgress = @1;
    }else if (progress == 1){
        self.locationField.loadingProgress = @0;
    }else if (progress < 0.5) {
        self.locationField.loadingProgress = @(0.012 + self.locationField.loadingProgress.floatValue);
    }else if (progress == 0.51){
        [sender invalidate];
        self.locationField.loadingProgress = @(0.01 + self.locationField.loadingProgress.floatValue);
        self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleProgressTimer:) userInfo:nil repeats:NO];
    }else if (progress < 0.82){
        self.locationField.loadingProgress = @(0.01 + self.locationField.loadingProgress.floatValue);
        self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(handleProgressTimer:) userInfo:nil repeats:YES];
    }
    
}


-(void)startLoadingProgress
{
    if(self.progressTimer) {
        self.progressTimer = nil;
    }
    self.locationField.loadingProgress = @0.15;
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(handleProgressTimer:) userInfo:nil repeats:YES];
    
//    if (!self.progressBar) {
//        self.progressBar = [[[UIImageView alloc] initWithImage:RC_IMAGE(@"search_progressbar")] autorelease];
//        self.progressBar.frame = CGRectOffset(self.locationField.bounds, -self.locationField.bounds.size.width, 0);
//        self.progressBar.userInteractionEnabled= NO;
//    }
//    [self.locationField addSubview:self.progressBar];
//
//    self.progressBar.transform = CGAffineTransformMakeTranslation(self.progressBar.frame.size.width*0.15, 0);
//    
//    [UIView animateWithDuration:3
//                          delay:0
//                        options:0//UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction
//                     animations:^{
//                         self.progressBar.transform = CGAffineTransformMakeTranslation(self.progressBar.frame.size.width*0.5, 0);
//                     } completion:^(BOOL finished) {
//                         if (finished) {
//                             [UIView animateWithDuration:3
//                                                   delay:1
//                                                 options:0//UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction
//                                              animations:^{
//                                                  self.progressBar.transform = CGAffineTransformMakeTranslation(self.progressBar.frame.size.width*0.9, 0);
//                                              } completion:^(BOOL finished) {
//
//                                              }];
//                         }
//                     }];
    
}
-(void)stopLoadProgress
{
//    [UIView animateWithDuration:.1
//                          delay:0
//                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction
//                     animations:^{
//                         self.progressBar.transform = CGAffineTransformMakeTranslation(self.progressBar.frame.size.width, 0);
//                     } completion:^(BOOL finished) {
//                         self.progressBar.transform = CGAffineTransformIdentity;
//                         [self.progressBar removeFromSuperview];
//                     }];
}


-(void)removePregress
{
    [self.progressBar removeFromSuperview];
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



-(void)bookMarkButtonPressed:(UIButton*)sender
{
    
    // Toggle popTipView when a standard UIButton is pressed
    if (nil == self.bookMarkPop) {
        RCBookMarkPop *pop = [[[RCBookMarkPop alloc] initWithFrame:CGRectMake(0, 0, 160, 70)] autorelease];
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
        RCSearchEnginePop *pop = [[[RCSearchEnginePop alloc] initWithFrame:CGRectMake(0, 0, 100, 250) style:UITableViewStylePlain] autorelease];
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
    self.backgroundColor = [UIColor colorWithPatternImage:RC_IMAGE(@"searchBarBG")];
    
    //bookmark button
    UIButton *bookMarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bookMarkButton.frame =CGRectMake(5, 5, 38, 34);
    [bookMarkButton setImage:RC_IMAGE(@"search_addfav_nomal") forState:UIControlStateNormal];
    [bookMarkButton setImage:RC_IMAGE(@"search_addfav_disable") forState:UIControlStateDisabled];
    [bookMarkButton addTarget:self action:@selector(bookMarkButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:bookMarkButton];
    self.bookMarkButton = bookMarkButton;
    
    // url input
//    UITextField *locationField = [[UITextField alloc] initWithFrame:CGRectMake(48,5,266,33)];
    RCUrlInputField *locationField = [[RCUrlInputField alloc] initWithFrame:CGRectMake(48,5,266,33)];

    locationField.borderStyle = UITextBorderStyleNone;

    locationField.layer.cornerRadius = 5;
    locationField.background = RC_IMAGE(@"searchBG@2x");
    locationField.delegate = self;
    locationField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    locationField.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];
    locationField.textAlignment = UITextAlignmentLeft;
    locationField.font = [UIFont fontWithName:@"Helvetica" size:15];
    locationField.autocorrectionType = UITextAutocorrectionTypeNo;
    locationField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    locationField.clearsOnBeginEditing = NO;
    locationField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    locationField.keyboardType = UIKeyboardTypeURL;
    locationField.returnKeyType = UIReturnKeyGo;
    locationField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:locationField];
    self.locationField = locationField;

    
    
    // progressBar
//    YLProgressBar *progressBar = [[YLProgressBar alloc] initWithFrame:locationField.bounds];
//    progressBar.userInteractionEnabled = NO;
//    self.progressBar = progressBar;
    
    
    //reload/stop button
    UIButton *stopReloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stopReloadButton.bounds = CGRectMake(0, 0, 25, 25);
    [stopReloadButton setImage:RC_IMAGE(@"search_reload_nomal") forState:UIControlStateNormal];
    [stopReloadButton setImage:RC_IMAGE(@"search_reload_pressed") forState:UIControlStateHighlighted];
    stopReloadButton.showsTouchWhenHighlighted = NO;
    [stopReloadButton addTarget:self action:@selector(reloadOrStop:) forControlEvents:UIControlEventTouchUpInside];
    locationField.rightView = stopReloadButton;
    locationField.rightViewMode = UITextFieldViewModeUnlessEditing;
    self.stopReloadButton = stopReloadButton;
    
    // searchEngineButton
    UIView *searchEngineButtonBG = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 28)] autorelease];
    
    UIButton *searchEngineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchEngineButton.frame = CGRectMake(0, 0, 28, 28);
    [searchEngineButton addTarget:self action:@selector(searchEngineButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    NSNumber *setype = [[NSUserDefaults standardUserDefaults]objectForKey:SE_UDKEY];
//    UIImage *image = [RCSearchEnginePop imageForSEType:setype.intValue];
//    [searchEngineButton setBackgroundImage:image forState:UIControlStateNormal];
    [searchEngineButtonBG addSubview:searchEngineButton];
    
//    UIImageView* notch = [[[UIImageView alloc] initWithImage:RC_IMAGE(@"searchEngineNotch")] autorelease];
    UIButton *notch = [UIButton buttonWithType:UIButtonTypeCustom];
    notch.frame = CGRectMake(28, 8, 12, 12);
    [notch setBackgroundImage:RC_IMAGE(@"searchEngineNotch") forState:UIControlStateNormal];
    [notch addTarget:self action:@selector(searchEngineButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [searchEngineButtonBG addSubview:notch];
    
    self.locationField.leftView = searchEngineButtonBG;//searchEngineButton;
    self.locationField.leftViewMode = UITextFieldViewModeNever;
    self.searchEngineButton = searchEngineButton;
    
    //cancelButton
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(320, 6, 48, 32);
    [cancelButton setImage:RC_IMAGE(@"search_cancle") forState:UIControlStateNormal];
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

-(void)dealloc
{
    [_locationField release];
    [_searchEngineButton release];
    [_cancelButton release];
    [_keyBoardAccessory release];
    [_keyBoardButtons release];
    [_searchResultTable release];
    [_listContent release];
    [_historys release];
    [_progressBar release];
    [_stopReloadButton release];
    [_bookMarkPop release];
    [_searchEnginePop release];
    [_searchResultTable release];
    [_historys release];
    [super dealloc];
   
}



-(RCKeyBoardAccessoryType)checkInputContent:(NSString*)text
{
    //check if contain any chinese
    for(int i=0; i< [text length];i++){
        int a = [text characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
            return RCKeyBoardTypeNone;
    }
    
    NSRange foundObj=[text rangeOfString:@"." options:NSCaseInsensitiveSearch];
    if(foundObj.length>0) { 
        return RCkeyBoardTypeSuffix;
    } else {
        return RCKeyBoardTypePrefix;
    }
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
            if (data) {
                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);//
                NSString* string = [[[NSString alloc] initWithData:data encoding:enc] autorelease];
                if (string) {
                    string = [string stringByReplacingCharactersInRange:[string rangeOfString:@"window.baidu.sug("] withString:@""];
                    string = [string stringByReplacingCharactersInRange:[string rangeOfString:@");"] withString:@""];
                    string = [string stringByReplacingOccurrencesOfString:@"q:" withString:@"\"q\":"];
                    string = [string stringByReplacingOccurrencesOfString:@"p:" withString:@"\"p\":"];
                    string = [string stringByReplacingOccurrencesOfString:@"s:" withString:@"\"s\":"];
                    NSDictionary *jsonDic = [string mutableObjectFromJSONString];
                    NSArray *baiduArray = [jsonDic objectForKey:@"s"];
                    [tempArray addObjectsFromArray:baiduArray];
                }
                
                
;
            }

        }  
        dispatch_async(dispatch_get_main_queue(), ^{
            //                [self.listContent removeAllObjects];
            self.KBAType = [self checkInputContent:text];
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
    self.locationField.placeholder = @"请输入网址或者搜索关键字…";
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
    NSNumber *setype = [[NSUserDefaults standardUserDefaults]objectForKey:SE_UDKEY];
    UIImage *image = [RCSearchEnginePop imageForSEType:setype.intValue];
    [self.searchEngineButton setBackgroundImage:image forState:UIControlStateNormal];
    [UIView animateWithDuration:.5 
                     animations:^{
                         self.locationField.leftViewMode = UITextFieldViewModeAlways;
                         self.locationField.rightViewMode = UITextFieldViewModeNever;
                         self.bookMarkButton.transform = CGAffineTransformMakeTranslation(-CGRectGetMaxX(self.bookMarkButton.frame), 0);
                         self.locationField.transform = CGAffineTransformMakeTranslation(-45, 0);
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
        self.searchResultTable = [[[UITableView alloc] initWithFrame:CGRectMake(0, 480, 320, 480-82)] autorelease];
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
    NSString* string = textField.text;
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:string];
    NSLog(@"url:%@",textField.text);
    // if user didn't enter "http", add it the the url
    if (!url.scheme.length) {
        url = [NSURL URLWithString:[@"http://" stringByAppendingString:textField.text]];
    }
    
    BOOL valid = NO;
    if (url.host.length) {
        NSString * regex        =  @"^([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?$";//@"^(\\w)+(\\.)+(\\w)+$";//
        NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if ([pred evaluateWithObject:url.host]) {
            NSLog(@"valid url");
            valid = YES;
        }else{
            NSLog(@"invalid url");
        }
    }
    if (valid) {
        
    }else{
        NSNumber *setype = [[NSUserDefaults standardUserDefaults]objectForKey:SE_UDKEY];
        NSURL *searchURL = [RCSearchEnginePop urlForSEType:setype.intValue WithKeyWords:textField.text];
        url = searchURL;
    }
    
//    NSString * regex        = @"^http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?$";
//    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    if (![pred evaluateWithObject:url.absoluteString]) {
//        NSNumber *setype = [[NSUserDefaults standardUserDefaults]objectForKey:SE_UDKEY];
//        NSURL *searchURL = [RCSearchEnginePop urlForSEType:setype.intValue WithKeyWords:textField.text];
//        url = searchURL;
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
