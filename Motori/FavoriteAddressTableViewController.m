//
//  FavoriteAddressTableViewController.m
//  Motori
//
//  Created by aDb on 3/23/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import "FavoriteAddressTableViewController.h"
#import "DataCollector.h"
#import "DBManager.h"
#import "FavoriteTableViewCell.h"
#import "Destination.h"
#import "Source.h"

@interface FavoriteAddressTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *tableItems;
}
@end

@implementation FavoriteAddressTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CustomizeNavigationTitle];
    
    NSMutableArray *sourceTableItems = [DBManager selectSourceTable];
    NSMutableArray *destinationTableItems = [DBManager selectDestinationTable];
    tableItems = [NSMutableArray arrayWithArray:sourceTableItems];
    [tableItems addObjectsFromArray: destinationTableItems];
    [self.addressTableView reloadData];
}

-(void)AddEvent
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([[tableItems objectAtIndex:indexPath.row] isKindOfClass:[Destination class]]) {
        FavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"destinationCellIdentifier"];
        if (!cell)
            cell = [[FavoriteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"destinationCellIdentifier"];
        Destination *destination = [tableItems objectAtIndex:indexPath.row];
        cell.addressLabel.text = destination.destinationAddress;
        cell.plateLabel.text = destination.destinationPlate;
        cell.bellLabel.text = destination.destinationBell;
        cell.fullNameLabel.text = destination.destinationFullName;
        cell.phoneNumberLabel.text = destination.destinationPhoneNumber;
        return cell;
    }
    else
    {
        FavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
        if (!cell)
            cell = [[FavoriteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
        Source *source = [tableItems objectAtIndex:indexPath.row];
        cell.addressLabel.text = source.sourceAddress;
        cell.plateLabel.text = source.sourcePlate;
        cell.bellLabel.text = source.sourceBell;
        return cell;
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        
        if ([[tableItems objectAtIndex:indexPath.row] isKindOfClass:[Destination class]]) {
            
            Destination *destination = [tableItems objectAtIndex:indexPath.row];
            [DBManager deleteRow:destination.destinationId FromTable:@"DestinationTable"];
            
            NSMutableArray *sourceTableItems = [DBManager selectSourceTable];
            NSMutableArray *destinationTableItems = [DBManager selectDestinationTable];
            tableItems = [NSMutableArray arrayWithArray:sourceTableItems];
            [tableItems addObjectsFromArray: destinationTableItems];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }
        else
        {
            Source *source = [tableItems objectAtIndex:indexPath.row];
            [DBManager deleteRow:source.sourceId FromTable:@"SourceTable"];
            NSMutableArray *sourceTableItems = [DBManager selectSourceTable];
            NSMutableArray *destinationTableItems = [DBManager selectDestinationTable];
            tableItems = [NSMutableArray arrayWithArray:sourceTableItems];
            [tableItems addObjectsFromArray: destinationTableItems];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
         
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[tableItems objectAtIndex:indexPath.row] isKindOfClass:[Destination class]]) {
        
        return 183;
    }
    else
    {
        return 145;
    }
}

-(void)CustomizeNavigationTitle
{
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=@"آدرس های منتخب";
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
