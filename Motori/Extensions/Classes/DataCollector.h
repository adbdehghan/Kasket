//
//  DataCollector.h
//  Motori
//
//  Created by adb on 2/14/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCollector : NSObject
+(DataCollector *)sharedInstance;
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
@end
