//
//  LMMainNavigationController.h
//  LMSideBarControllerDemo
//
//  Created by LMinh on 10/11/15.
//  Copyright © 2015 LMinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"

@interface LMMainNavigationController : UINavigationController

@property (nonatomic, strong) MapViewController *homeViewController;

- (void)showHomeViewController;

- (void)showOthersViewController;

@end
