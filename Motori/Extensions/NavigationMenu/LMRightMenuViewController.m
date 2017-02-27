//
//  LMRightMenuViewController.m
//  LMSideBarControllerDemo
//
//  Created by LMinh on 10/11/15.
//  Copyright © 2015 LMinh. All rights reserved.
//

#import "LMRightMenuViewController.h"
#import "UIViewController+LMSideBarController.h"
#import "MMCell.h"
#import "DataDownloader.h"
#import "Settings.h"
#import "DBManager.h"
#import "FCAlertView.h"
#import "MapCharacter.h"

@interface LMRightMenuViewController ()

@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) NSArray *menuImages;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) DataDownloader *getData;

@end

@implementation LMRightMenuViewController

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuTitles = @[@"افزایش اعتبار", @"فعالیت ها",@"پیام ها", @"کد هدیه", @"مکان های منتخب", @"درباره ما",@"خروج"];
    self.menuImages = @[@"creditcard",@"archive",@"notification",@"giftcode",@"adress",@"aboutus",@"logout"];
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.height/2;
    self.avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarImageView.layer.borderWidth = 1.0f;
    self.avatarImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.avatarImageView.layer.shouldRasterize = YES;
    
    [self Credit];
}

-(void)Credit
{
    
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
        
        if (wasSuccessful) {
            
           
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[[data valueForKey:@"credit"] integerValue]]];
            
            self.credit.text = [NSString stringWithFormat:@"%@ تومان",[MapCharacter MapCharacter:formatted]];
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
    
    [self.getData Credit:st.accesstoken withCallback:callback];
}

-(IBAction)ProfileButtonPressed:(id)sender
{


}

#pragma mark - TABLE VIEW DATASOURCE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"menuCell";
    MMCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.mmlabel.text = self.menuTitles[indexPath.row];
    cell.mmlabel.font = [UIFont fontWithName:@"IRANSans" size:15];
    cell.mmlabel.textAlignment = NSTextAlignmentRight;
    cell.mmlabel.textColor = [UIColor colorWithWhite:1 alpha:1];
    
    cell.mmimageView.image = [UIImage imageNamed:self.menuImages[indexPath.row]];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


#pragma mark - TABLE VIEW DELEGATE

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"credit" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"activities" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"notification" sender:self];
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
        {
            FCAlertView *alert = [[FCAlertView alloc] init];
            
            [alert showAlertInView:self
                         withTitle:@"خروج از کاسکت"
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
            break;
        default:
            break;
    }
    
    [self.sideBarController hideMenuViewController:YES];
}

- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
}

@end
