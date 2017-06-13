//
//  HistoryTableViewController.m
//  Wash Me
//
//  Created by adb on 8/9/16.
//  Copyright © 2016 Arena. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "DataDownloader.h"
#import "Settings.h"
#import "DBManager.h"
#import "OrderHistory.h"
#import "HistoryTableViewCell.h"
#import "UIScrollView+UzysAnimatedGifLoadMore.h"
#import "UIImage+OHPDF.h"
#import "MapCharacter.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "FCAlertView.h"

@import GoogleMaps;
@interface HistoryTableViewController ()
{
    NSMutableArray *tableItems;
    UIActivityIndicatorView *activityIndicator;
    UILabel *clearMessage;
    NSIndexPath *selectedIndexPath;
    HistoryTableViewCell *lastCell;
    BOOL isExpanded;
}
@property (strong, nonatomic) DataDownloader *getData;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic,assign) BOOL useActivityIndicator;
@property (nonatomic, assign) NSInteger rowsCount;
@end

#define IS_IOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 && floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)
#define IS_IOS8  ([[[UIDevice currentDevice] systemVersion] compare:@"8" options:NSNumericSearch] != NSOrderedAscending)
#define IS_IPHONE6PLUS ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && [[UIScreen mainScreen] nativeScale] == 3.0f)

@implementation CALayer (Additions)

- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

@end
@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CustomizeNavigationTitle];
    [self InitialObjects];
    if(IS_IOS7 || IS_IOS8)
        self.automaticallyAdjustsScrollViewInsets = YES;
    
    
    
}

-(void)InitialObjects
{
    tableItems = [[NSMutableArray alloc]init];
    self.currentPage = 1;
    self.totalPages = 1;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [activityIndicator startAnimating];
    self.tableView.estimatedRowHeight = 80;
    __weak typeof(self) weakSelf =self;
    [self.tableView addLoadMoreActionHandler:^{
        typeof(self) strongSelf = weakSelf;
        if (self.currentPage <= self.totalPages)
        {
            [strongSelf loadNextBatch];
        }
        else
            [strongSelf.tableView removeLoadMoreActionHandler];
    } ProgressImagesGifName:@"nevertoolate@2x.gif" LoadingImagesGifName:@"nevertoolate@2x.gif" ProgressScrollThreshold:30 LoadingImageFrameRate:30];
    
    _rowsCount = 0;
    
    clearMessage = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.center.y - 60, self.view.frame.size.width,30 )];
    clearMessage.textColor=[UIColor grayColor];
    clearMessage.backgroundColor =[UIColor clearColor];
    clearMessage.font = [UIFont fontWithName:@"IRANSans" size:16];
    clearMessage.textAlignment = NSTextAlignmentCenter;
    clearMessage.text = @"هیج سفارشی ثبت نشده است";
    clearMessage.alpha = 0;
    [self.view addSubview:clearMessage];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    Manually trigger
    [self.tableView triggerLoadMoreActionHandler];
}

- (void)loadNextBatch {
       self.isLoading =YES;
      __weak typeof(self) weakSelf = self;
        typeof(self) strongSelf = weakSelf;
    
        RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
            if (wasSuccessful) {
                NSMutableArray *temp = [[NSMutableArray alloc]init];
                
                self.totalPages = [[data valueForKey:@"totalpage"] integerValue];
                
                for (NSDictionary *item in (NSMutableArray*)[data valueForKey:@"data"]) {
                    OrderHistory *order = [[OrderHistory alloc]init];
                    order.orderId = [NSString stringWithFormat:@"%@",[item valueForKey:@"id"]];
                    order.destinationFullName = [[item valueForKey:@"destinationFullName"]isEqual:[NSNull null]]? @"-":[item valueForKey:@"destinationFullName"];
                    order.employeeName =[item valueForKey:@"employeeName"];
                    order.sourceAddress =[item valueForKey:@"sourceAddress"];
                    order.destinationAddress =[item valueForKey:@"destinationAddress"];
                    order.orderTime =[item valueForKey:@"orderTime"];
                    order.price = [item valueForKey:@"totalPrice"];
                    order.orderNumber = [item valueForKey:@"orderNumber"];
                    order.sourceLat = [[item valueForKey:@"sourcelocation"] valueForKey:@"latitude"];
                    order.sourceLon = [[item valueForKey:@"sourcelocation"] valueForKey:@"longitude"];
                    order.sourcePlate = [[item valueForKey:@"sourceNum"] isEqual:[NSNull null]]? @"-":[item valueForKey:@"sourceNum"];
                    order.sourceBell = [[item valueForKey:@"sourceBell"] isEqual:[NSNull null]] ? @"-" : [item valueForKey:@"sourceBell"];
                    order.destinationLat = [[item valueForKey:@"destinationlocation"] valueForKey:@"latitude"];
                    order.destinationLon = [[item valueForKey:@"destinationlocation"] valueForKey:@"longitude"];
                    
                    order.destinationBell = [[item valueForKey:@"destinationBell"] isEqual:[NSNull null]] ? @"-" : [item valueForKey:@"destinationBell"];
                    order.destinationPlate = [[item valueForKey:@"destinationNum"] isEqual:[NSNull null]] ? @"-" : [item valueForKey:@"destinationNum"];
                    order.destinationPhoneNumber = [[item valueForKey:@"destinationPhoneNumber"] isEqual:[NSNull null]] ? @"-" : [item valueForKey:@"destinationPhoneNumber"];
                    
                    order.status = [NSString stringWithFormat:@"%@",[item valueForKey:@"status"]];
                    order.orderType = [NSString stringWithFormat:@"%@",[item valueForKey:@"orderType"]];
                    order.payInDestination = [NSString stringWithFormat:@"%@",[item valueForKey:@"payinDestination"]];
                    order.paymentStatus = [NSString stringWithFormat:@"%@",[item valueForKey:@"paymentstatus"]];
                    [tableItems addObject:order];
                    [temp addObject:order];
                }
                
                [activityIndicator stopAnimating];
                
                if (temp.count == 0) {
                    clearMessage.alpha = 1;
                }
                else
                    clearMessage.alpha = 0;
                
                
                NSInteger rows = [strongSelf.tableView numberOfRowsInSection:0];
                
                [strongSelf.tableView beginUpdates];
                NSMutableArray *Indexpaths = [NSMutableArray array];
                for (int i=0 ; i<temp.count ; i++) {
                    [Indexpaths addObject:[NSIndexPath indexPathForRow:rows+i inSection:0]];
                }
                
                [strongSelf.tableView insertRowsAtIndexPaths:Indexpaths withRowAnimation:UITableViewRowAnimationAutomatic];
                [strongSelf.tableView endUpdates];
                
                if (self.currentPage == self.totalPages) {
                    [strongSelf.tableView removeLoadMoreActionHandler];
                }
                
                self.currentPage = self.currentPage +1 ;
                
                [strongSelf.tableView stopLoadMoreAnimation];
                strongSelf.isLoading =NO;
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
        
        
        [self.getData OrderHistory:st.accesstoken Page:[NSString stringWithFormat:@"%ld",(long)self.currentPage] withCallback:callback];
    

}

- (void)GetBill:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    if (indexPath != nil)
    {
        OrderHistory *item = [[OrderHistory alloc]init];
        item = [tableItems objectAtIndex:indexPath.row];
        
        FCAlertView *alert = [[FCAlertView alloc] init];
        
        [alert showAlertInView:self
                     withTitle:@"رسید سفارش"
                  withSubtitle:@"آیا مایل به دریافت رسید از طریق ایمیل هستید؟"
               withCustomImage:[UIImage imageNamed:@"alert.png"]
           withDoneButtonTitle:@"بله"
                    andButtons:nil];
        [alert addButton:@"خیر" withActionBlock:^{
            // Put your action here
        }];
        [alert doneActionBlock:^{
            [self RequestBill:item.orderId];
        }];
        
    }
}

-(void)RequestBill:(NSString*)orderId
{
    
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
        
        if (wasSuccessful) {
     
            FCAlertView *alert = [[FCAlertView alloc] init];
            [alert makeAlertTypeSuccess];
            [alert showAlertInView:self
                         withTitle:nil
                      withSubtitle:@"رسید سفارش به ایمیل وارد شده در حساب کاربری شما ارسال شد"
                   withCustomImage:[UIImage imageNamed:@"alert.png"]
               withDoneButtonTitle:@"تایید"
                        andButtons:nil];
            
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
    
    [self.getData SendBill:st.accesstoken OrderId:orderId withCallback:callback];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return tableItems.count;
    //return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell";
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell)
        cell = [[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    
    
    cell.layerView.layer.cornerRadius = 5;
    cell.emailButton.layer.cornerRadius = 5;
    cell.emailButton.layer.masksToBounds = NO;
    [cell.emailButton addTarget:self action:@selector(GetBill:) forControlEvents:UIControlEventTouchUpInside];
    cell.background.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.background.layer.shadowOffset = CGSizeMake(1, 1.f);
    cell.background.layer.shadowRadius = 5;
    cell.background.layer.shadowOpacity = 0.3;
    cell.background.layer.cornerRadius = 5;
    
    cell.background.layer.masksToBounds = NO;
    
    OrderHistory *item = [[OrderHistory alloc]init];
    item = [tableItems objectAtIndex:indexPath.row];
    
    cell.fullnameLabel.text = item.employeeName;
    cell.fullnameLabelDetail.text = item.employeeName;
    cell.orderTypeLabel.text = [self OrderType:item];
    cell.payinDestinationLabel.text = [self PaymentTypes:item];
    cell.orderStatus.text = [self StatusTypes:item];
    cell.roundTripLabel.text = [item.haveReturn isEqualToString:@"1"] ? @"رفت و برگشت":@"یکطرفه";
    cell.orderNumberLabel.text = item.orderNumber;
    cell.addressLabel.text = [item.sourceAddress isEqual:[NSNull null]] ? @"-" : item.sourceAddress;
    cell.quickAddressLabel.text = [item.sourceAddress isEqual:[NSNull null]] ? @"-" : item.sourceAddress;
    cell.destinationAddressLabel.text = [item.destinationAddress isEqual:[NSNull null]] ? @"-" :item.destinationAddress;
    cell.quickDestinationAddressLabel.text = [item.destinationAddress isEqual:[NSNull null]] ? @"-" :item.destinationAddress;
    cell.dateTimeLabel.text = [MapCharacter MapCharacter:item.orderTime];
    
    cell.sourceAddressInfoLabel.text = [NSString stringWithFormat:@"پلاک  %@  زنگ یا واحد  %@",item.sourcePlate,item.sourceBell];
    
    NSString *displayString = [NSString stringWithFormat:@"پلاک  %@  زنگ یا واحد  %@  شماره همراه گیرنده  %@  نام گیرنده  %@",item.destinationPlate,item.destinationBell,item.destinationPhoneNumber,item.destinationFullName];
    
    cell.destinationAddressInfoLabel.lineBreakMode = NSLineBreakByClipping;
    cell.destinationAddressInfoLabel.text = [displayString stringByAppendingString:@"\n\n\n\n"];
    
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[item.price integerValue]]];
    cell.priceLabel.text =[NSString stringWithFormat:@"%@ تومان" ,[MapCharacter MapCharacter:[NSString stringWithFormat:@"%@",formatted]]];
    cell.priceLabelDetail.text =[NSString stringWithFormat:@"%@ تومان" ,[MapCharacter MapCharacter:[NSString stringWithFormat:@"%@",formatted]]];
    
    if ([item.status isEqualToString:@"6"] || [item.status isEqualToString:@"7"]) {
        cell.layerView.backgroundColor = [UIColor grayColor];
    }
    else
        cell.layerView.backgroundColor = [UIColor colorWithRed:118/255.f green:106/255.f blue:247/255.f alpha:1];

    
    if ([indexPath compare:selectedIndexPath] != NSOrderedSame) {
        cell.layerView.alpha= .7;
        cell.fullnameLabel.alpha = 1;
        cell.dateTimeLabel.alpha = 1;
        cell.priceLabel.alpha = 1;
        cell.orderStatus.alpha = 1;
        cell.orderNumberLabel.alpha = 1;
    }
    else
    {
        cell.layerView.alpha= 0;
        cell.fullnameLabel.alpha = 0;
        cell.dateTimeLabel.alpha = 0;
        cell.priceLabel.alpha = 0;
        cell.orderStatus.alpha = 0;
        cell.orderNumberLabel.alpha = 0;
    }
    
    NSString *staticMapUrl = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?autoscale=2&visual_refresh=true&markers=icon:http://kaskett.ir/content/images/sourcemarker.png|%@,%@&markers=icon:http://kaskett.ir/content/images/destinationmarker.png|%@,%@&%@",item.sourceLat, item.sourceLon,item.destinationLat ,item.destinationLon,[NSString stringWithFormat:@"size=%dx%d",2*(int)cell.mapView.frame.size.width, 2*(int)cell.mapView.frame.size.height]];
    
    NSURL *mapUrl = [NSURL URLWithString:[staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [cell.mapView setImageWithURL:mapUrl
                   placeholderImage:nil options:SDWebImageRefreshCached usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [cell.mapView setClipsToBounds:YES];
    cell.mapView.layer.cornerRadius = 5;
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath compare:selectedIndexPath] != NSOrderedSame) {
        [UIView animateWithDuration:.6 animations:^()
         {
             lastCell.layerView.alpha=.7;
             lastCell.fullnameLabel.alpha = 1;
             lastCell.quickAddressLabel.alpha = 1;
             lastCell.quickDestinationAddressLabel.alpha = 1;
             lastCell.dateTimeLabel.alpha = 1;
             lastCell.priceLabel.alpha = 1;
             lastCell.orderStatus.alpha = 1;
             lastCell.orderNumberLabel.alpha = 1;
             lastCell.mapView.layer.cornerRadius = 5;
         }];
    }
    
    selectedIndexPath = indexPath;
    
    HistoryTableViewCell *cell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
    lastCell = cell;
    [UIView animateWithDuration:.6 animations:^()
    {
        cell.layerView.alpha=0;
        cell.fullnameLabel.alpha = 0;
        cell.quickAddressLabel.alpha = 0;
        cell.quickDestinationAddressLabel.alpha = 0;
        cell.dateTimeLabel.alpha = 0;
        cell.priceLabel.alpha = 0;
        cell.orderStatus.alpha = 0;
        cell.orderNumberLabel.alpha = 0;
        cell.mapView.layer.cornerRadius = 0;
        
    }];
    
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath compare:selectedIndexPath] == NSOrderedSame) {
        
        return  440;
    }
    else
    {
        
        return 162;
    } 
}

-(void)CustomizeNavigationTitle
{
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=@"فعالیت ها";
    label.textColor=[UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font = [UIFont fontWithName:@"IRANSans" size:17];
    label.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView=label;
    
    // Get the previous view controller
    UIViewController *previousVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 1];
    // Create a UIBarButtonItem
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(popViewController)];
    // Associate the barButtonItem to the previous view
    [previousVC.navigationItem setBackBarButtonItem:barButtonItem];
    
    UIButton *settingButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *settingImage = [[UIImage imageNamed:@"close.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [settingButton setImage:settingImage forState:UIControlStateNormal];

    settingButton.tintColor = [UIColor whiteColor];
    [settingButton addTarget:self action:@selector(closeButtonAction)forControlEvents:UIControlEventTouchUpInside];
    [settingButton setFrame:CGRectMake(0, 0, 15, 15)];
    
    
    UIBarButtonItem *settingBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    self.navigationItem.leftBarButtonItem = settingBarButton;
    
}

-(NSString*)OrderType:(OrderHistory*)order
{

    switch ([order.orderType integerValue]) {
        case 0:
            return @"ارسال بسته";
            break;
        case 1:
            return @"شخص";
            break;
        default:
            break;
    }
    
    return @"";

}

-(NSString*)StatusTypes:(OrderHistory*)order
{
    
    switch ([order.status integerValue]) {
        case 5:
            return @"";
            break;
        case 6:
            return @"لغو شده توسط سرویس دهنده";
            break;
        default:
            break;
    }
    
    return @"";
    
}

-(NSString*)PaymentTypes:(OrderHistory*)order
{
    
    switch ([order.payInDestination integerValue]) {
        case 1:
            return @"پرداخت توسط گیرنده";
            break;
        default:
        {
            if ([order.paymentStatus integerValue] == 1) {
                return @"پرداخت نقدی توسط فرستنده";
            }
            else if ([order.paymentStatus integerValue] == 2)
                return @"پرداخت اعتباری توسط فرستنده";
            else if ([order.paymentStatus integerValue] == 0)
                return @"پرداخت نشده";
        }
            break;
    }
    
    return @"";
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
