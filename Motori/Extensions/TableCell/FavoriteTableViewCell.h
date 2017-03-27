//
//  FavoriteTableViewCell.h
//  Motori
//
//  Created by aDb on 3/27/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *plateLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *bellLabel;
@property (nonatomic, weak) IBOutlet UILabel *phoneNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *fullNameLabel;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@end
