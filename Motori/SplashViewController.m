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
    
    
}

@property (strong, nonatomic) DataDownloader *getData;

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
                    
                    
                    [self performSegueWithIdentifier:@"tomain" sender:self];
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
