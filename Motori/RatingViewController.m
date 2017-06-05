//
//  RatingViewController.m
//  Motori
//
//  Created by adb on 6/5/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import "RatingViewController.h"
#import "TPFloatRatingView.h"

@interface RatingViewController ()<TPFloatRatingViewDelegate>
{
    float ratingValue;
    NSInteger *selectedRow;
    NSArray *reasonArray;

}
@property (strong, nonatomic) IBOutlet TPFloatRatingView *ratingView;
@end

@implementation RatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    ratingValue = rating;
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
