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

- (void)ForgetPassword:(NSString *)param1 withCallback:(RequestCompleteBlock)callback;

- (void)RegisterProfile:(NSString*)token  Name:(NSString*)name LastName:(NSString*)lastName  withCallback:(RequestCompleteBlock)callback;

- (void)GetVersion:(NSString *)params withCallback:(RequestCompleteBlock)callback;

- (void)GetPrice:(NSString*)token SourceLat:(NSString*)sourceLat SourceLon:(NSString*)sourceLon DestinationLat:(NSString*)destinationLat DestinationLon:(NSString*)destinationLon HaveReturn:(NSString*)haveReturn OrderType:(NSString*)orderType Cost:(NSString*)cost withCallback:(RequestCompleteBlock)callback;

- (void)Order:(NSString*)token SourceLat:(NSString*)sourceLat SourceLon:(NSString*)sourceLon DestinationLat:(NSString*)destinationLat DestinationLon:(NSString*)destinationLon HaveReturn:(NSString*)haveReturn OrderType:(NSString*)orderType SourceNum:(NSString*)sourceNum SourceBell:(NSString*)sourceBell DestinationNum:(NSString*)destinationNum DestinationBell:(NSString*)destinationBell DestinationFullName:(NSString*)destinationFullName DestinationPhoneNumber:(NSString*)destinationPhoneNumber PayInDestination:(NSString*)payInDestination SourceAddress:(NSString*)sourceAddress DestinationAddress:(NSString*)destinationAddress Offcode:(NSString*)offcode  withCallback:(RequestCompleteBlock)callback;

- (void)GetOrderStatus:(NSString*)token OrderId:(NSString*)orderId withCallback:(RequestCompleteBlock)callback;;

- (void)Rating:(NSString*)token Score:(NSString*)score OrderId:(NSString*)orderId Reason:(NSString*)reason withCallback:(RequestCompleteBlock)callback;

- (void)SetNotificationToken:(NSString*)accesstoken Token:(NSString*)token withCallback:(RequestCompleteBlock)callback;

- (void)SendBill:(NSString*)token OrderId:(NSString*)orderId withCallback:(RequestCompleteBlock)callback;

- (void)ConfirmNumber:(NSString*)token Code:(NSString*)code withCallback:(RequestCompleteBlock)callback;

- (void)Profile:(NSString*)token withCallback:(RequestCompleteBlock)callback;

- (void)ChangeProfile:(NSString*)token FullName:(NSString*)fullname Email:(NSString*)email Birthdate:(NSString*)birthdate Password:(NSString*)password withCallback:(RequestCompleteBlock)callback;

- (void)Credit:(NSString*)token withCallback:(RequestCompleteBlock)callback;

- (void)Status:(NSString*)token withCallback:(RequestCompleteBlock)callback;

- (void)SendConfirmCode:(NSString*)token withCallback:(RequestCompleteBlock)callback;

- (void)OrderHistory:(NSString*)token Page:(NSString*)page withCallback:(RequestCompleteBlock)callback;

- (void)Transactions:(NSString*)token Page:(NSString*)page withCallback:(RequestCompleteBlock)callback;

- (void)Notifications:(NSString*)token Page:(NSString*)page withCallback:(RequestCompleteBlock)callback;

- (void)CheckKasket:(NSString*)token OrderId:(NSString*)orderId withCallback:(RequestCompleteBlock)callback;

- (void)CancelOrder:(NSString*)token OrderId:(NSString*)orderId withCallback:(RequestCompleteBlock)callback;

- (void)OffCode:(NSString*)token Code:(NSString*)code withCallback:(RequestCompleteBlock)callback;

- (void)GetSummarize:(NSString *)phoneNumber Password:(NSString*)password withCallback:(RequestCompleteBlock)callback;

- (void)GetProfilePicInfo:(NSString *)token  withCallback:(RequestCompleteBlock)callback;

- (void)SetSetiing:(NSString *)token Name:(NSString*)name LastName:(NSString*)lastName Gender:(NSString*)gender city:(NSString*)city birthdayDay:(NSString*) birthdayDay birhtdayMonth:(NSString*)birhtdayMonth birhtdayYear:(NSString*)birhtdayYear      withCallback:(RequestCompleteBlock)callback;

- (void)GetSetting:(NSString *)token withCallback:(RequestCompleteBlock)callback;

- (void)Invite:(NSString *)phoneNumber Password:(NSString*)password contactNumber:(NSString*)contactNumber withCallback:(RequestCompleteBlock)callback;

- (void)GetToken:(NSString *)email password:(NSString*)password withCallback:(RequestCompleteBlock)callback;
@end
