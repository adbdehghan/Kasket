//
//  SplashViewController.m
//  Wash Me
//
//  Created by adb on 9/18/16.
//  Copyright © 2016 Arena. All rights reserved.
//

#import "SplashViewController.h"
#import "DBManager.h"
#import "Settings.h"
#import "DataDownloader.h"



@interface SplashViewController ()
{
 NSString *version;
    
}

@property (strong, nonatomic) DataDownloader *getData;

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     version = @"1";
    
    [NSTimer scheduledTimerWithTimeInterval:0
                                     target:self
                                   selector:@selector(NextView)
                                   userInfo:nil
                                    repeats:NO];
    
}

-(void)NextView
{
    //[self performSegueWithIdentifier:@"login" sender:self];
    Settings *st = [[Settings alloc]init];
    
    for (Settings *item in [DBManager selectSetting])
    {
        st =item;
    }
    
    
    
    if (st.settingId!=nil )
    {
        RequestCompleteBlock callback2 = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
            if (wasSuccessful) {
                
                if (![[data valueForKey:@"res"] isEqualToString:@"NO"]) {
                    [DBManager deleteDataBase];
                    
                    Settings *setting = [[Settings alloc]init];
                    setting.settingId = st.settingId;
                    setting.password = st.password;
                    setting.accesstoken = [data valueForKey:@"accesstoken"];
                    
                    [DBManager createTable];
                    [DBManager saveOrUpdataSetting:setting];
                    
                    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
                        if (wasSuccessful) {
                            
                            NSString *rVersion = [data valueForKey:@"version"];
                            NSString *isRated = [data valueForKey:@"lastRating"];
                            
                            [self SaveRating:isRated];
                            if ([isRated isEqualToString:@"True"]) {
                                [self SaveOrderId:[NSString stringWithFormat:@"%@",[[data valueForKey:@"lastRatingDetail"] valueForKey:@"orderId"]]];
                            }
                            
                            
                            if (![version isEqualToString:rVersion]) {
                                [self SaveVersion:@"true"];
                                
                            }
                            else
                                [self SaveVersion:@"false"];
                            
                            if (![[data valueForKey:@"status"] isEqualToString:@"True"]) {
                                [self Save:[[NSMutableDictionary alloc]init]];
                            }
                            
                            [self SaveConfirmation:[data valueForKey:@"isConfirmed"]];
                            
                            [self performSegueWithIdentifier:@"tomain" sender:self];
                        }
                        
                        else
                        {
                            
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"👻"
                                                                            message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                                           delegate:self
                                                                  cancelButtonTitle:@"تایید"
                                                                  otherButtonTitles:nil];
                            [alert show];
                            
                            NSLog( @"Unable to fetch Data. Try again.");
                            
                        }
                    };
                    
                    Settings *st = [[Settings alloc]init];
                    
                    st = [DBManager selectSetting][0];
                    
                    [self.getData Status:st.accesstoken withCallback:callback];
                    
                    
                }
                
                else
                {
                    
                    
                }
                
                
            }};
        
        
        [self.getData GetToken:st.settingId password:st.password withCallback:callback2];
        
    }
    else
    {
        [self performSegueWithIdentifier:@"login" sender:self];
    }    
}


- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
}

- (void)Save:(NSMutableDictionary*)status
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Order.plist"];
    
    [status writeToFile:plistPath atomically: TRUE];
    
}

- (void)SaveVersion:(NSString*)string
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:string];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"version.plist"];
    
    [array writeToFile:plistPath atomically: TRUE];
    
}

- (void)SaveConfirmation:(NSString*)IsConfirmed
{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:IsConfirmed];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"confirmed.plist"];
    
    [array writeToFile:plistPath atomically: TRUE];
    
}

- (void)SaveRating:(NSString*)IsRated
{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:IsRated];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"rating.plist"];
    
    [array writeToFile:plistPath atomically: TRUE];
    
}

- (void)SaveOrderId:(NSString*)orderId
{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:orderId];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"orderid.plist"];
    
    [array writeToFile:plistPath atomically: TRUE];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
