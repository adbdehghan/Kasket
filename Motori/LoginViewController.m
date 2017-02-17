//
//  LoginViewController.m
//  Motori
//
//  Created by aDb on 12/30/16.
//  Copyright © 2016 Arena. All rights reserved.
//

#import "LoginViewController.h"
#import "DataDownloader.h"
#import "Settings.h"
#import "DBManager.h"
#import "FCAlertView.h"
#import "UIWindow+YzdHUD.h"

@interface LoginViewController ()
{

}

@property (strong, nonatomic) DataDownloader *getData;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self CustomizeNavigationBar];
    [self AddGradientLayer];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    loginButton.layer.cornerRadius = 5;
}

-(void)viewDidAppear:(BOOL)animated
{
    UIImageView *bird = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"birds.gif"]];
    bird.frame = CGRectMake(self.view.frame.size.width +100, self.view.frame.size.height-self.view.frame.size.height/2 - 100 , 60, 50);
    bird.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:bird];
    
    [UIView animateWithDuration:7 animations:^(void){
        
        bird.frame = CGRectMake(-100, self.view.frame.size.height-self.view.frame.size.height/2 - 250 , 60, 50);
        
    }];
}

- (IBAction)LoginEvent:(id)sender {
    
    loginButton.enabled = NO;
    
    RequestCompleteBlock callback2 = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
        if (wasSuccessful) {
            
            if (![[data valueForKey:@"res"] isEqualToString:@"NO"]) {
                [DBManager deleteDataBase];
                
                Settings *setting = [[Settings alloc]init];
                setting.settingId = emailTextField.text;
                setting.password = passwordTextField.text;
                setting.accesstoken = [data valueForKey:@"accesstoken"];
                
                [DBManager createTable];
                [DBManager saveOrUpdataSetting:setting];
                
                loginButton.enabled = YES;
                [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                [self performSegueWithIdentifier:@"main" sender:self];
            }
            
            else
            {
                [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                [self ShowError];
                loginButton.enabled = YES;
                
            }
            
            
        }};
    
    
    
    if ( emailTextField.text.length > 0 && passwordTextField.text.length > 2) {
        
        [self.view.window showHUDWithText:@"لطفا صبر کنید" Type:ShowLoading Enabled:YES];
        [self.getData GetToken:emailTextField.text password:passwordTextField.text withCallback:callback2];
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🤔"
                                                        message:@"لطفا همه ی مقادیر را تکمیل نمایید."
                                                       delegate:self
                                              cancelButtonTitle:@"خب"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
}

-(void)AddGradientLayer
{
    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:30/255.f green:170/255.f blue:241/255.f alpha:1] CGColor],(id)[[UIColor colorWithRed:30/255.f green:170/255.f blue:241/255.f alpha:1] CGColor],(id)[[UIColor colorWithRed:160/255.f green:165/255.f blue:238/255.f alpha:.5f] CGColor],(id)[[UIColor colorWithRed:160/255.f green:165/255.f blue:238/255.f alpha:.8f] CGColor], (id)[[UIColor colorWithRed:160/255.f green:165/255.f blue:238/255.f alpha:1] CGColor],(id)[[UIColor colorWithRed:30/255.f green:170/255.f blue:241/255.f alpha:1] CGColor],(id)[[UIColor colorWithRed:30/255.f green:170/255.f blue:241/255.f alpha:1] CGColor],nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
}
-(void)ShowError
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    
    [alert showAlertInView:self
                 withTitle:nil
              withSubtitle:@"نام کاربری یا کلمه ی عبور اشتباه است"
           withCustomImage:[UIImage imageNamed:@"alert.png"]
       withDoneButtonTitle:@"خب"
                andButtons:nil];
    
}

-(void)CustomizeNavigationBar
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIViewController *previousVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 1];
    // Create a UIBarButtonItem
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(popViewController)];
    // Associate the barButtonItem to the previous view
    [previousVC.navigationItem setBackBarButtonItem:barButtonItem];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
