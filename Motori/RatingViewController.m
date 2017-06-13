//
//  RatingViewController.m
//  Motori
//
//  Created by adb on 6/5/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import "RatingViewController.h"
#import "TPFloatRatingView.h"
#import "DataDownloader.h"
#import "Settings.h"
#import "DBManager.h"
#import "UIWindow+YzdHUD.h"

@interface RatingViewController ()<TPFloatRatingViewDelegate>
{
    int ratingValue;
    NSInteger *selectedRow;
    NSArray *reasonArray;
    NSString *reason;
    BOOL notRated;
}
@property (strong, nonatomic) IBOutlet TPFloatRatingView *ratingView;
@property (strong, nonatomic) DataDownloader *getData;
@end

@implementation RatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *order = [self OrderId];
     _orderId = [order valueForKey:@"orderId"];
    
    if ([order valueForKey:@"cleanerName"]==nil) {
        [self OrderDetail];
    }
    else
        _kasketNameLabel.text = [((NSDictionary*)[self OrderId]) valueForKey:@"cleanerName"];
    
    
    [self CustomizeNavigationTitle];
    self.ratingView.delegate = self;
    self.ratingView.emptySelectedImage = [UIImage imageNamed:@"StarEmpty"];
    self.ratingView.fullSelectedImage = [UIImage imageNamed:@"StarFull"];
    self.ratingView.contentMode = UIViewContentModeScaleAspectFill;
    self.ratingView.maxRating = 5;
    self.ratingView.minRating = 1;
    self.ratingView.editable = YES;
    self.ratingView.halfRatings = NO;
    self.ratingView.floatRatings = NO;
    
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(1, 1.f);
    self.containerView.layer.shadowRadius = 6;
    self.containerView.layer.shadowOpacity = 0.7;
    
    reasonArray = @[@"رفتار یا ظاهر نا مناسب"
                    ,@"دریافت هزینه اضافی"
                    ,@"انتخاب مسیر نا مناسب"
                    ,@"زمان انتظار زیاد برای دریافت/فرستادن کالا"
                    ,@"چانه زنی"];
    
}

- (void)floatRatingView:(TPFloatRatingView *)ratingView ratingDidChange:(CGFloat)rating
{
    ratingValue = (int)rating;
    
    if (rating == 5) {
        self.reasonLabel.text = @"کاملا راضی";
        self.reasonLabel.font =[UIFont fontWithName:@"IRANSans" size:16];
        
        [UIView animateWithDuration:.5 animations:^(){
        
            self.tableView.alpha= 0;
        
        }];
        
    }
    else if (rating<5) {
        self.reasonLabel.text = @"لطفا دلیل نارضایتی خود را مشخص کنید";
        self.reasonLabel.font =[UIFont fontWithName:@"IRANSans" size:14];
        
        [UIView animateWithDuration:.6 animations:^(){
            
            self.tableView.alpha= 1;
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SendRatingButton:(id)sender {
    
    [self RequestRate];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    
    cell.textLabel.text = [reasonArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"IRANSans" size:14];
    cell.textLabel.textColor = [UIColor colorWithRed:48/255.f green:71/255.f blue:88/255.f alpha:1];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedRow = indexPath.row;
    reason = [reasonArray objectAtIndex:selectedRow];
}

-(void)RequestRate
{
    if (notRated) {
        ratingValue = -1;
    }
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
        if (wasSuccessful) {
            
            [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"👻"
                                                            message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                           delegate:self
                                                  cancelButtonTitle:@"تایید"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    };
    
    Settings *st = [[Settings alloc]init];
    
    st = [DBManager selectSetting][0];
    
    [self.view.window showHUDWithText:@"لطفا صبر نمایید" Type:ShowLoading Enabled:YES];
    if (ratingValue == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"👻"
                                                        message:@"لطفا ابتدا امتیاز بدهید"
                                                       delegate:self
                                              cancelButtonTitle:@"تایید"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
        [self.getData Rating:st.accesstoken Score:[NSString stringWithFormat:@"%d", ratingValue] OrderId:_orderId Reason:reason == nil ? @"" : reason withCallback:callback];
}


-(void)CustomizeNavigationTitle
{
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=@"بازخورد سرویس";
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
}

-(void)closeButtonAction
{
    notRated = YES;
    [self RequestRate];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
}

-(NSString*)OrderId
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"orderid.plist"];
    
    NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];
    
    return (NSArray*)array[0];
}

-(void)OrderDetail
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Order.plist"];
    
    NSMutableDictionary *array = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    _kasketNameLabel.text = [array valueForKey:@"name"];
}

@end
