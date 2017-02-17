//
//  sourceDetails.h
//  Motori
//
//  Created by aDb on 2/12/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"

@class sourceDetails;
@protocol sourceDelegate <NSObject>
- (void)ForwardClicked;
@end

@interface sourceDetails : UIView
{
    UITextField *bellTextField;
    UITextField *plateTextField;

}

@property(nonatomic,strong) UILabel *addressLabel;
@property(nonatomic,strong) UILabel *plateLabel;
@property(nonatomic,strong) UILabel *alertLabel;
@property (nonatomic, weak) id <sourceDelegate> delegate;
@end
