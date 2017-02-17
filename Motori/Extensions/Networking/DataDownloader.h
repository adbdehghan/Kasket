//
//  DataDownloader.h
//  2x2
//
//  Created by aDb on 2/25/15.
//  Copyright (c) 2015 aDb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataDownloader : NSObject

typedef void (^RequestCompleteBlock) (BOOL wasSuccessful,NSMutableDictionary *recievedData);
typedef void (^ImageRequestCompleteBlock) (BOOL wasSuccessful,UIImage *image);

- (void)requestVerificationCode:(NSString *)params withCallback:(RequestCompleteBlock)callback;

- (void)RegisterMember:(NSString *)param1 Param2:(NSString*)param2 Email:(NSString*)email Password:(NSString*)password withCallback:(RequestCompleteBlock)callback;

- (void)RegisterProfile:(NSString*)token  Name:(NSString*)name LastName:(NSString*)lastName  withCallback:(RequestCompleteBlock)callback;

- (void)GetVersion:(NSString *)params withCallback:(RequestCompleteBlock)callback;

- (void)GetPrice:(NSString*)token Car:(NSString*)car WashType:(NSString*)washType Wax:(NSString*)wax  withCallback:(RequestCompleteBlock)callback;

- (void)Order:(NSString*)token Car:(NSString*)car WashType:(NSString*)washType Wax:(NSString*)wax Lat:(NSString*)lat Lon:(NSString*)lon Day:(NSString*)day Hour:(NSString*)hour Price:(NSString*)price Plate:(NSString*)plate Address:(NSString*)address OffCode:(NSString*)offCode withCallback:(RequestCompleteBlock)callback;

- (void)OrderHistory:(NSString*)token Page:(NSString*)page withCallback:(RequestCompleteBlock)callback;

- (void)Transactions:(NSString*)token Page:(NSString*)page withCallback:(RequestCompleteBlock)callback;

- (void)Notifications:(NSString*)token Page:(NSString*)page withCallback:(RequestCompleteBlock)callback;

- (void)CheckCleaner:(NSString*)token OrderId:(NSString*)orderId withCallback:(RequestCompleteBlock)callback;

- (void)CancelOrder:(NSString*)token OrderId:(NSString*)orderId withCallback:(RequestCompleteBlock)callback;

- (void)OffCode:(NSString*)token Code:(NSString*)code withCallback:(RequestCompleteBlock)callback;

- (void)GetSummarize:(NSString *)phoneNumber Password:(NSString*)password withCallback:(RequestCompleteBlock)callback;

- (void)GetProfilePicInfo:(NSString *)token  withCallback:(RequestCompleteBlock)callback;

- (void)SetSetiing:(NSString *)token Name:(NSString*)name LastName:(NSString*)lastName Gender:(NSString*)gender city:(NSString*)city birthdayDay:(NSString*) birthdayDay birhtdayMonth:(NSString*)birhtdayMonth birhtdayYear:(NSString*)birhtdayYear      withCallback:(RequestCompleteBlock)callback;

- (void)GetSetting:(NSString *)token withCallback:(RequestCompleteBlock)callback;

- (void)Invite:(NSString *)phoneNumber Password:(NSString*)password contactNumber:(NSString*)contactNumber withCallback:(RequestCompleteBlock)callback;

- (void)GetToken:(NSString *)email password:(NSString*)password withCallback:(RequestCompleteBlock)callback;
@end
