//
//  OrderHistory.h
//  Wash Me
//
//  Created by adb on 11/14/16.
//  Copyright © 2016 Arena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderHistory : NSObject
@property (nonatomic,strong) NSString *sourceLat;
@property (nonatomic,strong) NSString *sourceLon;
@property (nonatomic,strong) NSString *sourceAddress;
@property (nonatomic,strong) NSString *sourceBell;
@property (nonatomic,strong) NSString *sourcePlate;
@property (nonatomic,strong) NSString *destinationLat;
@property (nonatomic,strong) NSString *destinationLon;
@property (nonatomic,strong) NSString *destinationAddress;
@property (nonatomic,strong) NSString *destinationBell;
@property (nonatomic,strong) NSString *destinationPlate;
@property (nonatomic,strong) NSString *destinationPhoneNumber;
@property (nonatomic,strong) NSString *destinationFullName;
@property (nonatomic,strong) NSString *orderType;
@property (nonatomic,strong) NSString *haveReturn;
@property (nonatomic,strong) NSString *payInDestination;
@property (nonatomic,strong) NSString *offCode;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *orderTime;
@end
