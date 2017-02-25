//
//  SummaryView.m
//  Motori
//
//  Created by adb on 2/17/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import "SummaryView.h"
#import "DataCollector.h"
#import "UIView+YGPulseView.h"
#import <OCGoogleDirectionsAPI/OCGoogleDirectionsAPI.h>
#import "RadarView.h"
#define DEGREES_TO_RADIANS(angle) (angle/180.0*M_PI)

@implementation SummaryView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        mainView = [[UIView alloc]initWithFrame:frame];
        mainView.backgroundColor = [UIColor clearColor];
        [self addSubview:mainView];
        
        UILabel *sourceAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, frame.size.width-45, 15)];
        sourceAddressLabel.backgroundColor = [UIColor clearColor];
        sourceAddressLabel.textAlignment = NSTextAlignmentRight;
        sourceAddressLabel.textColor = [UIColor darkGrayColor];
        sourceAddressLabel.font = [UIFont fontWithName:@"IRANSans" size:12];
        sourceAddressLabel.text =[DataCollector sharedInstance].sourceAddress;
        [mainView addSubview:sourceAddressLabel];
        
        UILabel *destinationAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 37, frame.size.width-45, 15)];
        destinationAddressLabel.backgroundColor = [UIColor clearColor];
        destinationAddressLabel.textAlignment = NSTextAlignmentRight;
        destinationAddressLabel.textColor = [UIColor darkGrayColor];
        destinationAddressLabel.font = [UIFont fontWithName:@"IRANSans" size:12];
        destinationAddressLabel.text =[DataCollector sharedInstance].destinationAddress;
        [mainView addSubview:destinationAddressLabel];
        
        UIView *sepratorView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 72, frame.size.width-100 , 1)];
        [sepratorView setBackgroundColor:[UIColor colorWithRed:118/255.f green:106/255.f blue:247/255.f alpha:1]];
        sepratorView.userInteractionEnabled = NO;
        sepratorView.alpha = .3f;
        [mainView addSubview:sepratorView];
        
        UIView *sepratorViewBottom = [[UIImageView alloc] initWithFrame:CGRectMake(50, 200, frame.size.width-100 , 1)];
        [sepratorViewBottom setBackgroundColor:[UIColor colorWithRed:118/255.f green:106/255.f blue:247/255.f alpha:1]];
        sepratorViewBottom.userInteractionEnabled = NO;
        sepratorViewBottom.alpha = .3f;
        [mainView addSubview:sepratorViewBottom];
        
        UIView *dotView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width - 22 , 10, 12,12)];
        dotView.layer.cornerRadius = dotView.frame.size.width/2;
        dotView.backgroundColor = [UIColor colorWithRed:118/255.f green:106/255.f blue:247/255.f alpha:1];
        dotView.clipsToBounds = YES;
        [mainView addSubview:dotView];
        
        UIView *dotDestView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width - 22, 38, 12,12)];
        dotDestView.layer.cornerRadius = dotDestView.frame.size.width/2;
        dotDestView.backgroundColor = [UIColor colorWithRed:52/255.f green:77/255.f blue:146/255.f alpha:1];
        dotDestView.clipsToBounds = YES;
        [mainView addSubview:dotDestView];
        
        priceCircleView = [[UIView alloc]initWithFrame:CGRectMake(-90, 90, 90,90)];
        priceCircleView.layer.cornerRadius = priceCircleView.frame.size.width/2;
        priceCircleView.backgroundColor = [UIColor colorWithRed:52/255.f green:77/255.f blue:146/255.f alpha:1];
        priceCircleView.clipsToBounds = YES;
        priceCircleView.alpha = .96;
        [self addSubview:priceCircleView];
        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, priceCircleView.frame.size.height/2-7.5f, priceCircleView.frame.size.width-10, 15)];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.textColor = [UIColor whiteColor];
        priceLabel.font = [UIFont fontWithName:@"IRANSans" size:13];
        priceLabel.text =@"۸۰۰۰ تومان";
        [priceCircleView addSubview:priceLabel];
        
        priceActivityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallScaleRipple tintColor:[UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1] size:30.0f];
        priceActivityIndicatorView.frame = CGRectMake(priceCircleView.frame.size.width/2-15,priceCircleView.frame.size.height/2 -15, 30.0f, 30.0f);
        [priceCircleView addSubview:priceActivityIndicatorView];
        
        timeCircleView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width+95 , 95, 80,80)];
        timeCircleView.layer.cornerRadius = timeCircleView.frame.size.width/2;
        timeCircleView.backgroundColor = [UIColor colorWithRed:118/255.f green:106/255.f blue:247/255.f alpha:1];
        timeCircleView.clipsToBounds = YES;
        timeCircleView.alpha = .96;
        [self addSubview:timeCircleView];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, timeCircleView.frame.size.height/2-7.5f, timeCircleView.frame.size.width-10, 15)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.font = [UIFont fontWithName:@"IRANSans" size:13];
        timeLabel.text =@"";
        [timeCircleView addSubview:timeLabel];
        
        timeActivityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallScaleRipple tintColor:[UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1] size:30.0f];
        timeActivityIndicatorView.frame = CGRectMake(25,25, 30.0f, 30.0f);
        [timeCircleView addSubview:timeActivityIndicatorView];
        
        UILabel *returnLabel = [[UILabel alloc] initWithFrame:CGRectMake(3*(frame.size.width/4)-45, 215, 90, 20)];
        returnLabel.backgroundColor = [UIColor clearColor];
        returnLabel.textAlignment = NSTextAlignmentCenter;
        returnLabel.textColor = [UIColor darkGrayColor];
        returnLabel.font = [UIFont fontWithName:@"IRANSans" size:10];
        returnLabel.text =@"رفت و برگشت";
        [mainView addSubview:returnLabel];
        
        segmentedControl = [[LUNSegmentedControl alloc]initWithFrame:CGRectMake(30, 110, 100, 50)];
        segmentedControl.delegate = self;
        segmentedControl.dataSource = self;
        segmentedControl.transitionStyle = LUNSegmentedControlTransitionStyleFade;
        segmentedControl.selectorViewColor =[UIColor colorWithRed:118/255.f green:106/255.f blue:247/255.f alpha:1];
    
        segmentedControl.cornerRadius = 5;
        segmentedControl.shapeStyle = LUNSegmentedControlShapeStyleRoundedRect;
    
        [mainView addSubview:segmentedControl];
    
        segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
        /* Leading space to superview */
        NSLayoutConstraint *leftButtonXConstraint = [NSLayoutConstraint
                                                     constraintWithItem:segmentedControl attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual toItem:mainView attribute:
                                                     NSLayoutAttributeLeft multiplier:1.0 constant:3*(frame.size.width/4)-45];
        /* Top space to superview Y*/
        NSLayoutConstraint *leftButtonYConstraint = [NSLayoutConstraint
                                                     constraintWithItem:segmentedControl attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual toItem:mainView attribute:
                                                     NSLayoutAttributeTop multiplier:1.0f constant:245];
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:segmentedControl
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.0
                                                                            constant:90];
        /* Fixed Height */
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:segmentedControl
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0
                                                                             constant:30];
        
        [mainView addConstraints:@[ leftButtonXConstraint, leftButtonYConstraint,widthConstraint, heightConstraint]];
        
        
        UILabel *paymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/3-40, 215, 80, 20)];
        paymentLabel.backgroundColor = [UIColor clearColor];
        paymentLabel.textAlignment = NSTextAlignmentCenter;
        paymentLabel.textColor = [UIColor darkGrayColor];
        paymentLabel.font = [UIFont fontWithName:@"IRANSans" size:10];
        paymentLabel.text =@"پرداخت با گیرنده";
        [mainView addSubview:paymentLabel];
        
        paymentSegmentedControl = [[LUNSegmentedControl alloc]initWithFrame:CGRectMake(30, 110, 100, 50)];
        paymentSegmentedControl.delegate = self;
        paymentSegmentedControl.dataSource = self;
        paymentSegmentedControl.transitionStyle = LUNSegmentedControlTransitionStyleFade;
        
        paymentSegmentedControl.selectorViewColor =[UIColor colorWithRed:118/255.f green:106/255.f blue:247/255.f alpha:1];
        paymentSegmentedControl.currentState = 1;
        paymentSegmentedControl.cornerRadius = 5;
        paymentSegmentedControl.shapeStyle = LUNSegmentedControlShapeStyleRoundedRect;
        
        //        [segmentedControl reloadData];
        
        [mainView addSubview:paymentSegmentedControl];
        
        paymentSegmentedControl.translatesAutoresizingMaskIntoConstraints = NO;

        NSLayoutConstraint *leftpaymentXConstraint = [NSLayoutConstraint
                                                     constraintWithItem:paymentSegmentedControl attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual toItem:mainView attribute:
                                                     NSLayoutAttributeLeft multiplier:1.0 constant:frame.size.width/3 - 45];
        /* Top space to superview Y*/
        NSLayoutConstraint *leftpaymentYConstraint = [NSLayoutConstraint
                                                     constraintWithItem:paymentSegmentedControl attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual toItem:mainView attribute:
                                                     NSLayoutAttributeTop multiplier:1.0f constant:245];
        
        NSLayoutConstraint *widthConstraintpayment = [NSLayoutConstraint constraintWithItem:paymentSegmentedControl
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.0
                                                                            constant:90];
        /* Fixed Height */
        NSLayoutConstraint *heightConstraintpayment = [NSLayoutConstraint constraintWithItem:paymentSegmentedControl
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.0
                                                                             constant:30];
        
        [mainView addConstraints:@[ leftpaymentXConstraint, leftpaymentYConstraint,widthConstraintpayment, heightConstraintpayment]];
        
        
        mainButton = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, frame.size.height-50, frame.size.width, 50)];
        [mainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        mainButton.titleLabel.font = [UIFont fontWithName:@"IRANSans" size:16];
        [mainButton setTitle:@"درخواست کاسکت" forState:UIControlStateNormal];
        
        gradient = [CAGradientLayer layer];
        gradient.frame = mainButton.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)([UIColor colorWithRed:118/255.f green:106/255.f blue:247/255.f alpha:1].CGColor),(id)( [UIColor colorWithRed:52/255.f green:77/255.f blue:146/255.f alpha:1].CGColor),nil];
        gradient.startPoint = CGPointMake(0.5,0.0);
        gradient.endPoint = CGPointMake(0.5,1.0);
        [mainButton.layer insertSublayer:gradient atIndex:0];
        
 
        
        
        [self AnimateCircle];

        [self GetPrice];
        [self GetTime:NO];
        
        mainButton.selectionHandler = ^(CNPPopupButton *button){
            [self ForwardClicked];
            
            [UIView animateWithDuration:.5 animations:^(){
                
                [mainButton setTitle:@"لغو درخواست" forState:UIControlStateNormal];
                mainButton.backgroundColor = [UIColor colorWithRed:118/255.f green:106/255.f blue:247/255.f alpha:1];
                
                mainView.alpha = 0.0;
                mainView.userInteractionEnabled = NO;
                
                [timeCircleView stopPulse];
                [priceCircleView stopPulse];
                timeLabel.text = @"";
                
                priceCircleView.frame = CGRectMake(0, 0, frame.size.width,frame.size.height-50);
                priceCircleView.backgroundColor = [UIColor blackColor];
                priceCircleView.alpha = .7;
                priceCircleView.layer.cornerRadius = 0;
                timeCircleView.alpha = 0;
                priceLabel.frame = CGRectMake(5, priceCircleView.frame.size.height/2-10.f, priceCircleView.frame.size.width-10, 20);
                priceLabel.text = @"در حال جستجوی نزدیکترین کاسکت";
                priceLabel.font = [UIFont fontWithName:@"IRANSans-Bold" size:15];
                
                RadarView *radar = [[RadarView alloc]initWithFrame:CGRectMake(frame.size.width/2 - 140, 10, 280, 280)];
                [self addSubview:radar];
            
                self.backgroundColor = [UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1];
                
                [self bringSubviewToFront:priceCircleView];
          
            }];
            
            
            
            gradient.colors =  [NSArray arrayWithObjects:(id)([UIColor colorWithRed:118/255.f green:106/255.f blue:247/255.f alpha:1].CGColor),(id)( [UIColor colorWithRed:52/255.f green:77/255.f blue:146/255.f alpha:1].CGColor),(id)([UIColor colorWithRed:118/255.f green:106/255.f blue:247/255.f alpha:1].CGColor),nil];
           // gradient.colors = [NSArray arrayWithObjects:(id)([UIColor colorWithRed:70/255.f green:70/255.f blue:70/255.f alpha:1].CGColor),(id)( [UIColor colorWithRed:255/255.f green:0/255.f blue:66/255.f alpha:.1].CGColor),nil];
            
            //set locations for the colors
            NSArray * startingLocations = @[@0.0,@.2,@0.4,@.6,@.8,@1.0,@.8,@.6,@.4,@.3,@.0];
            NSArray *endinglocations = @[@0.0,@.4,@0.8,@1.0,@0.8,@.4,@0.0];
            
            // Update the model layer to the final point
            gradient.locations = endinglocations;
            gradient.startPoint = CGPointMake(0.0, 0.5);
            gradient.endPoint = CGPointMake(2, 0.5);
            
            //Create animation for the "locations" aspect of the gradient layer
            CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"locations"];
            //Set the starting locations to the previously applied array
            fadeAnim.fromValue = startingLocations;
            fadeAnim.repeatCount = INFINITY;
            fadeAnim.autoreverses = YES;
            // 3 seconds of run time
            [fadeAnim setDuration:1.7f];
            
            //linear and straight timing since we want it smooth
            [fadeAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            
            //do the magic and apply the animation
            [gradient addAnimation:fadeAnim forKey:@"locations"];
        };
        
        [self addSubview:mainButton];
    }
    return self;
}

-(void)AnimateCircle
{

    [UIView animateWithDuration:0.8f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         priceCircleView.frame = CGRectMake(self.frame.size.width/2 - 86, 90, 90,90);
                         timeCircleView.frame = CGRectMake(self.frame.size.width/2-4 , 95, 80,80);
                         
                     }
                     completion:^(BOOL finished) {
                         if (finished) [self AddPulseView];
                     }];
}

- (NSArray<UIColor *> *)segmentedControl:(LUNSegmentedControl *)segmentedControl gradientColorsForStateAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return @[[UIColor colorWithRed:118/255.f green:106/255.f blue:247/255.f alpha:1],[UIColor colorWithRed:52/255.f green:77/255.f blue:146/255.f alpha:1]];
            
            break;
            
        case 1:
             return @[[UIColor colorWithRed:52/255.f green:77/255.f blue:146/255.f alpha:1],[UIColor colorWithRed:52/255.f green:77/255.f blue:146/255.f alpha:1]];
            break;

            
        default:
            break;
    }
    return nil;
}

- (NSAttributedString *)segmentedControl:(LUNSegmentedControl *)segmentedControl attributedTitleForStateAtIndex:(NSInteger)index {
    
    if (segmentedControl == paymentSegmentedControl) {
        switch (index) {
            case 0:
                return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@"خیر"] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"IRANSans" size:12]}];
                break;
                
            case 1:
                return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@"بله"] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"IRANSans" size:12]}];
                
                
                break;
                
            default:
                break;
        }
    }
    else
    {
        switch (index) {
            case 0:
                return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@"ندارد"] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"IRANSans" size:12]}];
                break;
                
            case 1:
                return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@"دارد"] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"IRANSans" size:12]}];
                
                
                break;
                
            default:
                break;
        }
    }
    
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"TAB %li",(long)index] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:16]}];
}

- (NSAttributedString *)segmentedControl:(LUNSegmentedControl *)segmentedControl attributedTitleForSelectedStateAtIndex:(NSInteger)index {
    
    if (segmentedControl == paymentSegmentedControl) {
        switch (index) {
            case 0:
                return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@"خیر"] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"IRANSans" size:12]}];
                break;
                
            case 1:
                return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@"بله"] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"IRANSans" size:12]}];
                break;
                
            default:
                break;
        }
    }
    else
    {
        switch (index) {
            case 0:
                return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@"ندارد"] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"IRANSans" size:12]}];
                break;
                
            case 1:
                return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@"دارد"] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"IRANSans" size:12]}];
                break;
                
            default:
                break;
        }
    }
    
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"TAB %li",(long)index] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:16]}];
}

- (NSInteger)numberOfStatesInSegmentedControl:(LUNSegmentedControl *)segmentedControl {
    return 2;
}

- (void)segmentedControl:(LUNSegmentedControl *)segmentedControl didChangeStateFromStateAtIndex:(NSInteger)fromIndex toStateAtIndex:(NSInteger)toIndex
{
    if (segmentedControl == paymentSegmentedControl)
    {
        [DataCollector sharedInstance].payInDestination = [NSString stringWithFormat:@"%d",toIndex];
    }
    else
    {
        [DataCollector sharedInstance].haveReturn = [NSString stringWithFormat:@"%d",toIndex];
        if (toIndex == 0) {
            [self GetTime:NO];
        }
        else
            [self GetTime:YES];
        
        [self GetPrice];
        
    }
}

-(void)AddPulseView
{
    [priceCircleView startPulseWithColor:priceCircleView.backgroundColor animation:YGPulseViewAnimationTypeRadarPulsing];
    
     [timeCircleView startPulseWithColor:timeCircleView.backgroundColor animation:YGPulseViewAnimationTypeRadarPulsing];
    
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

-(void)GetTime:(BOOL)haveReturn
{
    CLLocation *sourceLoc = [[CLLocation alloc]initWithLatitude:[[DataCollector sharedInstance].sourceLat doubleValue] longitude:[[DataCollector sharedInstance].sourceLon doubleValue]];
    CLLocation *destinationLoc = [[CLLocation alloc]initWithLatitude:[[DataCollector sharedInstance].destinationLat doubleValue] longitude:[[DataCollector sharedInstance].destinationLon doubleValue] ];
    
    __block int oneTime;
    __block int roundTime;
    
    
    OCDirectionsRequest *request = [OCDirectionsRequest requestWithOriginLocation:sourceLoc andDestinationLocation:destinationLoc];
    [request setRegion:@"ir"];
    [request setLanguage:@"fa"];
    [request setTravelMode:OCDirectionsRequestTravelModeDriving];
    [request setTrafficModel:OCDirectionsRequestTrafficModelDefault];
    [request setUnit:OCDirectionsRequestUnitMetric];

    [timeActivityIndicatorView startAnimating];
    
    OCDirectionsAPIClient *client = [OCDirectionsAPIClient new];
    [client directions:request response:^(OCDirectionsResponse *response, NSError *error) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // e.g.
            if (error) {
                return;
            }
            if (response.status != OCDirectionsResponseStatusOK) {
                return;
            }
            
            for (OCDirectionsRoute *route in response.routes) {
                
                for (OCDirectionsLeg *leg in route.legs) {
                    
                    OCDirectionsDuration *duration = leg.duration;
                    
                    
                    [timeActivityIndicatorView stopAnimating];
                    
                    oneTime = [duration.value intValue]/60;
                    NSString *timeString =[self MapCharacter:[NSString stringWithFormat:@"%d",oneTime]];
                    timeLabel.text = [NSString stringWithFormat:@"%@ دقیقه",timeString];
                    
                    break;
                }
            }
        }];
    }];

    if (haveReturn) {
        OCDirectionsRequest *request = [OCDirectionsRequest requestWithOriginLocation:destinationLoc andDestinationLocation:sourceLoc];
        [request setRegion:@"ir"];
        [request setLanguage:@"fa"];
        [request setTravelMode:OCDirectionsRequestTravelModeDriving];
        [request setTrafficModel:OCDirectionsRequestTrafficModelDefault];
        [request setUnit:OCDirectionsRequestUnitMetric];
        
        [timeActivityIndicatorView startAnimating];
        
        OCDirectionsAPIClient *client = [OCDirectionsAPIClient new];
        [client directions:request response:^(OCDirectionsResponse *response, NSError *error) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                // e.g.
                if (error) {
                    return;
                }
                if (response.status != OCDirectionsResponseStatusOK) {
                    return;
                }
                
                for (OCDirectionsRoute *route in response.routes) {
                    
                    for (OCDirectionsLeg *leg in route.legs) {
                        
                        OCDirectionsDuration *duration = leg.duration;
                        
                        [timeActivityIndicatorView stopAnimating];
                        time = [duration.value intValue]/60 + oneTime;
                        NSString *timeString =[self MapCharacter:[NSString stringWithFormat:@"%d",time]];
                        timeLabel.text = [NSString stringWithFormat:@"%@ دقیقه",timeString];
                        break;
                    }
                }
            }];
        }];
        
    }

}

-(void)GetPrice
{
    [priceActivityIndicatorView startAnimating];
    RequestCompleteBlock callback = ^(BOOL wasSuccessful,NSMutableDictionary *data) {
        
        paymentSegmentedControl.userInteractionEnabled = YES;
        [priceActivityIndicatorView stopAnimating];
        if (wasSuccessful) {
            
            price = [ data valueForKey:@"price"];
            
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[price integerValue]]];
            
            priceLabel.text = [NSString stringWithFormat:@"%@ تومان" ,[self MapCharacter:formatted]];
            
        }
        
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"👻"
                                                            message:@"لطفا ارتباط خود با اینترنت را بررسی نمایید."
                                                           delegate:self
                                                  cancelButtonTitle:@"خب"
                                                  otherButtonTitles:nil];
//            [alert show];
            
            
            NSLog( @"Unable to fetch Data. Try again.");
        }
    };
    
    Settings *st = [[Settings alloc]init];
    
    st = [DBManager selectSetting][0];
    
    NSString *haveReturn = segmentedControl.currentState == 0 ? @"false":@"true";
    
    paymentSegmentedControl.userInteractionEnabled = NO;
    
    [self.getData GetPrice:st.accesstoken SourceLat:[DataCollector sharedInstance].sourceLat SourceLon:[DataCollector sharedInstance].sourceLon DestinationLat:[DataCollector sharedInstance].destinationLat DestinationLon:[DataCollector sharedInstance].destinationLon HaveReturn:haveReturn OrderType:[DataCollector sharedInstance].orderType withCallback:callback];

}

- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
}

-(NSString*)MapCharacter:(NSString*)character
{
    if ([character containsString:@"1"])
        character = [character stringByReplacingOccurrencesOfString:@"1" withString:@"۱"];
    if ([character containsString:@"2"])
        character =[character stringByReplacingOccurrencesOfString:@"2" withString:@"۲"];
    if ([character containsString:@"3"])
        character =[character stringByReplacingOccurrencesOfString:@"3" withString:@"۳"];
    if ([character containsString:@"4"])
        character =[character stringByReplacingOccurrencesOfString:@"4" withString:@"۴"];
    if ([character containsString:@"5"])
        character =[character stringByReplacingOccurrencesOfString:@"5" withString:@"۵"];
    if ([character containsString:@"6"])
        character =[character stringByReplacingOccurrencesOfString:@"6" withString:@"۶"];
    if ([character containsString:@"7"])
        character =[character stringByReplacingOccurrencesOfString:@"7" withString:@"۷"];
    if ([character containsString:@"8"])
        character =[character stringByReplacingOccurrencesOfString:@"8" withString:@"۸"];
    if ([character containsString:@"9"])
        character =[character stringByReplacingOccurrencesOfString:@"9" withString:@"۹"];
    if ([character containsString:@"0"])
        character =[character stringByReplacingOccurrencesOfString:@"0" withString:@"۰"];
    
    return character;
}

@end
