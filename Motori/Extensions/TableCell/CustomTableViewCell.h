//
//  CustomTableViewCell.h
//  2x2
//
//  Created by aDb on 3/2/15.
//  Copyright (c) 2015 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateTimeLabel;
@property (nonatomic, weak) IBOutlet UIView *background;
@property (nonatomic, weak) IBOutlet UIView *dateBackground;
@end
