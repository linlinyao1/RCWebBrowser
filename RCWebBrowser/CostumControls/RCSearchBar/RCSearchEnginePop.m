//
//  RCSearchEnginePop.m
//  RCWebBrowser
//
//  Created by imac on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCSearchEnginePop.h"

@interface RCSearchEnginePop ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) NSArray *listContent;
@end


@implementation RCSearchEnginePop
@synthesize listContent = _listContent;
@synthesize notification = _notification;

+(UIImage *)imageForSEType:(SETypes)type
{
    NSString *imageName = nil;
    switch (type) {
        case SETypeBaidu:
            imageName = @"icon_search_baidu2";
            break;
        case SETypeGoogle:  
            imageName = @"icon_search_google2";
            break;
        case SETypeSoso:  
            imageName = @"icon_search_soso";
            break;
        case SETypeEasou:  
            imageName = @"icon_search_easou";
            break;
        case SETypeYicha:  
            imageName = @"icon_search_yicha";
            break;
        default:
            break;
    }
    return [UIImage imageNamed:imageName];
}

+(NSString*)titleForSEType:(SETypes)type
{
    NSString *title = nil;
    switch (type) {
        case SETypeBaidu:
            title = @"百度";
            break;
        case SETypeGoogle:  
            title = @"谷歌";
            break;
        case SETypeSoso:  
            title = @"搜搜";
            break;
        case SETypeEasou:  
            title = @"宜搜";
            break;
        case SETypeYicha:  
            title = @"易查";
            break;
    }
    return title;
}



+(NSURL *)urlForSEType:(SETypes)type WithKeyWords:(NSString *)keywords
{
//    百度：http://m.baidu.com/s?tn=site888_pg&word=
//    谷歌：http://www.google.com.hk/search?client=aff-9991&q=
//    搜搜：http://wap.soso.com/sweb/search.jsp?unc=s300000_1&cid=s300000_1&key=
//    宜搜：http://ad2.easou.com:8080/j10ad/ea2.jsp?cid=bicn3516_48168_D_1&channel=11&key=
//    易查：http://yicha.cn/union/u.jsp?p=page&site=2145958760&key=
    NSString *string = nil;
    switch (type) {
        case SETypeBaidu:
            string = @"http://m.baidu.com/s?tn=site888_pg&word=";
            break;
        case SETypeGoogle:  
            string = @"http://www.google.com.hk/search?client=aff-9991&q=";
            break;
        case SETypeSoso:  
            string = @"http://wap.soso.com/sweb/search.jsp?unc=s300000_1&cid=s300000_1&key=";
            break;
        case SETypeEasou:  
            string = @"http://ad2.easou.com:8080/j10ad/ea2.jsp?cid=bicn3516_48168_D_1&channel=11&key=";
            break;
        case SETypeYicha:  
            string = @"http://yicha.cn/union/u.jsp?p=page&site=2145958760&key=";
            break;
        default:
            break;
    }
    string = [string stringByAppendingString:keywords];
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:string];
    NSLog(@"url: %@",url);
    
    return [NSURL URLWithString:string];
}


-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        self.dataSource = self;
        self.delegate = self;
        self.listContent = [NSArray arrayWithObjects:@"百度",@"谷歌",@"搜搜",@"宜搜",@"易查", nil];
        self.rowHeight = 50;
    }
    return self;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return SETypeCount;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
    cell.textLabel.text = [RCSearchEnginePop titleForSEType:indexPath.row];// [self.listContent objectAtIndex:indexPath.row];
    cell.imageView.image = [RCSearchEnginePop imageForSEType:indexPath.row];    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:indexPath.row] forKey:SE_UDKEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.notification searchNeedUpdate];
}

-(void)dealloc
{
    [_listContent release];
    [super dealloc];
}

@end
