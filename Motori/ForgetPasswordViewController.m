//
//  ForgetPasswordViewController.m
//  Motori
//
//  Created by adb on 6/10/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "DataDownloader.h"
#import "Settings.h"
#import "DBManager.h"
#import "FCAlertView.h"
#import "UIWindow+YzdHUD.h"

@interface ForgetPasswordViewController ()
@property (strong, nonatomic) DataDownloader *getData;
@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CustomizeNavigationBar];
    [self AddGradientLayer];
    sendButton.layer.cornerRadius = 5;
}

- (IBAction)SendEvent:(id)sender {
    
    sendButton.enabled = NO;
    
    RequestCompleteBlock callback2 = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
        if (wasSuccessful) {
            
            NSString *status =[NSString stringWithFormat:@"%@",[data valueForKey:@"status"]];
            
            if (![status isEqualToString:@"0"]) {
                
                sendButton.enabled = YES;
                [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                [self ShowSuccess];
            }
            
            else
            {
                [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                [self ShowError];
                sendButton.enabled = YES;
                
            }
            
            
        }};
    
    
    
    if ( phoneNumberTextField.text.length > 0) {
        
        [self.view.window showHUDWithText:@"لطفا صبر کنید" Type:ShowLoading Enabled:YES];
        [self.getData ForgetPassword:phoneNumberTextField.text withCallback:callback2];
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🤔"
                                                        message:@"لطفا تمامی مقادیر را تکمیل نمایید."
                                                       delegate:self
                                              cancelButtonTitle:@"تایید"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)ShowError
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    
    [alert showAlertInView:self
                 withTitle:nil
              withSubtitle:@"شماره ی وارد شده اشتباه است"
           withCustomImage:[UIImage imageNamed:@"alert.png"]
       withDoneButtonTitle:@"تایید"
                andButtons:nil];
    
}

-(void)ShowSuccess
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    [alert makeAlertTypeSuccess];
    [alert showAlertInView:self
                 withTitle:nil
              withSubtitle:@"کلمه ی عبور برای شما پیامک شد"
           withCustomImage:[UIImage imageNamed:@"alert.png"]
       withDoneButtonTitle:@"تایید"
                andButtons:nil];
    
}

-(void)AddGradientLayer
{
    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:30/255.f green:170/255.f blue:241/255.f alpha:.3] CGColor],(id)[[UIColor colorWithRed:30/255.f green:170/255.f blue:241/255.f alpha:0.3] CGColor],(id)[[UIColor colorWithRed:160/255.f green:165/255.f blue:238/255.f alpha:.4f] CGColor],(id)[[UIColor colorWithRed:160/255.f green:165/255.f blue:238/255.f alpha:.6f] CGColor], (id)[[UIColor colorWithRed:160/255.f green:165/255.f blue:238/255.f alpha:1] CGColor],(id)[[UIColor colorWithRed:160/255.f green:165/255.f blue:238/255.f alpha:.6f] CGColor],(id)[[UIColor colorWithRed:30/255.f green:170/255.f blue:241/255.f alpha:.3] CGColor],(id)[[UIColor colorWithRed:30/255.f green:170/255.f blue:241/255.f alpha:.3] CGColor],nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

-(void)CustomizeNavigationBar
{
    UIViewController *previousVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 1];
    // Create a UIBarButtonItem
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(popViewController)];
    // Associate the barButtonItem to the previous view
    [previousVC.navigationItem setBackBarButtonItem:barButtonItem];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
}

@end
