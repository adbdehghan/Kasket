//
//  HistoryTableViewCell.h
//  Wash Me
//
//  Created by adb on 11/17/16.
//  Copyright © 2016 Arena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *fullnameLabel;
@property (nonatomic, weak) IBOutlet UILabel *fullnameLabelDetail;
@property (nonatomic, weak) IBOutlet UILabel *dateTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateTimeLabelDetail;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *quickAddressLabel;
@property (nonatomic, weak) IBOutlet UILabel *destinationAddressLabel;
@property (nonatomic, weak) IBOutlet UILabel *quickDestinationAddressLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabelDetail;
@property (nonatomic, weak) IBOutlet UILabel *sourceAddressInfoLabel;
@property (nonatomic, weak) IBOutlet UILabel *destinationAddressInfoLabel;
@property (nonatomic, weak) IBOutlet UILabel *roundTripLabel;
@property (nonatomic, weak) IBOutlet UILabel *payinDestinationLabel;
@property (nonatomic, weak) IBOutlet UILabel *orderTypeLabel;
@property (nonatomic, weak) IBOutlet UILabel *paymentStatusLabel;
@property (nonatomic, weak) IBOutlet UILabel *orderNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *orderStatus;
@property (nonatomic, weak) IBOutlet UIView *background;
@property (nonatomic, weak) IBOutlet UIImageView *mapView;
@property (nonatomic, weak) IBOutlet UIButton *emailButton;
@property (nonatomic, weak) IBOutlet UIView *layerView;
@end
