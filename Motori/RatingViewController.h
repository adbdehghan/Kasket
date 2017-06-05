//
//  RatingViewController.h
//  Motori
//
//  Created by adb on 6/5/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *kasketNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendRatingButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;

@end
