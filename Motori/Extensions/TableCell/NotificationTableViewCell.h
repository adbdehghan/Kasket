//
//  NotificationTableViewCell.h
//  Wash Me
//
//  Created by adb on 11/22/16.
//  Copyright © 2016 Arena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateTimeLabel;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@end
