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
#import "MapCharacter.h"

#define currentMonth [currentMonthString integerValue]

@interface ProfileViewController ()<UITextFieldDelegate>
{
    BOOL isSave;
    NSMutableArray *yearArray;
    NSArray *monthArray;
    NSMutableArray *DaysArray;
    NSString *currentMonthString;
    int selectedYearRow;
    int selectedMonthRow;
    int selectedDayRow;
    
    BOOL firstTimeLoad;
}
@property (strong, nonatomic) DataDownloader *getData;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CustomizeNavigationTitle];
    isSave = NO;
    self.SaveUIButton.layer.cornerRadius = 5;
    [IQKeyboardManager sharedManager].enable = YES;

    self.topUIView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.topUIView.layer.shadowRadius = 5;
    self.topUIView.layer.shadowOffset = CGSizeMake(1, 1);
    self.topUIView.layer.shadowOpacity = .7;
    self.topUIView.layer.cornerRadius = 8;
    self.topUIView.layer.masksToBounds = NO;
    
    
    [self GetProfileData];
    [self ConfigDatePicker];
}

-(void)ConfigDatePicker
{

    firstTimeLoad = YES;
    self.customPicker.hidden = YES;
    self.toolbarCancelDone.hidden = YES;
    
    NSDate *date = [NSDate date];
    
    // Get Current Year
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"fa_IR"]];
    
    NSString *currentyearString = [NSString stringWithFormat:@"%@",
                                   [formatter stringFromDate:date]];
    
    
    // Get Current  Month
    
    [formatter setDateFormat:@"MM"];
    
    currentMonthString = [NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:date]integerValue]];
    // Get Current  Date
    
    [formatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:date]integerValue]];
    
    
    // PickerView -  Years data
    yearArray = [[NSMutableArray alloc]init];
    
    
    for (int i = 1350; i <= 1400 ; i++)
    {
        [yearArray addObject:[MapCharacter MapCharacter:[NSString stringWithFormat:@"%d",i]]];
        
    }
    
    
    // PickerView -  Months data
    monthArray = @[@"۱",@"۲",@"۳",@"۴",@"۵",@"۶",@"۷",@"۸",@"۹",@"۱۰",@"۱۱",@"۱۲"];
    
    
    // PickerView -  days data
    
    DaysArray = [[NSMutableArray alloc]init];
    
    for (int i = 1; i <= 31; i++)
    {
        [DaysArray addObject:[MapCharacter MapCharacter:[NSString stringWithFormat:@"%d",i]]];
        
    }
    
    // PickerView - Default Selection as per current Date
    
    [self.customPicker selectRow:[yearArray indexOfObject:[MapCharacter MapCharacter:currentyearString]] inComponent:0 animated:YES];
    
    [self.customPicker selectRow:[monthArray indexOfObject:[MapCharacter MapCharacter:currentMonthString]] inComponent:1 animated:YES];
    
    [self.customPicker selectRow:[DaysArray indexOfObject:[MapCharacter MapCharacter:currentDateString]] inComponent:2 animated:YES];
    
    NSDictionary *barButtonAppearanceDict = @{NSFontAttributeName : [UIFont fontWithName:@"IRANSans" size:16.0] , NSForegroundColorAttributeName: [UIColor whiteColor]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];

}

-(void)GetProfileData
{
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
        if (wasSuccessful) {
         
            self.nameUITextField.text = [data valueForKey:@"fullname"] == [NSNull null] ? @"" : [data valueForKey:@"fullname"];
            
            if ([data valueForKey:@"email"] != [NSNull null]) {
                
                self.emailUITextField.text = [data valueForKey:@"email"];
                
            }
            
            self.textFieldEnterDate.text = [data valueForKey:@"birthdate"] == [NSNull null] ? @"" : [MapCharacter MapCharacter:[data valueForKey:@"birthdate"]];
            
            [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
        }
        else
        {
            [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
            
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
        self.textFieldEnterDate.userInteractionEnabled = YES;
        
        [self.nameUITextField resignFirstResponder];
        
        [self.SaveUIButton setTitle:  @"ذخیره" forState: UIControlStateNormal];
        
        [UIView animateWithDuration:1 animations:^{
        
            self.SaveUIButton.backgroundColor =[UIColor colorWithRed:0/255.f green:190/255.f blue:255/255.f alpha:1];
            [self.view setBackgroundColor:[UIColor colorWithRed:48/255.f green:71/255.f blue:88/255.f alpha:1]];
            
        }];
    }
    else
    {
        self.nameUITextField.userInteractionEnabled = NO;
        self.emailUITextField.userInteractionEnabled = NO;
        self.passwordUITextField.userInteractionEnabled = NO;
        self.textFieldEnterDate.userInteractionEnabled = NO;
        [UIView animateWithDuration:1 animations:^{
            [self.SaveUIButton setBackgroundColor:[UIColor colorWithRed:48/255.f green:71/255.f blue:88/255.f alpha:1]];
            self.view.backgroundColor =[UIColor colorWithRed:0/255.f green:190/255.f blue:255/255.f alpha:1];
   
        }];
        isSave = NO;
        [self.SaveUIButton setTitle: @"ویرایش" forState:UIControlStateNormal];
        
        [self ChangeProfile];
    }
}


-(void)ChangeProfile
{

    self.SaveUIButton.userInteractionEnabled = NO;
    
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
        
        self.SaveUIButton.userInteractionEnabled = YES;
        
        if (wasSuccessful) {
            
            [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
        }
        else
        {
            [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
            
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
    [self.getData ChangeProfile:st.accesstoken FullName:self.nameUITextField.text Email:self.emailUITextField.text Birthdate:[MapCharacter MapCharacterReverse:self.textFieldEnterDate.text] Password:self.passwordUITextField.text withCallback:callback];

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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    if (component == 0)
    {
        selectedYearRow = row;
        [self.customPicker reloadAllComponents];
    }
    else if (component == 1)
    {
        selectedMonthRow = row;
        [self.customPicker reloadAllComponents];
    }
    else if (component == 2)
    {
        selectedDayRow = row;
        
        [self.customPicker reloadAllComponents];
        
    }
    
}


#pragma mark - UIPickerViewDatasource

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
        pickerLabel.font = [UIFont fontWithName:@"IRANSans" size:15.0];
        pickerLabel.textColor = [UIColor whiteColor];
        
    }
    
    if (component == 0)
    {
        pickerLabel.text =  [yearArray objectAtIndex:row]; // Year
    }
    else if (component == 1)
    {
        pickerLabel.text =  [monthArray objectAtIndex:row];  // Month
    }
    else if (component == 2)
    {
        pickerLabel.text =  [DaysArray objectAtIndex:row]; // Date
        
    }
    
    return pickerLabel;
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 3;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0)
    {
        return [yearArray count];
        
    }
    else if (component == 1)
    {
        return [monthArray count];
    }
    else if (component == 2)
    { // day
        
        if (firstTimeLoad)
        {
            if (currentMonth == 1 || currentMonth == 3 || currentMonth == 5 || currentMonth == 7 || currentMonth == 8 || currentMonth == 10 || currentMonth == 12)
            {
                return 31;
            }
            else if (currentMonth == 2)
            {
                int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
                
            }
            else
            {
                return 30;
            }
            
        }
        else
        {
            
            if (selectedMonthRow == 0 || selectedMonthRow == 2 || selectedMonthRow == 4 || selectedMonthRow == 6 || selectedMonthRow == 7 || selectedMonthRow == 9 || selectedMonthRow == 11)
            {
                return 31;
            }
            else if (selectedMonthRow == 1)
            {
                int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
            }
            else
            {
                return 30;
            }
            
        }
        
        
    }
    
    return 0;
}



- (IBAction)actionCancel:(id)sender
{
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.customPicker.hidden = YES;
                         self.toolbarCancelDone.hidden = YES;
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    
    
}

- (IBAction)actionDone:(id)sender
{
    
    
    self.textFieldEnterDate.text = [NSString stringWithFormat:@"%@/%@/%@",[yearArray objectAtIndex:[self.customPicker selectedRowInComponent:0]],[monthArray objectAtIndex:[self.customPicker selectedRowInComponent:1]],[DaysArray objectAtIndex:[self.customPicker selectedRowInComponent:2]]];
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.customPicker.hidden = YES;
                         self.toolbarCancelDone.hidden = YES;
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    
    
    
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.customPicker.hidden = NO;
                         self.toolbarCancelDone.hidden = NO;
                         self.textFieldEnterDate.text = @"";
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    
    self.customPicker.hidden = NO;
    self.toolbarCancelDone.hidden = NO;
    self.textFieldEnterDate.text = @"";
    
    
    
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return  YES;
    
}


- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
}



@end
