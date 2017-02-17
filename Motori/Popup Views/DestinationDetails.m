//
//  DestinationDetails.m
//  Motori
//
//  Created by adb on 2/15/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import "DestinationDetails.h"
#import "CNPPopupController.h"
#import "DataCollector.h"

@implementation DestinationDetails

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *dotView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2 - 12, 31, 12,12)];
        dotView.layer.cornerRadius = dotView.frame.size.width/2;
        dotView.backgroundColor = [UIColor colorWithRed:118/255.f green:106/255.f blue:247/255.f alpha:1];
        dotView.clipsToBounds = YES;
        [self addSubview:dotView];
        
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 10, frame.size.width-8, 15)];
        addressLabel.backgroundColor = [UIColor clearColor];
        addressLabel.textAlignment = NSTextAlignmentCenter;
        addressLabel.textColor = [UIColor darkGrayColor];
        addressLabel.font = [UIFont fontWithName:@"IRANSans" size:12];
        addressLabel.text =[DataCollector sharedInstance].destinationAddress;
        [self addSubview:addressLabel];
        
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
        [button setTitle:@"ادامه" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:118/255.f green:106/255.f blue:247/255.f alpha:1];
        
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
