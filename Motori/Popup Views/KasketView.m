//
//  KasketView.m
//  Motori
//
//  Created by aDb on 2/25/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import "KasketView.h"
#import "MapCharacter.h"
#import "CNPPopupController.h"
#import "UIImage+OHPDF.h"

@implementation KasketView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self OrderDetail];

        topView = [[UIView alloc]init];
        topView.frame = CGRectMake(15, -95, frame.size.width- 30, 90);
        topView.backgroundColor = [UIColor colorWithRed:52/255.f green:77/255.f blue:146/255.f alpha:1];
        topView.layer.cornerRadius = 5;
        topView.layer.shadowColor = [UIColor blackColor].CGColor;
        topView.layer.shadowOffset = CGSizeMake(1, 1.f);
        topView.layer.shadowRadius = 6;
        topView.layer.shadowOpacity = 0.7;
        [self addSubview:topView];
        
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, topView.frame.size.height/2 - 10, topView.frame.size.width-84, 20)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = NSTextAlignmentRight;
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont fontWithName:@"IRANSans-Bold" size:14];
        nameLabel.text = self.fullName;
        [topView addSubview:nameLabel];
        
        UIImageView *kasketPic = [[UIImageView alloc]init];
        kasketPic.image = [UIImage imageWithPDFNamed:@"avatar.pdf"
                                           fitInSize:CGSizeMake(70, 70)];
        kasketPic.frame =CGRectMake(10, topView.frame.size.height/2 - 33 , 70,70 );
        kasketPic.clipsToBounds = YES;
        kasketPic.layer.borderColor = [UIColor whiteColor].CGColor;
        kasketPic.layer.borderWidth = 1;
        kasketPic.backgroundColor = [UIColor whiteColor];
        kasketPic.layer.cornerRadius = kasketPic.frame.size.height/2;
        [topView addSubview:kasketPic];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, topView.frame.size.height + 10, frame.size.width, 15)];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.textColor = [UIColor darkGrayColor];
        priceLabel.font = [UIFont fontWithName:@"IRANSans-Medium" size:13];
        
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[self.price integerValue]]];
        
        priceLabel.text =[NSString stringWithFormat:@"هزینه قابل پرداخت %@ تومان",[MapCharacter MapCharacter:formatted]];

        [topView addSubview:priceLabel];
        
        CNPPopupButton *button = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, frame.size.height-40, frame.size.width/2-1, 40)];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"IRANSans" size:16];
        [button setTitle:@"لغو درخواست" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:118/255.f green:106/255.f blue:247/255.f alpha:1];
        
        button.selectionHandler = ^(CNPPopupButton *button){
            [self CancelClicked];
            
        };
        
        [self addSubview:button];
        
        CNPPopupButton *callButton = [[CNPPopupButton alloc] initWithFrame:CGRectMake(frame.size.width/2+1, frame.size.height-40, frame.size.width/2-1, 40.0)];
        [callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        callButton.titleLabel.font = [UIFont fontWithName:@"IRANSans" size:16];
        [callButton setTitle:@"تماس" forState:UIControlStateNormal];
        callButton.backgroundColor = [UIColor colorWithRed:118/255.f green:106/255.f blue:247/255.f alpha:1];
        
        callButton.selectionHandler = ^(CNPPopupButton *button){
            [self CallKasket];
            
        };
        
        [self addSubview:callButton];
    
        [self AnimateTopView];
    }
    return self;
}

-(void)AnimateTopView
{

    [UIView animateWithDuration:.6f animations:^(){
    
        topView.frame = CGRectMake(15, -5, topView.frame.size.width, 90);
    
    }];

}

-(void)CallKasket
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.phoneNumber]]];
}

-(void)CancelClicked
{
    if([self.delegate respondsToSelector:@selector(CancelClicked)])
    {
        [self.delegate CancelClicked];
    }

}

-(void)OrderDetail
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Order.plist"];
    
    NSMutableDictionary *array = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    self.phoneNumber = [array valueForKey:@"phonenumber"];
    self.fullName = [array valueForKey:@"name"];
    self.price = [array valueForKey:@"totalPrice"];;
}

@end
