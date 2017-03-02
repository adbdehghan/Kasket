//
//  ProfileViewController.m
//  Wash Me
//
//  Created by adb on 12/18/16.
//  Copyright © 2016 Arena. All rights reserved.
//

#import "ProfileViewController.h"
#import "IQKeyboardManager.h"
#import "DataDownloader.h"
#import "Settings.h"
#import "DBManager.h"
#import "UIWindow+YzdHUD.h"
#import "FCAlertView.h"

@interface ProfileViewController ()<UITextFieldDelegate>
{
    BOOL isSave;
}
@property (strong, nonatomic) DataDownloader *getData;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CustomizeNavigationTitle];
    isSave = NO;
    self.SaveUIButton.layer.cornerRadius = 5;
    self.SaveUIButton.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.SaveUIButton.layer.shadowRadius = 5;
    self.SaveUIButton.layer.shadowOffset = CGSizeMake(1, 1);
    self.SaveUIButton.layer.shadowOpacity = .5;
    self.SaveUIButton.layer.masksToBounds = NO;
    [IQKeyboardManager sharedManager].enable = YES;
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
   // self.profileImageView.layer.borderColor = [UIColor clearColor].CGColor;
    //self.profileImageView.layer.borderWidth = 0;
    
    self.profileImageView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.profileImageView.layer.shadowRadius = 6;
    self.profileImageView.layer.shadowOffset = CGSizeMake(1, 1);
    self.profileImageView.layer.shadowOpacity = .5;
    self.profileImageView.layer.masksToBounds = NO;
    
    self.topUIView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.topUIView.layer.shadowRadius = 5;
    self.topUIView.layer.shadowOffset = CGSizeMake(1, 1);
    self.topUIView.layer.shadowOpacity = .7;
    self.topUIView.layer.cornerRadius = 8;
    self.topUIView.layer.masksToBounds = NO;
    
    
    [self GetProfileData];
    
}

-(void)GetProfileData
{
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
        if (wasSuccessful) {
         
            self.nameUITextField.text = [data valueForKey:@"fullname"];
            
            if ([data valueForKey:@"email"] != [NSNull null]) {
                
                self.emailUITextField.text = [data valueForKey:@"email"];
                
            }
            [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
        }
        else
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"👻"
                                                            message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                           delegate:self
                                                  cancelButtonTitle:@"خب"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
            NSLog( @"Unable to fetch Data. Try again.");
            
        }
    };
    
    Settings *st = [[Settings alloc]init];
    
    st = [DBManager selectSetting][0];
    
    self.passwordUITextField.text = st.password;
    [self.view.window showHUDWithText:@"لطفا صبر کنید" Type:ShowLoading Enabled:YES];
    [self.getData Profile:st.accesstoken withCallback:callback];

}

- (IBAction)ButtonEvent:(id)sender {
    
    
    if (!isSave) {
        isSave = YES;
        self.nameUITextField.userInteractionEnabled = YES;
        self.emailUITextField.userInteractionEnabled = YES;
        self.passwordUITextField.userInteractionEnabled = YES;
        
        [self.nameUITextField resignFirstResponder];
        
        [self.SaveUIButton setTitle:  @"ذخیره" forState: UIControlStateNormal];
        
        [UIView animateWithDuration:1 animations:^{
        
            [self.SaveUIButton setBackgroundColor:[UIColor blackColor]];
            [self.profileImageView setBackgroundColor:[UIColor darkGrayColor]];
            [self.topUIView setBackgroundColor:[UIColor colorWithRed:71/255.f green:106/255.f blue:129/255.f alpha:1]];
        }];
        
        
    }
    else
    {
        self.nameUITextField.userInteractionEnabled = NO;
        self.emailUITextField.userInteractionEnabled = NO;
        self.passwordUITextField.userInteractionEnabled = NO;
        [UIView animateWithDuration:1 animations:^{
            [self.SaveUIButton setBackgroundColor:[UIColor colorWithRed:0/255.f green:162/255.f blue:252/255.f alpha:1]];
            [self.topUIView setBackgroundColor:[UIColor colorWithRed:0/255.f green:176/255.f blue:252/255.f alpha:1]];
            [self.profileImageView setBackgroundColor:[UIColor colorWithRed:48/255.f green:71/255.f blue:88/255.f alpha:1]];
        }];
        isSave = NO;
        [self.SaveUIButton setTitle: @"ویرایش" forState:UIControlStateNormal];
        
        [self ChangeProfile];
        
    }
    
}


-(void)ChangeProfile
{

    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
        if (wasSuccessful) {
            
            [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
        }
        else
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"👻"
                                                            message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                           delegate:self
                                                  cancelButtonTitle:@"خب"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
            NSLog( @"Unable to fetch Data. Try again.");
            
        }
    };
    
    Settings *st = [[Settings alloc]init];
    
    st = [DBManager selectSetting][0];
    
    
    [self.view.window showHUDWithText:@"لطفا صبر کنید" Type:ShowLoading Enabled:YES];
    [self.getData ChangeProfile:st.accesstoken FullName:self.nameUITextField.text Email:self.emailUITextField.text Password:self.passwordUITextField.text withCallback:callback];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)CustomizeNavigationTitle
{
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=@"حساب کاربری";
    label.textColor=[UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font =[UIFont fontWithName:@"IRANSans" size:17];
    label.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView=label;
    
    // Get the previous view controller
    UIViewController *previousVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 1];
    // Create a UIBarButtonItem
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(popViewController)];
    // Associate the barButtonItem to the previous view
    [previousVC.navigationItem setBackBarButtonItem:barButtonItem];
    
    UIButton *settingButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *settingImage = [[UIImage imageNamed:@"close.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [settingButton setImage:settingImage forState:UIControlStateNormal];
    [settingButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    settingButton.tintColor = [UIColor whiteColor];
    [settingButton addTarget:self action:@selector(closeButtonAction)forControlEvents:UIControlEventTouchUpInside];
    [settingButton setFrame:CGRectMake(0, 0, 15, 15)];
    
    UIBarButtonItem *settingBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    self.navigationItem.leftBarButtonItem = settingBarButton;
    
    UIButton *logoutButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *logoutImage = [[UIImage imageNamed:@"logout.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [logoutButton setImage:logoutImage forState:UIControlStateNormal];
    [logoutButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    logoutButton.tintColor = [UIColor whiteColor];
    [logoutButton addTarget:self action:@selector(LogoutButtonAction)forControlEvents:UIControlEventTouchUpInside];
    [logoutButton setFrame:CGRectMake(0, 0, 24, 24)];
    
    
    UIBarButtonItem *logoutBarButton = [[UIBarButtonItem alloc] initWithCustomView:logoutButton];
    self.navigationItem.rightBarButtonItem = logoutBarButton;
    
    
}

-(void)LogoutButtonAction
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    
    [alert showAlertInView:self
                 withTitle:@"خروج "
              withSubtitle:@"آیا مطمئن هستید؟"
           withCustomImage:[UIImage imageNamed:@"alert.png"]
       withDoneButtonTitle:@"بله"
                andButtons:nil];
    [alert addButton:@"خیر" withActionBlock:^{
        // Put your action here
    }];
    [alert doneActionBlock:^{
        [DBManager deleteDataBase];
        [self performSegueWithIdentifier:@"logout" sender:self];
    }];

}

-(void)closeButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
}


@end
