//
//  TransactionTableViewCell.h
//  Wash Me
//
//  Created by adb on 11/22/16.
//  Copyright © 2016 Arena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *descLabel;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIImageView *statusImageView;
@end
