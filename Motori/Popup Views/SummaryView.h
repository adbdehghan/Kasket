//
//  SummaryView.h
//  Motori
//
//  Created by adb on 2/17/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"

@class SummaryView;
@protocol SummaryDelegate <NSObject>
- (void)ForwardClicked;
@end

@interface SummaryView : UIView
{
    UITextField *bellTextField;
    UITextField *plateTextField;
    
}

@property(nonatomic,strong) UILabel *addressLabel;
@property(nonatomic,strong) UILabel *plateLabel;
@property(nonatomic,strong) UILabel *alertLabel;
@property (nonatomic, weak) id <SummaryDelegate> delegate;
