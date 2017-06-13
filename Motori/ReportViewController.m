//
//  ReportViewController.m
//  Motori
//
//  Created by adb on 6/12/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()<UIWebViewDelegate>
{
    UIActivityIndicatorView *activityIndicator;
}
@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CustomizeNavigationTitle];
    
    faqWebView.opaque = NO;
    faqWebView.backgroundColor = [UIColor clearColor];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [activityIndicator startAnimating];
    
    NSString *urlAddress = @"http://kaskett.ir/home/faq";
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [faqWebView loadRequest:requestObj];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityIndicator stopAnimating];
    NSString *cssString = @"body { font-family:IRANSans;direction:rtl; background-color: transparent }"; // 1
    NSString *javascriptString = @"var style = document.createElement('style'); style.innerHTML = '%@'; document.head.appendChild(style)"; // 2
    NSString *javascriptWithCSSString = [NSString stringWithFormat:javascriptString, cssString]; // 3
    [webView stringByEvaluatingJavaScriptFromString:javascriptWithCSSString]; // 4
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)CustomizeNavigationTitle
{
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=@"گزارش";
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
