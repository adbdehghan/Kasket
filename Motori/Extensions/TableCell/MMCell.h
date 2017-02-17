//
//  MMCell.h
//  MMTableCellAnimation
//
//  Created by muku on 12/10/14.
//  Copyright (c) 2014 com.muku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mmimageView;
@property (weak, nonatomic) IBOutlet UIImageView *backimageView;
@property (weak, nonatomic) IBOutlet UILabel *mmlabel;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scorePerPic;
@property (weak, nonatomic) IBOutlet UIButton *coinButton;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@end

