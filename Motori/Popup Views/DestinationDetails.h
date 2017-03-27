//
//  DestinationDetails.h
//  Motori
//
//  Created by adb on 2/15/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "BEMCheckBox.h"

@class DestinationDetails;
@protocol DestinationDelegate <NSObject>
- (void)ForwardClicked;
@end

@interface DestinationDetails : UIView <BEMCheckBoxDelegate>
{
    UITextField *bellTextField;
    UITextField *plateTextField;
    UITextField *phoneTextField;
    UITextField *nameTextField;
    UILabel *favoriteLabel;
    BOOL isAddressSave;
}

@property(nonatomic,strong) UILabel *addressLabel;
@property(nonatomic,strong) UILabel *plateLabel;
@property(nonatomic,strong) UILabel *alertLabel;
@property (nonatomic, weak) id <DestinationDelegate> delegate;
@end
