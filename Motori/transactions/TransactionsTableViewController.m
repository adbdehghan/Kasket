//
//  TransactionsTableViewController.m
//  Wash Me
//
//  Created by adb on 11/17/16.
//  Copyright © 2016 Arena. All rights reserved.
//

#import "TransactionsTableViewController.h"
#import "DataDownloader.h"
#import "Settings.h"
#import "DBManager.h"
#import "UIScrollView+UzysAnimatedGifLoadMore.h"
#import "Transaction.h"
#import "TransactionTableViewCell.h"
#import "MapCharacter.h"

@interface TransactionsTableViewController ()
{
    NSMutableArray *tableItems;
    UIActivityIndicatorView *activityIndicator;
    UILabel *clearMessage;
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

@implementation TransactionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CustomizeNavigationTitle];
    [self InitialObjects];
    if(IS_IOS7 || IS_IOS8)
        self.automaticallyAdjustsScrollViewInsets = YES;
    
    clearMessage = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.center.y - 60, self.view.frame.size.width,30 )];
    clearMessage.textColor=[UIColor grayColor];
    clearMessage.backgroundColor =[UIColor clearColor];
    clearMessage.font = [UIFont fontWithName:@"IRANSans" size:16];
    clearMessage.textAlignment = NSTextAlignmentCenter;
    clearMessage.text = @"هیج تراکنشی انجام نشده است";
    clearMessage.alpha = 0;
    [self.view addSubview:clearMessage];
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
    self.tableView.backgroundColor = [UIColor colorWithRed:250/255.f green:250/255.f blue:250/255.f alpha:1];
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
}

- (void)loadNextBatch {
    self.isLoading =YES;
    __weak typeof(self) weakSelf = self;
    typeof(self) strongSelf = weakSelf;
    
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
        if (wasSuccessful) {
            NSMutableArray *temp = [[NSMutableArray alloc]init];
            
            for (NSDictionary *item in (NSMutableArray*)data) {
                Transaction *transaction = [[Transaction alloc]init];
                transaction.Amount = [item valueForKey:@"amount"];
                transaction.Desc =[item valueForKey:@"des"];
                transaction.Time =[item valueForKey:@"time"];
                transaction.IsIncrease = [item valueForKey:@"isincrease"];
                self.totalPages = [[item valueForKey:@"totalpage"] integerValue];
                
                [tableItems addObject:transaction];
                [temp addObject:transaction];
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
                                                  cancelButtonTitle:@"خب"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
            NSLog( @"Unable to fetch Data. Try again.");
        }
    };
    
    Settings *st = [[Settings alloc]init];
    
    st = [DBManager selectSetting][0];
    
    
    [self.getData Transactions:st.accesstoken Page:[NSString stringWithFormat:@"%ld",(long)self.currentPage] withCallback:callback];
    
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    Manually trigger
    [self.tableView triggerLoadMoreActionHandler];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return tableItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell";
    TransactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell)
        cell = [[TransactionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    
    Transaction *item = [[Transaction alloc]init];
    item = [tableItems objectAtIndex:indexPath.row];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[item.Amount integerValue]]];
    cell.amountLabel.text =[MapCharacter MapCharacter:formatted];
    cell.dateTimeLabel.text =[MapCharacter MapCharacter:item.Time];
    cell.descLabel.text = item.Desc;
    cell.backgroundColor = [UIColor clearColor];
    cell.statusImageView.layer.shadowOffset = CGSizeMake(0, 0);
    cell.statusImageView.layer.shadowRadius = 3;
    cell.statusImageView.layer.shadowOpacity = 0.2;
    
    
    cell.containerView.layer.shadowOffset = CGSizeMake(0, 0);
    cell.containerView.layer.shadowRadius = 2;
    cell.containerView.layer.shadowOpacity = 0.15;
    cell.containerView.layer.cornerRadius = 8;
    
    if ([item.IsIncrease boolValue] == YES) {
        cell.statusImageView.image = [UIImage imageNamed:@"up-arrow.png"];
        cell.statusLabel.text = @"ریال افزایش اعتبار";
    }
    else
    {
        cell.statusImageView.image = [UIImage imageNamed:@"down-arrow.png"];
        cell.statusLabel.text =@"ریال کاهش اعتبار";
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)CustomizeNavigationTitle
{
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=@"گردش حساب";
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
//    [previousVC.navigationItem setBackBarButtonItem:barButtonItem];
    
    UIButton *settingButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *settingImage = [[UIImage imageNamed:@"close.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [settingButton setImage:settingImage forState:UIControlStateNormal];
    settingButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    settingButton.tintColor = [UIColor whiteColor];
    [settingButton addTarget:self action:@selector(closeButtonAction)forControlEvents:UIControlEventTouchUpInside];
    [settingButton setFrame:CGRectMake(0, 0, 15, 15)];
    
    
    UIBarButtonItem *settingBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    self.navigationItem.leftBarButtonItem = settingBarButton;
    
    UIButton *raiseButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *raiseImage = [[UIImage imageNamed:@"add"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [raiseButton setImage:raiseImage forState:UIControlStateNormal];
    raiseButton.titleLabel.text = @"+";
    raiseButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    raiseButton.tintColor = [UIColor whiteColor];
    [raiseButton addTarget:self action:@selector(raiseButtonAction)forControlEvents:UIControlEventTouchUpInside];
    [raiseButton setFrame:CGRectMake(0, 0, 15, 15)];
    
    
    UIBarButtonItem *raiseBarButton = [[UIBarButtonItem alloc] initWithCustomView:raiseButton];
    self.navigationItem.rightBarButtonItem = raiseBarButton;
    
}

-(void)closeButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)raiseButtonAction
{
    [self performSegueWithIdentifier:@"raisecredit" sender:self];
}


- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
}


@end
