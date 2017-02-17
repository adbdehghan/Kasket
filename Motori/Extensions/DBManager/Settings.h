//
//  Settings.h
//  Iran Weather
//
//  Created by aDb on 12/20/14.
//  Copyright (c) 2014 aDb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject
{
    NSString *_settingId;
    NSString *_password;
    NSString *accesstoken;
}
@property (nonatomic , copy) NSString *settingId;
@property (nonatomic , copy) NSString *password;
@property (nonatomic , copy) NSString *accesstoken;

@end
