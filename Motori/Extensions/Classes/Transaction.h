//
//  Transaction.h
//  Wash Me
//
//  Created by adb on 11/22/16.
//  Copyright © 2016 Arena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transaction : NSObject
@property (nonatomic,strong)NSString *Amount;
@property (nonatomic,strong)NSString *Time;
@property (nonatomic,strong)NSString *Desc;
@property (nonatomic,strong)NSString *IsIncrease;
@end
