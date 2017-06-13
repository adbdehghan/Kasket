//
//  RaiseCreditViewController.m
//  Wash Me
//
//  Created by adb on 12/12/16.
//  Copyright © 2016 Arena. All rights reserved.
//

#import "RaiseCreditViewController.h"
#import "DataDownloader.h"
#import "Settings.h"
#import "DBManager.h"
#import "DGActivityIndicatorView.h"
#import "FCAlertView.h"

@interface RaiseCreditViewController ()
{
    DGActivityIndicatorView *floatActivityIndicatorView;

}
@property (strong, nonatomic) DataDownloader *getData;
@end

@implementation RaiseCreditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CustomizeNavigationTitle];
    
    self.creditContainerView.layer.cornerRadius = 5;
    self.creditContainerView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.creditContainerView.layer.shadowOffset = CGSizeMake(1, 1.f);
    self.creditContainerView.layer.shadowRadius = 6;
    self.creditContainerView.layer.shadowOpacity = 0.5;
    
    floatActivityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallScaleRipple tintColor:[UIColor colorWithRed:53.f/255.f green:70.f/255.f blue:86.f/255.f alpha:1] size:30.0f];
    floatActivityIndicatorView.frame = CGRectMake(self.creditContainerView.frame.size.width/2-15, self.creditContainerView.frame.size.height/2-15, 30, 30);
    [self.creditContainerView addSubview:floatActivityIndicatorView];

    
    self.mainContainerView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.mainContainerView.layer.shadowOffset = CGSizeMake(0, 1.f);
    self.mainContainerView.layer.shadowRadius = 5;
    self.mainContainerView.layer.shadowOpacity = 0.3;
    
    self.payButton.layer.cornerRadius = 5;
    self.payButton.layer.shadowColor = [UIColor grayColor].CGColor;
    self.payButton.layer.shadowOffset = CGSizeMake(0, 1.f);
    self.payButton.layer.shadowRadius = 5;
    self.payButton.layer.shadowOpacity = 0.3;
    
    self.eightButton.layer.cornerRadius = 5;
    self.twelveButton.layer.cornerRadius = 5;
    self.fifteenButton.layer.cornerRadius = 5;
    
    [self Credit];
    
}

-(void)Credit
{
    [floatActivityIndicatorView startAnimating];
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
        [floatActivityIndicatorView stopAnimating];
        if (wasSuccessful) {
            
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[[data valueForKey:@"credit"] integerValue]]];
            
            self.creditLabelView.text = [NSString stringWithFormat:@"%@ تومان",[self MapCharacter:formatted]];
            
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
    
    [self.getData Credit:st.accesstoken withCallback:callback];
}


- (IBAction)eightButtonEvent:(id)sender {
    
    self.priceUITextField.text = @"۸،۰۰۰";
    
}

- (IBAction)TwelveButtonEvent:(id)sender {
    
    self.priceUITextField.text = @"۱۲،۰۰۰";
}

- (IBAction)FifteenButtonEvent:(id)sender {
    
    self.priceUITextField.text = @"۱۵،۰۰۰";
}

- (IBAction)PayButtonEvent:(id)sender {
    
    if (self.priceUITextField.text.length >= 3) {
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string =[NSString stringWithFormat:@"*788*97*9512*%@#" ,self.priceUITextField.text];
        
        [self ShowPaymentNotice];
        
    }
    else
    {
        FCAlertView *alert = [[FCAlertView alloc] init];
        [alert makeAlertTypeCaution];
        [alert showAlertInView:self
                     withTitle:nil
                  withSubtitle:@"لطفا مبلغ را وارد نمایید"
               withCustomImage:[UIImage imageNamed:@"alert.png"]
           withDoneButtonTitle:@"تایید"
                    andButtons:nil];
        
    }   
}

-(void)ShowPaymentNotice
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    [alert makeAlertTypeSuccess];
    [alert showAlertInView:self
                 withTitle:nil
              withSubtitle:@"کد پرداخت در حافظه دستگاه ذخیره شد. جهت پرداخت، لطفا آن را در برنامه Phone به عنوان شماره Paste نمایید و Call را بزنید."
           withCustomImage:[UIImage imageNamed:@"alert.png"]
       withDoneButtonTitle:@"تایید"
                andButtons:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)CustomizeNavigationTitle
{
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=@"افزایش اعتبار";
    label.textColor=[UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font =[UIFont fontWithName:@"IRANSans" size:17];
    label.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView=label;
    
    // Get the previous view controller
    UIViewController *previousVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    // Create a UIBarButtonItem
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(popViewController)];
    // Associate the barButtonItem to the previous view
    [previousVC.navigationItem setBackBarButtonItem:barButtonItem];
    
}

-(NSString*)MapCharacter:(NSString*)character
{
    if ([character containsString:@"1"])
        character = [character stringByReplacingOccurrencesOfString:@"1" withString:@"۱"];
    if ([character containsString:@"2"])
        character =[character stringByReplacingOccurrencesOfString:@"2" withString:@"۲"];
    if ([character containsString:@"3"])
        character =[character stringByReplacingOccurrencesOfString:@"3" withString:@"۳"];
    if ([character containsString:@"4"])
        character =[character stringByReplacingOccurrencesOfString:@"4" withString:@"۴"];
    if ([character containsString:@"5"])
        character =[character stringByReplacingOccurrencesOfString:@"5" withString:@"۵"];
    if ([character containsString:@"6"])
        character =[character stringByReplacingOccurrencesOfString:@"6" withString:@"۶"];
    if ([character containsString:@"7"])
        character =[character stringByReplacingOccurrencesOfString:@"7" withString:@"۷"];
    if ([character containsString:@"8"])
        character =[character stringByReplacingOccurrencesOfString:@"8" withString:@"۸"];
    if ([character containsString:@"9"])
        character =[character stringByReplacingOccurrencesOfString:@"9" withString:@"۹"];
    if ([character containsString:@"0"])
        character =[character stringByReplacingOccurrencesOfString:@"0" withString:@"۰"];
    
    return character;
}

- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
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
