//
//  Destination.h
//  Motori
//
//  Created by aDb on 3/25/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Destination : NSObject
@property (nonatomic,strong) NSString *destinationId;
@property (nonatomic,strong) NSString *destinationLat;
@property (nonatomic,strong) NSString *destinationLon;
@property (nonatomic,strong) NSString *destinationAddress;
@property (nonatomic,strong) NSString *destinationBell;
@property (nonatomic,strong) NSString *destinationPlate;
@property (nonatomic,strong) NSString *destinationPhoneNumber;
@property (nonatomic,strong) NSString *destinationFullName;
@end
