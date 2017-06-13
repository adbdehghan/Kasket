//
//  SummaryView.h
//  Motori
//
//  Created by adb on 2/17/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "LUNSegmentedControl.h"
#import "DataDownloader.h"
#import "Settings.h"
#import "DBManager.h"
#import "DGActivityIndicatorView.h"
#import "CNPPopupController.h"
#import "BEMCheckBox.h"

@class SummaryView;
@protocol SummaryDelegate <NSObject>
- (void)ForwardClicked;
@end

@interface SummaryView : UIView<LUNSegmentedControlDataSource, LUNSegmentedControlDelegate,BEMCheckBoxDelegate>
{
    UITextField *bellTextField;
    UITextField *plateTextField;
    UIView *priceCircleView;
    UIView *timeCircleView;
    LUNSegmentedControl *segmentedControl;
    LUNSegmentedControl *paymentSegmentedControl;
    LUNSegmentedControl *insuranceSegmentedControl;
    NSString *price;
    UILabel *priceLabel;
    UILabel *timeLabel;
    DGActivityIndicatorView *timeActivityIndicatorView;
    DGActivityIndicatorView *priceActivityIndicatorView;
    int time;
    CNPPopupButton *mainButton;
    CAGradientLayer *gradient;
    UIView *mainView;
    UILabel *insuranceLabel;
}

@property(nonatomic,strong) UILabel *addressLabel;
@property(nonatomic,strong) UILabel *plateLabel;
@property(nonatomic,strong) UILabel *alertLabel;
@property (nonatomic, weak) id <SummaryDelegate> delegate;
@property (strong, nonatomic) DataDownloader *getData;
@end
