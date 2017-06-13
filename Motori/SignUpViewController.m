//
//  SignUpViewController.m
//  Motori
//
//  Created by aDb on 12/30/16.
//  Copyright © 2016 Arena. All rights reserved.
//

#import "SignUpViewController.h"
#import "DataDownloader.h"
#import "Settings.h"
#import "DBManager.h"
#import "UIWindow+YzdHUD.h"


@interface SignUpViewController ()
{
    UIImageView *moon;
    BOOL isSnow;
}
@property (strong, nonatomic) DataDownloader *getData;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CustomizeNavigationBar];
    [self AddGradientLayer];
    [self setNeedsStatusBarAppearanceUpdate];
    signUpButton.layer.cornerRadius = 5;
 
}


-(void)CustomizeNavigationBar
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                        forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIViewController *previousVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    
    // Create a UIBarButtonItem
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(popViewController)];
    
    
    // Associate the barButtonItem to the previous view
    [previousVC.navigationItem setBackBarButtonItem:barButtonItem];
    
}

- (IBAction)SignUpButtonEvent:(id)sender {
    
    signUpButton.enabled = NO;
    
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSMutableDictionary *data2) {
        if (wasSuccessful) {
            
            
            if ([data2 count]>0 ) {
                
                RequestCompleteBlock callback2 = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
                    if (wasSuccessful) {
                        
                        Settings *setting = [[Settings alloc]init];
                        setting.settingId = phoneNumberTextField.text;
                        setting.password = passwordTextField.text;
                        setting.accesstoken = [data valueForKey:@"accesstoken"];
                        
                        [DBManager createTable];
                        [DBManager saveOrUpdataSetting:setting];
                        [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                        [self performSegueWithIdentifier:@"main" sender:self];
                        
                    }};
                
                
                
                [self.getData GetToken:phoneNumberTextField.text password:passwordTextField.text withCallback:callback2];
                
                
                
                
            }
            
            else
            {
                [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطا"
                                                                message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                               delegate:self
                                                      cancelButtonTitle:@"تایید"
                                                      otherButtonTitles:nil];
                [alert show];
                signUpButton.enabled = YES;
            }
            
            
            
        } else {
            [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطا"
                                                            message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                           delegate:self
                                                  cancelButtonTitle:@"تایید"
                                                  otherButtonTitles:nil];
            [alert show];
            
            signUpButton.enabled = YES;
            
            NSLog( @"Unable to fetch Data. Try again.");
        }
    };
    
    if (fullNameTextField.text.length > 0 && phoneNumberTextField.text.length > 0 && passwordTextField.text.length > 2) {
        [self.view.window showHUDWithText:@"لطفا صبر کنید" Type:ShowLoading Enabled:YES];
        [self.getData RegisterMember:fullNameTextField.text Param2:phoneNumberTextField.text Email:emailTextField.text == nil ? @"" :emailTextField.text  Password:passwordTextField.text withCallback:callback];
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🤔"
                                                        message:@"لطفا همه ی مقادیر را تکمیل نمایید."
                                                       delegate:self
                                              cancelButtonTitle:@"تایید"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
    
}

-(void)AddGradientLayer
{
    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:30/255.f green:170/255.f blue:241/255.f alpha:.3] CGColor],(id)[[UIColor colorWithRed:30/255.f green:170/255.f blue:241/255.f alpha:0.3] CGColor],(id)[[UIColor colorWithRed:160/255.f green:165/255.f blue:238/255.f alpha:.4f] CGColor],(id)[[UIColor colorWithRed:160/255.f green:165/255.f blue:238/255.f alpha:.6f] CGColor], (id)[[UIColor colorWithRed:160/255.f green:165/255.f blue:238/255.f alpha:1] CGColor],(id)[[UIColor colorWithRed:30/255.f green:170/255.f blue:241/255.f alpha:1] CGColor],(id)[[UIColor colorWithRed:30/255.f green:170/255.f blue:241/255.f alpha:1] CGColor],nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //    [nameUiTextField resignFirstResponder];
    //    [familyCodeUiTextField resignFirstResponder];
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
