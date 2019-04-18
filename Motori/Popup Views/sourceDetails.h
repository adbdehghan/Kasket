//
//  sourceDetails.h
//  Motori
//
//  Created by aDb on 2/12/17.
//  Copyright © 2017 Arena. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "BEMCheckBox.h"

@class sourceDetails;
@protocol sourceDelegate <NSObject>
- (void)ForwardClicked;
@end

@interface sourceDetails : UIView <BEMCheckBoxDelegate>
{
    UITextField *bellTextField;
    UITextField *plateTextField;
    UILabel *favoriteLabel;
    BOOL isAddressSave;
}

@property(nonatomic,strong) UILabel *addressLabel;
@property(nonatomic,strong) UILabel *plateLabel;
@property(nonatomic,strong) UILabel *alertLabel;
@property (nonatomic, weak) id <sourceDelegate> delegate;

@end
