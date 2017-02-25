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

@import GoogleMaps;
@interface HistoryTableViewController ()
{
    NSMutableArray *tableItems;
    UIActivityIndicatorView *activityIndicator;
    UILabel *clearMessage;
    NSIndexPath *selectedIndexPath;
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
                
                for (NSDictionary *item in (NSMutableArray*)data) {
                    OrderHistory *order = [[OrderHistory alloc]init];
                    order.destinationFullName = [item valueForKey:@"fullName"];
                    order.sourceAddress =[item valueForKey:@"sourceAddress"];
                    order.destinationAddress =[item valueForKey:@"destinationAddress"];
                    order.orderTime =[item valueForKey:@"ordertime"];
                    order.price = [item valueForKey:@"price"];
                    order.sourceLat = [item valueForKey:@"sourceLat"];
                    order.sourceLon = [item valueForKey:@"sourceLon"];
                    order.destinationLat = [item valueForKey:@"destinationLat"];
                    order.destinationLon = [item valueForKey:@"destinationLon"];
                    //self.totalPages = [[item valueForKey:@"totalpage"] integerValue];
                    
                    [tableItems addObject:order];
                    [temp addObject:order];
                }
                
                [activityIndicator stopAnimating];
                
                if (temp.count == 0) {
                  //  clearMessage.alpha = 1;
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
                                                      cancelButtonTitle:@"خب"
                                                      otherButtonTitles:nil];
                [alert show];
                
                
                NSLog( @"Unable to fetch Data. Try again.");
            }
        };
        
        Settings *st = [[Settings alloc]init];
        
        st = [DBManager selectSetting][0];
        
        
        [self.getData OrderHistory:st.accesstoken Page:[NSString stringWithFormat:@"%ld",(long)self.currentPage] withCallback:callback];
    

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
    
    //return tableItems.count;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell";
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell)
        cell = [[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    
    OrderHistory *item = [[OrderHistory alloc]init];
   // item = [tableItems objectAtIndex:indexPath.row];
    
    cell.fullnameLabel.text = item.destinationFullName;
    cell.addressLabel.text = item.sourceAddress;
    cell.dateTimeLabel.text = item.orderTime;
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[item.price integerValue]]];
    cell.priceLabel.text =[NSString stringWithFormat:@"%@",formatted];
    
    if (cell.mapView.subviews.count == 0) {
        GMSMapView *mapView;
        GMSCameraPosition *mainCamera = [GMSCameraPosition cameraWithLatitude:[item.sourceLat doubleValue]
                                                                longitude:[item.sourceLon doubleValue]
                                                                     zoom:15];
        
        mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, cell.mapView.frame.size.width, cell.mapView.frame.size.height) camera:mainCamera];
        
        mapView.myLocationEnabled = NO;
        mapView.userInteractionEnabled = NO;
        
        [cell.mapView addSubview:mapView];
        
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([item.sourceLat doubleValue],[item.sourceLon doubleValue]);
        marker.snippet = @"";
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.icon =[UIImage imageWithPDFNamed:@"sourcemarker.pdf"
                                      fitInSize:CGSizeMake(50, 50)];
        marker.map = mapView;
        
        GMSMarker *desmarker = [[GMSMarker alloc] init];
        desmarker.appearAnimation = YES;
        desmarker.flat = YES;
        desmarker.position = CLLocationCoordinate2DMake([item.destinationLat doubleValue],[item.destinationLon doubleValue]);
        desmarker.map = mapView;
        desmarker.icon =  [UIImage imageWithPDFNamed:@"destinationmarker.pdf"
                                           fitInSize:CGSizeMake(50, 50)];
        
        GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:marker.position coordinate:desmarker.position];
        GMSCameraPosition *camera = [mapView cameraForBounds:bounds insets:UIEdgeInsetsMake(30, 30, 30, 30)];
        
        [mapView animateToCameraPosition:camera];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedIndexPath = indexPath;
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath compare:selectedIndexPath] == NSOrderedSame) {
        
        return  300;
    }
    else
    {
        
        return 150;
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
    
    UIImage *settingImage = [[UIImage imageNamed:@"close.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [settingButton setImage:settingImage forState:UIControlStateNormal];

    settingButton.tintColor = [UIColor whiteColor];
    [settingButton addTarget:self action:@selector(closeButtonAction)forControlEvents:UIControlEventTouchUpInside];
    [settingButton setFrame:CGRectMake(0, 0, 15, 15)];
    
    
    UIBarButtonItem *settingBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    self.navigationItem.leftBarButtonItem = settingBarButton;
    
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
