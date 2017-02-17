//
//  DataCollector.m
//  Motori
//
//  Created by adb on 2/14/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import "DataCollector.h"

@implementation DataCollector
@synthesize sourceBell;
@synthesize sourcePlate;
@synthesize destinationBell;
@synthesize destinationPlate;
@synthesize destinationPhoneNumber;

-(instancetype)init
{
    if (self = [super init])
    {
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static DataCollector *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataCollector alloc] init];
        
    });
    return sharedInstance;
}

@end
