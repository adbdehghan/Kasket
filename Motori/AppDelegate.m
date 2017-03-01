//
//  AppDelegate.m
//  Motori
//
//  Created by aDb on 12/30/16.
//  Copyright © 2016 Arena. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import <OCGoogleDirectionsAPI/OCGoogleDirectionsAPI.h>

@import GoogleMaps;
@import GooglePlaces;
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [GMSServices provideAPIKey:@"AIzaSyCvhTlttp-AAadtH5Azgjg8lZBhWKVJF1o"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyBegoSeF2g34tFK_22yCbFE7UlTjKev7lg"];
    [OCDirectionsAPIClient provideAPIKey:@"AIzaSyAaqMrPIwSTSyCPd6LSyQk8stGZ4iDMCeg"];
    [IQKeyboardManager sharedManager].enable = YES;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    //    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.f/255.f green:162.f/255.f blue:252.f/255.f alpha:1]];
    
    NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    if (![[languages firstObject] isEqualToString:@"en"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@[@"fa"] forKey:@"AppleLanguages"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<> "]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self Save:token];
}

- (void)Save:(NSString*)token
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:token];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"token.plist"];
    
    [array writeToFile:plistPath atomically: TRUE];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
