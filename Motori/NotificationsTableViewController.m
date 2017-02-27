//
//  NotificationsTableViewController.m
//  Wash Me
//
//  Created by adb on 11/22/16.
//  Copyright © 2016 Arena. All rights reserved.
//

#import "NotificationsTableViewController.h"
#import "DataDownloader.h"
#import "Settings.h"
#import "DBManager.h"
#import "UIScrollView+UzysAnimatedGifLoadMore.h"
#import "Notification.h"
#import "NotificationTableViewCell.h"
#import "MapCharacter.h"


@interface NotificationsTableViewController ()
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

@implementation NotificationsTableViewController

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
    clearMessage.text = @"در حال حاضر هیچ پیامی موجود نیست";
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
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 80;
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
                Notification *notification = [[Notification alloc]init];
                notification.Content = [item valueForKey:@"content"];
                notification.Time =[item valueForKey:@"time"];
                self.totalPages = [[item valueForKey:@"totalpage"] integerValue];
                
                [tableItems addObject:notification];
                [temp addObject:notification];
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
    
    
    [self.getData Notifications:st.accesstoken Page:[NSString stringWithFormat:@"%ld",(long)self.currentPage] withCallback:callback];
    
    
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
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell)
        cell = [[NotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    
    Notification *item = [[Notification alloc]init];
    item = [tableItems objectAtIndex:indexPath.row];
    
    
    cell.backgroundColor = [UIColor clearColor];
    cell.containerView.layer.shadowOffset = CGSizeMake(0, 0);
    cell.containerView.layer.shadowRadius = 2;
    cell.containerView.layer.shadowOpacity = 0.15;
    cell.containerView.layer.cornerRadius = 8;
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:item.Content];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    //    paragraphStyle.alignment = NSTextAlignmentJustified;    // To justified text
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [item.Content length])];
    
    cell.contentLabel.attributedText = attributedString;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dateTimeLabel.font =[UIFont fontWithName:@"IRANSans" size:15];
    cell.dateTimeLabel.text = [ NSString stringWithFormat:@"%@",[MapCharacter MapCharacter:item.Time]];
    cell.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.contentLabel.numberOfLines = 0;
    
    
    [cell.contentLabel setTextAlignment:NSTextAlignmentRight];
    [cell.contentLabel setFont:[UIFont fontWithName:@"IRANSans" size:15]];
    [cell.contentLabel sizeToFit];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableItems  count]>0) {
         Notification *item = [[Notification alloc]init];
        item =[tableItems objectAtIndex:indexPath.row];
        NSString *cellText = item.Content;
        
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:cellText];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        //    paragraphStyle.alignment = NSTextAlignmentJustified;    // To justified text
        
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [cellText length])];
        
        UILabel *textLabel = [[UILabel alloc]init];
        
        textLabel.frame =CGRectMake(0, 0,tableView.bounds.size.width - 30 ,9999 );
        
        textLabel.attributedText = attributedString;
        
        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        textLabel.numberOfLines = 0;
        [textLabel setTextAlignment:NSTextAlignmentRight];
        [textLabel setFont:[UIFont fontWithName:@"IRANSans" size:15]];
        
        [textLabel sizeToFit];
        
        int size = textLabel.frame.size.height;
        
        return size + 78;
    }
    
    else
        
        return 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)CustomizeNavigationTitle
{
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=@"پیام ها";
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



@end
