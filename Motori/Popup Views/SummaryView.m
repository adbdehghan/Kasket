//
//  SummaryView.m
//  Motori
//
//  Created by adb on 2/17/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import "SummaryView.h"
#import "CNPPopupController.h"
#import "DataCollector.h"

@implementation SummaryView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *dotView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2 - 12, 31, 12,12)];
        dotView.layer.cornerRadius = dotView.frame.size.width/2;
        dotView.backgroundColor = [UIColor colorWithRed:118/255.f green:106/255.f blue:247/255.f alpha:1];
        dotView.clipsToBounds = YES;
        [self addSubview:dotView];
        
        UILabel *sourceAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 10, frame.size.width-8, 15)];
        sourceAddressLabel.backgroundColor = [UIColor clearColor];
        sourceAddressLabel.textAlignment = NSTextAlignmentCenter;
        sourceAddressLabel.textColor = [UIColor darkGrayColor];
        sourceAddressLabel.font = [UIFont fontWithName:@"IRANSans" size:12];
        sourceAddressLabel.text =[DataCollector sharedInstance].sourceAddress;
        [self addSubview:sourceAddressLabel];
        
        UILabel *destinationAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 35, frame.size.width-8, 15)];
        destinationAddressLabel.backgroundColor = [UIColor clearColor];
        destinationAddressLabel.textAlignment = NSTextAlignmentCenter;
        destinationAddressLabel.textColor = [UIColor darkGrayColor];
        destinationAddressLabel.font = [UIFont fontWithName:@"IRANSans" size:12];
        destinationAddressLabel.text =[DataCollector sharedInstance].destinationAddress;
        [self addSubview:destinationAddressLabel];
        
        UIView *sepratorView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 37, frame.size.width-100 , 1)];
        [sepratorView setBackgroundColor:[UIColor colorWithRed:118/255.f green:106/255.f blue:247/255.f alpha:1]];
        sepratorView.userInteractionEnabled = NO;
        sepratorView.alpha = .3f;
        [self addSubview:sepratorView];
        
        plateTextField = [[UITextField alloc]initWithFrame:CGRectMake(3*(frame.size.width/4)-35, 54, 70, 30)];
        plateTextField.keyboardType = UIKeyboardTypeDefault;
        plateTextField.font = [UIFont fontWithName:@"IRANSans" size:14];
        plateTextField.borderStyle = UITextBorderStyleNone;
        plateTextField.returnKeyType = UIReturnKeyDone;
        plateTextField.textAlignment = NSTextAlignmentCenter;
        plateTextField.placeholder = @"پلاک";
        [self addSubview:plateTextField];
        
        UIView *plateTextFieldView = [[UIImageView alloc] initWithFrame:CGRectMake(plateTextField.frame.origin.x, plateTextField.frame.origin.y+30, 70 , 1)];
        [plateTextFieldView setBackgroundColor:[UIColor colorWithRed:118/255.f green:106/255.f blue:247/255.f alpha:1]];
        plateTextFieldView.userInteractionEnabled = NO;
        plateTextFieldView.alpha = .3f;
        [self addSubview:plateTextFieldView];
        
        
        bellTextField = [[UITextField alloc]initWithFrame:CGRectMake(frame.size.width/4-35, 54, 70, 30)];
        bellTextField.keyboardType = UIKeyboardTypeDefault;
        bellTextField.font = [UIFont fontWithName:@"IRANSans" size:14];
        bellTextField.borderStyle = UITextBorderStyleNone;
        bellTextField.returnKeyType = UIReturnKeyDone;
        bellTextField.textAlignment = NSTextAlignmentCenter;
        bellTextField.placeholder = @"واحد / زنگ";
        [self addSubview:bellTextField];
        
        UIView *bellTextFieldView = [[UIImageView alloc] initWithFrame:CGRectMake(bellTextField.frame.origin.x, bellTextField.frame.origin.y+30, 70 , 1)];
        [bellTextFieldView setBackgroundColor:[UIColor colorWithRed:52/255.f green:77/255.f blue:146/255.f alpha:1]];
        bellTextFieldView.userInteractionEnabled = NO;
        bellTextFieldView.alpha = .3f;
        [self addSubview:bellTextFieldView];
        
        
        CNPPopupButton *button = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, frame.size.height-50, frame.size.width, 50)];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"IRANSans" size:16];
        [button setTitle:@"درخواست کاسکت" forState:UIControlStateNormal];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = button.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)([UIColor colorWithRed:118/255.f green:106/255.f blue:247/255.f alpha:1].CGColor),(id)( [UIColor colorWithRed:52/255.f green:77/255.f blue:146/255.f alpha:1].CGColor),nil];
        gradient.startPoint = CGPointMake(0.5,0.0);
        gradient.endPoint = CGPointMake(0.5,1.0);
        [button.layer addSublayer:gradient];
        
        
        button.selectionHandler = ^(CNPPopupButton *button){
            [self ForwardClicked];
            
        };
        
        [self addSubview:button];
    }
    return self;
}

-(void)ForwardClicked
{
    if([self.delegate respondsToSelector:@selector(ForwardClicked)])
    {
        [DataCollector sharedInstance].destinationBell = bellTextField.text;
        [DataCollector sharedInstance].destinationPlate = plateTextField.text;
        
        
        [self.delegate ForwardClicked];
        
    }
    
}



@end
