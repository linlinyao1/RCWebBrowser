//
//  RCAddNewViewController.m
//  RCWebBrowser
//
//  Created by imac on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCAddNewViewController.h"
#import "JSONKit.h"
#import "RCAddNewCustomCell.h"
#import "RCRecordData.h"
#import "RCFastLinkObject.h"
#import "RCAddNewManully.h"

typedef enum {
    AddNewSitesCommon = 0,
    AddNewSitesBBS,
    AddNewSitesLife,
    AddNewSitesTool,
    AddNewSitesMan,
    AddNewSitesWoman,
    AddNewSitesShopping,
    AddNewSitesManul,
    
    AddNewSitesCount
} AddNewSites;

typedef enum {
    ManullyAddName = 0,
    ManullyAddURL,
    ManullyAddConfirm,
    
    ManullyAddCount
}ManullyAdd;


@interface RCAddNewViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,retain) IBOutlet UITableView* channelTable;
@property (retain, nonatomic) IBOutlet UITableView *siteTable;

@property (nonatomic,retain) NSMutableArray* listSites;
@property (nonatomic,retain) NSMutableArray* fastLinks;

@property (nonatomic,retain) RCAddNewManully* manulView;
@end

@implementation RCAddNewViewController
@synthesize channelTable = _channelTable;
@synthesize siteTable = _siteTable;
@synthesize listSites = _listSites;
@synthesize fastLinks = _fastLinks;
@synthesize manulView = _manulView;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView *channelBG = [[[UIImageView alloc] initWithImage:RC_IMAGE(@"addNew_channelBG")] autorelease];
    self.channelTable.backgroundView = channelBG;
    UIImageView *siteBG = [[[UIImageView alloc] initWithImage:RC_IMAGE(@"addNew_sitesBG")] autorelease];
    self.siteTable.backgroundView = siteBG;

    
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"webSitesCollection" ofType:@"json"];
    NSString *jsonData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    NSArray *array = [jsonData objectFromJSONString]; 
    self.listSites = [jsonData objectFromJSONString];//[array mutableCopy];
    
    [self.channelTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    NSMutableArray *muArray = [RCRecordData recordDataWithKey:RCRD_FASTLINK];
    self.fastLinks = muArray;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.manulView resignKeyboard];
}
- (void)viewDidUnload
{
    [self setSiteTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)goBack {
    [self dismissModalViewControllerAnimated:YES];
}


-(void)WebSiteSelected:(RCAddNewCustomCellButton*)sender
{
    NSLog(@"left urlString :%@",sender.url);
    BOOL addNew = YES;
    for (RCFastLinkObject* obj in self.fastLinks) {
        if ([obj.url isEqual:sender.url]) {
            [self.fastLinks removeObject:obj];
            addNew = NO;
            break;
        }
    }
    if (addNew) {
        RCFastLinkObject* newObj = [[[RCFastLinkObject alloc] initWithName:sender.nameLabel.text andURL:sender.url andIcon:nil] autorelease];
        newObj.isDefault = YES;
        newObj.iconName = sender.imageName;
        [self.fastLinks addObject:newObj];
    }
    [RCRecordData updateRecord:self.fastLinks ForKey:RCRD_FASTLINK];
    sender.mark = !sender.mark;
}


-(void)refreshMark:(RCAddNewCustomCellButton*)button
{
    BOOL markOrNot = NO;
    for (RCFastLinkObject* obj in self.fastLinks) {
        if ([obj.url isEqual:button.url]) {
            markOrNot = YES;
            break;
        }
    }
    [button setMark:markOrNot];
}




#pragma mark - UITableViewDelegate, UITableViewDataSource


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.siteTable) {
        if ([self.channelTable indexPathForSelectedRow].row == self.listSites.count) {
            return 46;
        }else {
            return 80;
        }
    }else {
        return 46;
    }
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.channelTable) {
        return self.listSites.count+1;
    }else if (tableView == self.siteTable) {
        NSIndexPath *path = [self.channelTable indexPathForSelectedRow];
        if (path.row == self.listSites.count) {
            return ManullyAddCount;
        }else {
            NSDictionary* dic = [self.listSites objectAtIndex:path.row];
            NSArray *array = [dic objectForKey:@"content"];
            return ceil(array.count/2);
        }

    }
    return 0; // error
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.channelTable) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // Configure the cell...
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:RC_IMAGE(@"addNew_channel_selection")] autorelease];
        }
        if (indexPath.row<self.listSites.count) {
            NSDictionary* dic = [self.listSites objectAtIndex:indexPath.row];
            NSString *title = [dic objectForKey:@"title"];
            cell.textLabel.text = title;
        }else {
            cell.textLabel.text = @"手动添加";
        }
        return cell;
    }else if (tableView == self.siteTable) {
        NSIndexPath *path = [self.channelTable indexPathForSelectedRow];
//        if (path.row == self.listSites.count) {
//            static NSString *CellIdentifier = @"Manualy Add";
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//            // Configure the cell...
//            if (!cell) {
//                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//            }
//            switch (indexPath.row) {
//                case ManullyAddName:
//                    cell.textLabel.text = @"常用网站";
//                    break;
//                case ManullyAddURL:
//                    cell.textLabel.text = @"社区论坛";
//                    break;
//                case AddNewSitesLife:
//                    cell.textLabel.text = @"生活旅行";
//                    break;
//            }
//            return cell;
//        }
        
        
        
        static NSString *CellIdentifier = @"Cell";
        RCAddNewCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // Configure the cell...
        if (!cell) {
            cell = [[[RCAddNewCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            [cell.leftIcon addTarget:self action:@selector(WebSiteSelected:) forControlEvents:UIControlEventTouchUpInside];
            [cell.rightIcon addTarget:self action:@selector(WebSiteSelected:) forControlEvents:UIControlEventTouchUpInside];
        }
        NSArray *content = [[self.listSites objectAtIndex:path.row] objectForKey:@"content"];
        
        cell.leftIcon.url = [NSURL URLWithString:[[content objectAtIndex:indexPath.row*2] objectForKey:@"urllink"]];
        cell.leftIcon.nameLabel.text = [[content objectAtIndex:indexPath.row*2] objectForKey:@"urltitle"];
//        [cell.leftIcon setImage:[UIImage imageNamed:[[content objectAtIndex:indexPath.row*2] objectForKey:@"urlico"]] forState:UIControlStateNormal];
        cell.leftIcon.imageName = [[content objectAtIndex:indexPath.row*2] objectForKey:@"urlico"];
        [self refreshMark:cell.leftIcon];

        
        if ((indexPath.row*2+1)<content.count) {
            cell.rightIcon.url = [NSURL URLWithString:[[content objectAtIndex:indexPath.row*2+1] objectForKey:@"urllink"]];
            cell.rightIcon.nameLabel.text = [[content objectAtIndex:indexPath.row*2+1] objectForKey:@"urltitle"];
//            [cell.rightIcon setImage:[UIImage imageNamed:[[content objectAtIndex:indexPath.row*2+1] objectForKey:@"urlico"]] forState:UIControlStateNormal];
            cell.rightIcon.imageName = [[content objectAtIndex:indexPath.row*2+1] objectForKey:@"urlico"];
            [self refreshMark:cell.rightIcon];
        }else {
            cell.rightIcon = nil;
        }
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.channelTable) {
        if (indexPath.row == self.listSites.count) {
            if (!self.manulView) {
                RCAddNewManully *view = [[RCAddNewManully alloc] init];
                view.frame = self.siteTable.frame;
                self.manulView = view;
                [view release];
            }
            [self.view addSubview:self.manulView];
        }else {
            [self.manulView removeFromSuperview];
            [self.siteTable reloadData];
        }
    }else {
        NSLog(@"site table seledted");
    }

}







- (void)dealloc {
    [_siteTable release];
    [_channelTable release];
    [_listSites release];
    [_fastLinks release];
    [_manulView release];

    [super dealloc];
}
@end
