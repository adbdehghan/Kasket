//
//  sourceDetails.m
//  Motori
//
//  Created by aDb on 2/12/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import "sourceDetails.h"
#import "CNPPopupController.h"
#import "DataCollector.h"
#import "DBManager.h"

@implementation sourceDetails

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *dotView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2 - 12, 31, 12,12)];
        dotView.layer.cornerRadius = dotView.frame.size.width/2;
        dotView.backgroundColor = [UIColor colorWithRed:52/255.f green:77/255.f blue:146/255.f alpha:1];
        dotView.clipsToBounds = YES;
        [self addSubview:dotView];
        
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 10, frame.size.width-8, 15)];
        addressLabel.backgroundColor = [UIColor clearColor];
        addressLabel.textAlignment = NSTextAlignmentCenter;
        addressLabel.textColor = [UIColor darkGrayColor];
        addressLabel.font = [UIFont fontWithName:@"IRANSans" size:12];
        addressLabel.text =[DataCollector sharedInstance].sourceAddress;
        [self addSubview:addressLabel];
        
        UIView *sepratorView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 37, frame.size.width-100 , 1)];
        [sepratorView setBackgroundColor:[UIColor colorWithRed:52/255.f green:77/255.f blue:146/255.f alpha:1]];
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
        plateTextField.text = [DataCollector sharedInstance].sourcePlate;;
        [self addSubview:plateTextField];
        
        UIView *plateTextFieldView = [[UIImageView alloc] initWithFrame:CGRectMake(plateTextField.frame.origin.x, plateTextField.frame.origin.y+30, 70 , 1)];
        [plateTextFieldView setBackgroundColor:[UIColor colorWithRed:52/255.f green:77/255.f blue:146/255.f alpha:1]];
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
        bellTextField.text = [DataCollector sharedInstance].sourceBell;;
        [self addSubview:bellTextField];
        
        UIView *bellTextFieldView = [[UIImageView alloc] initWithFrame:CGRectMake(bellTextField.frame.origin.x, bellTextField.frame.origin.y+30, 70 , 1)];
        [bellTextFieldView setBackgroundColor:[UIColor colorWithRed:52/255.f green:77/255.f blue:146/255.f alpha:1]];
        bellTextFieldView.userInteractionEnabled = NO;
        bellTextFieldView.alpha = .3f;
        [self addSubview:bellTextFieldView];
        
        UIView *toggleContainer = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-100, frame.size.width, 55)];
        toggleContainer.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        toggleContainer.layer.shadowRadius = 5;
        toggleContainer.layer.shadowOffset = CGSizeMake(1, 1);
        toggleContainer.layer.shadowOpacity = .6;
        toggleContainer.layer.masksToBounds = NO;
        toggleContainer.backgroundColor = [UIColor whiteColor];
        [self addSubview:toggleContainer];
        
        BEMCheckBox *myCheckBox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(frame.size.width - 40, 15, 25, 25)];
        myCheckBox.delegate = self;
        myCheckBox.boxType = BEMBoxTypeCircle;
        myCheckBox.onFillColor =  [UIColor colorWithRed:52/255.f green:77/255.f blue:146/255.f alpha:1];
        myCheckBox.onTintColor =  [UIColor colorWithRed:52/255.f green:77/255.f blue:146/255.f alpha:1];
        myCheckBox.onCheckColor =  [UIColor whiteColor];
        [toggleContainer addSubview:myCheckBox];
        
        favoriteLabel = [[UILabel alloc] initWithFrame:CGRectMake(toggleContainer.frame.size.width-229, toggleContainer.frame.size.height/2 - 7.5, 180, 15)];
        favoriteLabel.backgroundColor = [UIColor clearColor];
        favoriteLabel.textAlignment = NSTextAlignmentRight;
        favoriteLabel.textColor = [UIColor darkGrayColor];
        favoriteLabel.font = [UIFont fontWithName:@"IRANSans" size:14];
        favoriteLabel.text = @"اضافه به آدرس های منتخب";
        [toggleContainer addSubview:favoriteLabel];
        
        if ([DataCollector sharedInstance].isSourceFavorite) {
            [myCheckBox setOn:YES animated:YES];
            isAddressSave = YES;
            favoriteLabel.text = @"به آدرس های منتخب اضافه شد";
            myCheckBox.userInteractionEnabled = NO;
        }
        
        UIImageView *star = [[UIImageView alloc]initWithFrame:CGRectMake(10, toggleContainer.frame.size.height/2-12.5, 25, 25)];
        star.image = [UIImage imageNamed:@"star.png"];
        [toggleContainer addSubview:star];
        
        CNPPopupButton *button = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, frame.size.height-50, frame.size.width, 50)];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"IRANSans" size:16];
        [button setTitle:@"ادامه" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:52/255.f green:77/255.f blue:146/255.f alpha:1];
        
        button.selectionHandler = ^(CNPPopupButton *button){
            [self ForwardClicked];
            
        };
        
        [self addSubview:button];
    }
    return self;
}

-(void)didTapCheckBox:(BEMCheckBox *)checkBox
{
    if (checkBox.on) {
        isAddressSave = YES;
    }
    
    favoriteLabel.text = @"به آدرس های منتخب اضافه شد";
    
    checkBox.userInteractionEnabled = NO;
    
}

-(void)ForwardClicked
{
    if([self.delegate respondsToSelector:@selector(ForwardClicked)])
    {
        [DataCollector sharedInstance].sourceBell = bellTextField.text;
        [DataCollector sharedInstance].sourcePlate = plateTextField.text;
        
        if (isAddressSave && [DataCollector sharedInstance].isSourceFavorite == NO) {
            [DataCollector sharedInstance].isSourceFavorite = &(isAddressSave);
            [DBManager createSourceTable];
            [DBManager InsertToSourceTable:[DataCollector sharedInstance]];
            
        }
        
        [self.delegate ForwardClicked];
    }
}


@end
