//
//  OrderHistory.h
//  Wash Me
//
//  Created by adb on 11/14/16.
//  Copyright © 2016 Arena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderHistory : NSObject
@property (nonatomic,strong)NSString *Fullname;
@property (nonatomic,strong)NSString *Address;
@property (nonatomic,strong)NSString *OrderTime;
@property (nonatomic,strong)NSString *Car;
@property (nonatomic,strong)NSString *WashType;
@property (nonatomic,strong)NSString *CurrentPage;
@property (nonatomic,strong)NSString *TotalPage;
@property (nonatomic,strong)NSString *Price;
@property (nonatomic,strong)NSString *lat;
@property (nonatomic,strong)NSString *lon;
@end
