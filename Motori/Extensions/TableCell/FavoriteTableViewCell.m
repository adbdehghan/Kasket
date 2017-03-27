//
//  FavoriteTableViewCell.m
//  Motori
//
//  Created by aDb on 3/27/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import "FavoriteTableViewCell.h"

@implementation FavoriteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *subview in self.subviews) {
        for(UIView *childView in subview.subviews){
            if ([childView isKindOfClass:[UIButton class]]) {
                UIButton *child = childView;
                childView.backgroundColor = [UIColor groupTableViewBackgroundColor];
                child.titleLabel.font = [UIFont fontWithName:@"IRANSans" size:15];
                child.titleLabel.textColor = [UIColor clearColor];
                [child setTitleColor:[UIColor clearColor] forState:UIControlStateFocused];
                [child setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
                [child setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
                child.imageView.contentMode = UIViewContentModeScaleAspectFit;
                [child setImage:[UIImage imageNamed:@"Trash.png"] forState:UIControlStateNormal];
            }
        }
    }
}- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
