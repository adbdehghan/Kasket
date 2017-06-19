//
//  TuturialViewController.m
//  Motori
//
//  Created by adb on 6/19/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import "TuturialViewController.h"
#import "EAIntroView.h"


@interface TuturialViewController () <EAIntroDelegate>
{
UIView *rootView;
EAIntroView *_intro;
}
@end

@implementation TuturialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    rootView = self.navigationController.view;
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = @"";
    page1.bgImage = [UIImage imageNamed:@"BG.jpg"];
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1"]];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.desc = @"";
    page2.bgImage = [UIImage imageNamed:@"BG.jpg"];
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2"]];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.desc = @"";
    page3.bgImage = [UIImage imageNamed:@"BG.jpg"];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3"]];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"This is page 4";
    page4.desc = @"";
    page4.bgImage = [UIImage imageNamed:@"BG.jpg"];
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"4"]];
    
    EAIntroPage *page5 = [EAIntroPage page];
    page5.title = @"This is page 4";
    page5.desc = @"";
    page5.bgImage = [UIImage imageNamed:@"BG.jpg"];
    page5.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"5"]];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3,page4,page5]];
    intro.skipButtonAlignment = EAViewAlignmentCenter;
    intro.skipButtonY = 80.f;
    intro.pageControlY = 42.f;
    
    [intro setDelegate:self];
    
    [intro showInView:rootView animateDuration:0.3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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