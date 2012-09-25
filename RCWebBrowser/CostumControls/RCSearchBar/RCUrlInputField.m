//
//  RCUrlInputField.m
//  RCWebBrowser
//
//  Created by imac on 12-8-6.
//
//

#import "RCUrlInputField.h"

@implementation RCUrlInputField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(CGRect)textRectForBounds:(CGRect)bounds
{
    if (self.leftViewMode == UITextFieldViewModeAlways) {
        return CGRectMake(self.leftView.bounds.size.width, bounds.origin.y, bounds.size.width-self.rightView.bounds.size.width, bounds.size.height);
    }else{
        return CGRectMake(5, bounds.origin.y, bounds.size.width-self.rightView.bounds.size.width, bounds.size.height);
    }
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

@end
