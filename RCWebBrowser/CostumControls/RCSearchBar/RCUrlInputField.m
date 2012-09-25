//
//  RCUrlInputField.m
//  RCWebBrowser
//
//  Created by imac on 12-8-6.
//
//

#import "RCUrlInputField.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexValue.h"

@implementation RCUrlInputField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.layer.cornerRadius = 6.0f;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithHexValue:@"9f9fa6"].CGColor;

    }
    return self;
}


- (void)setLoadingProgress:(NSNumber*)loadingProgress {
    if (loadingProgress.floatValue < 0.0f) {
        _loadingProgress = [NSNumber numberWithFloat:0];
        return;
    }
    if (loadingProgress.floatValue > 1.0f) {
        _loadingProgress = [NSNumber numberWithFloat:1];
        return;
    }
    
    _loadingProgress = loadingProgress;
    
    CGRect progressRect = CGRectZero;
    CGSize progressSize = CGSizeMake(_loadingProgress.floatValue * CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    progressRect.size = progressSize;
    
    // Create the background image
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, self.bounds);
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithPatternImage:RC_IMAGE(@"search_progressbar")].CGColor);//[UIImage imageNamed:@"urlField_PB_Portrait"]
    CGContextFillRect(context, progressRect);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [super setBackground:image];
}

- (void)setBackground:(UIImage *)background {
    // NO-OP
}

- (UIImage *)background {
    return nil;
}

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
