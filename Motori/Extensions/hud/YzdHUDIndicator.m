//
//  YzdHUDIndicator.m
//  YzdHUD
//
//  Created by ShineYang on 13-12-6.
//  Copyright (c) 2013年 YangZhiDa. All rights reserved.
//

#import "YzdHUDIndicator.h"


static YzdHUDIndicator *_shareHUDView = nil;
@implementation YzdHUDIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(YzdHUDIndicator *)shareHUDView{
    if (!_shareHUDView) {
        
//        _activityIndicator = [
//
        
        _shareHUDView = [MBSpinningCircle circleWithSize:NSSpinningCircleSizeLarge color:[UIColor colorWithRed:0/255.0f green:162/255.0f blue:252/255.0f alpha:1]];
        
        CGRect circleRect = _shareHUDView.frame;
//                circleRect.origin = CGPointMake(self.bounds.size.width/2.0 - circleRect.size.width/2.0, -5);
                _shareHUDView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                _shareHUDView.frame = circleRect;
                _shareHUDView.circleSize = NSSpinningCircleSizeLarge;
                _shareHUDView.hasGlow = YES;
                _shareHUDView.isAnimating = YES;
                _shareHUDView.speed = 0.55;
                
    }
    return _shareHUDView;
}

@end
