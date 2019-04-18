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
#import "DBManager.h"

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
        
        plateTextField = [[UITextField alloc]initWithFrame:CGRectMake(3*(frame.size.width/4)-35, 50, 70, 30)];
        plateTextField.keyboardType = UIKeyboardTypeDefault;
        plateTextField.font = [UIFont fontWithName:@"IRANSans" size:14];
        plateTextField.borderStyle = UITextBorderStyleNone;
        plateTextField.returnKeyType = UIReturnKeyDone;
        plateTextField.textAlignment = NSTextAlignmentCenter;
        plateTextField.placeholder = @"پلاک";
        plateTextField.text =[DataCollector sharedInstance].destinationPlate;
        [self addSubview:plateTextField];
        
        UIView *plateTextFieldView = [[UIImageView alloc] initWithFrame:CGRectMake(plateTextField.frame.origin.x, plateTextField.frame.origin.y+30, 70 , 1)];
        [plateTextFieldView setBackgroundColor:[UIColor colorWithRed:118/255.f green:106/255.f blue:247/255.f alpha:1]];
        plateTextFieldView.userInteractionEnabled = NO;
        plateTextFieldView.alpha = .3f;
        [self addSubview:plateTextFieldView];
        
        bellTextField = [[UITextField alloc]initWithFrame:CGRectMake(frame.size.width/4-35, 50, 70, 30)];
        bellTextField.keyboardType = UIKeyboardTypeDefault;
        bellTextField.font = [UIFont fontWithName:@"IRANSans" size:14];
        bellTextField.borderStyle = UITextBorderStyleNone;
        bellTextField.returnKeyType = UIReturnKeyDone;
        bellTextField.textAlignment = NSTextAlignmentCenter;
        bellTextField.placeholder = @"واحد / زنگ";
        bellTextField.text =[DataCollector sharedInstance].destinationBell;
        [self addSubview:bellTextField];
        
        UIView *bellTextFieldView = [[UIImageView alloc] initWithFrame:CGRectMake(bellTextField.frame.origin.x, bellTextField.frame.origin.y+30, 70 , 1)];
        [bellTextFieldView setBackgroundColor:[UIColor colorWithRed:52/255.f green:77/255.f blue:146/255.f alpha:1]];
        bellTextFieldView.userInteractionEnabled = NO;
        bellTextFieldView.alpha = .3f;
        [self addSubview:bellTextFieldView];
        
        nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(3*(frame.size.width/4)-50, 92, 100, 30)];
        nameTextField.keyboardType = UIKeyboardTypeDefault;
        nameTextField.font = [UIFont fontWithName:@"IRANSans" size:14];
        nameTextField.borderStyle = UITextBorderStyleNone;
        nameTextField.returnKeyType = UIReturnKeyDone;
        nameTextField.textAlignment = NSTextAlignmentCenter;
        nameTextField.placeholder = @"نام گیرنده";
        nameTextField.text =[DataCollector sharedInstance].destinationFullName;
        [self addSubview:nameTextField];
        
        UIView *nameTextFieldView = [[UIImageView alloc] initWithFrame:CGRectMake(nameTextField.frame.origin.x, nameTextField.frame.origin.y+30, 90 , 1)];
        [nameTextFieldView setBackgroundColor:[UIColor colorWithRed:52/255.f green:77/255.f blue:146/255.f alpha:1]];
        nameTextFieldView.userInteractionEnabled = NO;
        nameTextFieldView.alpha = .3f;
        [self addSubview:nameTextFieldView];
        
        phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(frame.size.width/4-50, 92, 100, 30)];
        phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        phoneTextField.font = [UIFont fontWithName:@"IRANSans" size:11];
        phoneTextField.borderStyle = UITextBorderStyleNone;
        phoneTextField.returnKeyType = UIReturnKeyDone;
        phoneTextField.textAlignment = NSTextAlignmentCenter;
        phoneTextField.placeholder = @"شماره تماس";
        phoneTextField.text =[DataCollector sharedInstance].destinationPhoneNumber;
        [self addSubview:phoneTextField];
        
        UIView *phoneTextFieldView = [[UIImageView alloc] initWithFrame:CGRectMake(phoneTextField.frame.origin.x, phoneTextField.frame.origin.y+30, 90 , 1)];
        [phoneTextFieldView setBackgroundColor:[UIColor colorWithRed:52/255.f green:77/255.f blue:146/255.f alpha:1]];
        phoneTextFieldView.userInteractionEnabled = NO;
        phoneTextFieldView.alpha = .3f;
        [self addSubview:phoneTextFieldView];
        
        
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
        myCheckBox.onFillColor = [UIColor colorWithRed:118/255.f green:106/255.f blue:247/255.f alpha:1];
        myCheckBox.onTintColor =  [UIColor colorWithRed:118/255.f green:106/255.f blue:247/255.f alpha:1];
        myCheckBox.onCheckColor =  [UIColor whiteColor];
        [toggleContainer addSubview:myCheckBox];
        
        favoriteLabel = [[UILabel alloc] initWithFrame:CGRectMake(toggleContainer.frame.size.width-229, toggleContainer.frame.size.height/2 - 7.5, 180, 15)];
        favoriteLabel.backgroundColor = [UIColor clearColor];
        favoriteLabel.textAlignment = NSTextAlignmentRight;
        favoriteLabel.textColor = [UIColor darkGrayColor];
        favoriteLabel.font = [UIFont fontWithName:@"IRANSans" size:14];
        favoriteLabel.text = @"اضافه به آدرس های منتخب";
        [toggleContainer addSubview:favoriteLabel];
        
        if ([DataCollector sharedInstance].isDestinationFavorite) {
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
        button.backgroundColor = [UIColor colorWithRed:118/255.f green:106/255.f blue:247/255.f alpha:1];
        
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
    if (phoneTextField.text.length > 0) {
        if([self.delegate respondsToSelector:@selector(ForwardClicked)])
        {
            [DataCollector sharedInstance].destinationBell = bellTextField.text;
            [DataCollector sharedInstance].destinationPlate = plateTextField.text;
            [DataCollector sharedInstance].destinationPhoneNumber =phoneTextField.text;
            [DataCollector sharedInstance].destinationFullName =nameTextField.text;
            
            if (isAddressSave && [DataCollector sharedInstance].isDestinationFavorite == NO) {
                [DataCollector sharedInstance].isDestinationFavorite = &(isAddressSave);
                [DBManager createDestinationTable];
                [DBManager InsertToDestinationTable:[DataCollector sharedInstance]];
            }
            
            [self.delegate ForwardClicked];            
        }
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🙌🏽"
                                                        message:@"لطفا شماره ی گیرنده را حتما وارد کنید"
                                                       delegate:self
                                              cancelButtonTitle:@"تایید"
                                              otherButtonTitles:nil];
        [alert show];
        
        NSLog( @"Unable to fetch Data. Try again.");
        
    }
}

@end
