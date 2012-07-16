//
//  RCFastLinkView.m
//  RCWebBrowser
//
//  Created by imac on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCFastLinkView.h"
#import "RCFastLinkObject.h"


static RCFastLinkView *_fastLinkView;

@implementation RCFastLinkView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blueColor];
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSData * fastlinks = [defaults objectForKey:@"fastlinks"];
        NSMutableArray *fastlinksArray;
        
        if (fastlinks) {
            fastlinksArray = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:fastlinks]];
            RCFastLinkObject *flObj = [fastlinksArray objectAtIndex:[fastlinksArray count]-1];        
            UIImage *image = flObj.icon;
            UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)] autorelease];
            imageView.backgroundColor = [UIColor whiteColor];
            imageView.image = image;
            [self addSubview:imageView];
        } 
 
    }
    return self;
}

+(id)defaultPage
{
    if (!_fastLinkView) {
        _fastLinkView = [[RCFastLinkView alloc] initWithFrame:CGRectMake(0, 0, 320, 328)];
    }
    return _fastLinkView;
}





@end
