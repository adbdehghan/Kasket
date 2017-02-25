//
//  KasketView.h
//  Motori
//
//  Created by aDb on 2/25/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"

@class KasketView;
@protocol KasketDelegate <NSObject>
- (void)CancelClicked;
@end

@interface KasketView : UIView
{
    UIView *topView;
    
}
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *plate;
@property (nonatomic, weak) id <KasketDelegate> delegate;

@end
