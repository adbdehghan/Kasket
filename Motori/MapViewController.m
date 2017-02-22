//
//  MapViewController.m
//  Motori
//
//  Created by aDb on 1/15/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import "MapViewController.h"
#import "DataDownloader.h"
#import "Settings.h"
#import "DBManager.h"
#import "DGActivityIndicatorView.h"
#import "FCAlertView.h"
#import "INSSearchBar.h"
#import "ASJDropDownMenu.h"
#import "PulsingHaloLayer.h"
#import "MultiplePulsingHaloLayer.h"
#import "AnimatedGIFImageSerialization.h"
#import "UIImage+Blur.h"
#import "UIViewController+LMSideBarController.h"
#import "UIImage+OHPDF.h"
#import "CNPPopupController.h"
#import "RSCameraSwitch.h"
#import "sourceDetails.h"
#import "DataCollector.h"
#import "DestinationDetails.h"
#import "SummaryView.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

typedef NS_ENUM(NSInteger, OrderState) {
    SourceStep,
    SourceView,
    DestinationStep,
    SummaryStep,
    FindEmployee
};

typedef NS_ENUM(NSInteger, RequestType) {
    Human,
    Box
};

@import GoogleMaps;
@import GooglePlaces;

@interface MapViewController ()<GMSMapViewDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate,INSSearchBarDelegate,RSCameraSwitchDelegate,CNPPopupControllerDelegate,sourceDelegate,DestinationDelegate,SummaryDelegate>
{
    GMSMapView *mapView;
    NSString *str2;
    NSString *str3;
    NSString *_orderId;
    NSString *_address;
    UIView *layer;
    NSString *phoneNumber;
    UIView *menuContainer;
    UIView *darkLayer;
    UIButton *stepButton;
    DGActivityIndicatorView *activityIndicatorView;
    DGActivityIndicatorView *searchActivityIndicatorView;
    JTNumberScrollAnimatedView *userCredit;
    OrderState orderState;
    RequestType requestType;
    UIImageView *compassImage;
    CABasicAnimation* rotationAnimation;
    BOOL isIdle;
    GMSMarker *desmarker;
    GMSMarker *sourceMarker;
    UIButton *menuButton;
    UIButton *backButton;
    GMSPlacesClient *_placesClient;
}
@property (nonatomic) CLLocation *myLocation;
@property (nonatomic) CLLocation *deviceLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D pinLocation;
@property (nonatomic) CLLocationCoordinate2D pinLocationSource;
@property (nonatomic) CLLocationCoordinate2D pinLocationDestination;
@property (nonatomic) BOOL isAuthorised;
@property (nonatomic) BOOL isPressed;
@property (nonatomic) BOOL isCheked;
@property (nonatomic) BOOL isCanceled;
@property (nonatomic,strong) UIImageView *HumanPin;
@property (nonatomic,strong) UIImageView *destinationHumanPin;
@property (nonatomic,strong) UIButton *myLocationButton;
@property (nonatomic,strong) IBOutlet UILabel *addressLabel;
@property (nonatomic,strong) IBOutlet UIView *addressContainerView;
@property (nonatomic,strong) IBOutlet UIImageView *bluredView;
@property (nonatomic, strong) INSSearchBar *searchBarWithDelegate;
@property (strong, nonatomic) ASJDropDownMenu *dropDown;
@property (strong, nonatomic) DataDownloader *getData;
@property (nonatomic, weak) MultiplePulsingHaloLayer *mutiHalo;
@property (nonatomic, strong) CNPPopupController *popupController;
@property (nonatomic, strong) RSCameraSwitch *kindSwitch;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self setupMapView];
    [self CustomizeNavigationBar];
    
    [self InitActivityIndicators];
    
    [self AddDropDown];
    [self InitPin];
    [self InitLocationManager];
    [self AddKindSwitch];
    [self.view bringSubviewToFront:self.HumanPin];
    [self.view bringSubviewToFront:self.myLocationButton];
    [self.view bringSubviewToFront:self.addressContainerView];
    
    orderState = SourceStep;
    _placesClient = [GMSPlacesClient sharedClient];
}

-(void)AddKindSwitch{

    self.kindSwitch = [[RSCameraSwitch alloc] initWithFrame:CGRectMake(3, self.view.frame.size.height - 136, 65, 33)];
    self.kindSwitch.tintColor = [UIColor whiteColor];
    self.kindSwitch.offColor = [UIColor colorWithRed:24/255.f green:120/255.f blue:171/255.f alpha:1];
    self.kindSwitch.onColorLight = [UIColor colorWithRed:30/255.f green:170/255.f blue:241/255.f alpha:1];
    self.kindSwitch.onColorDark = [UIColor colorWithRed:30/255.f green:170/255.f blue:241/255.f alpha:1];
    self.kindSwitch.delegate = self;
    self.kindSwitch.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self.view addSubview:self.kindSwitch];
    
    requestType = Box;
}

- (void)clicked:(BOOL)isFront
{
    if (isFront) {
        requestType = Box;
        [DataCollector sharedInstance].orderType = @"0";
    } else {
        [DataCollector sharedInstance].orderType = @"1";
        requestType = Human;
    }
}


-(void)AddDropDown
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    _dropDown = [[ASJDropDownMenu alloc] initWithView:self.searchBarWithDelegate menuItems:temp];
    _dropDown.menuColor = [UIColor colorWithWhite:1.f alpha:1];
    _dropDown.itemColor = [UIColor colorWithWhite:.4f alpha:1];
    _dropDown.itemHeight = 50.0f;
    _dropDown.hidesOnSelection = YES;
    _dropDown.direction = ASJDropDownMenuDirectionDown;
    _dropDown.indicatorStyle = ASJDropDownMenuScrollIndicatorStyleWhite;
}

-(void)InitActivityIndicators
{
    activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeCookieTerminator tintColor:[UIColor orangeColor] size:30.0f];
    activityIndicatorView.frame = CGRectMake(self.view.center.x -15 , self.view.center.y - 15, 30.0f, 30.0f);
    activityIndicatorView.alpha = .5f;
    [self.view addSubview:activityIndicatorView];
    
    [self.view bringSubviewToFront:self.bluredView];
    [self.view bringSubviewToFront:activityIndicatorView];
    
    self.searchBarWithDelegate = [[INSSearchBar alloc] initWithFrame:CGRectMake(((CGRectGetWidth(self.view.bounds)-20))/2-((CGRectGetWidth(self.view.bounds)-20)*.8)/2, 0, (CGRectGetWidth(self.view.bounds)-20)*.8, 50.0)];
        self.searchBarWithDelegate.alpha = 0;
    self.searchBarWithDelegate.delegate = self;
    [self.view addSubview:self.searchBarWithDelegate];
    [self.searchBarWithDelegate showSearchBar:nil];
    
    searchActivityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeTriplePulse tintColor:[UIColor purpleColor] size:30.0f];
    searchActivityIndicatorView.frame = CGRectMake(12 , 15, 30.0f, 30.0f);
    searchActivityIndicatorView.alpha = .5f;
    [self.searchBarWithDelegate addSubview:searchActivityIndicatorView];

    menuContainer = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)-35, 0, 25, 15)];
    menuContainer.backgroundColor = [UIColor clearColor];
    menuContainer.layer.cornerRadius = 3;
    menuContainer.layer.masksToBounds = NO;
    menuContainer.layer.shadowOffset = CGSizeMake(1, 1);
    menuContainer.layer.shadowRadius = 15;
    menuContainer.layer.shadowOpacity = 0.4;
    menuContainer.userInteractionEnabled = YES;
    menuContainer.alpha = 0;
    
    [self.view addSubview:menuContainer];
    [self.view bringSubviewToFront:menuContainer];
    
    UIImageView *menuImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 25, 15)];
    menuImage.image = [UIImage imageNamed:@"menu"];
    menuImage.contentMode= UIViewContentModeScaleAspectFit;
    menuImage.clipsToBounds = YES;
    [menuContainer addSubview:menuImage];
    
    menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton addTarget:self
               action:@selector(presentMenuButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    
    menuButton.userInteractionEnabled = YES;
    menuButton.frame = CGRectMake(0, 0, 50, 50);
    [menuContainer addSubview:menuButton];
    
    [UIView animateWithDuration:.45f
                          delay:.3f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         menuContainer.alpha = 1;
                         self.searchBarWithDelegate.alpha = 1;
                         self.searchBarWithDelegate.frame =   CGRectMake(20, 58, CGRectGetWidth(self.view.bounds) - 40, 60.0);
                         menuContainer.frame = CGRectMake(CGRectGetWidth(self.view.bounds)-35, 28, 50, 50);
                         
                     } completion:^(BOOL finished){
                         
                     }];
    
    stepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [stepButton addTarget:self
               action:@selector(stepButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [stepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [stepButton setBackgroundColor:[UIColor colorWithRed:30/255.f green:170/255.f blue:241/255.f alpha:1]];
     [stepButton setTitle:@"تأیید مبدأ" forState:UIControlStateNormal];
    stepButton.titleLabel.font = [UIFont fontWithName:@"IRANSans" size:16];
    stepButton.userInteractionEnabled = YES;
    stepButton.frame = CGRectMake(20, CGRectGetHeight(self.view.bounds)-65, CGRectGetWidth(self.view.bounds) - 40, 50);
    stepButton.alpha = 0;
    [self.view addSubview:stepButton];
    
    self.myLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.myLocationButton addTarget:self
                              action:@selector(GoToMyLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.myLocationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.myLocationButton setImage:[UIImage imageNamed:@"position"] forState:UIControlStateNormal];
    self.myLocationButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.myLocationButton setBackgroundColor:[UIColor colorWithRed:30/255.f green:170/255.f blue:241/255.f alpha:1]];
    self.myLocationButton.userInteractionEnabled = YES;
    self.myLocationButton.frame = CGRectMake(CGRectGetWidth(self.view.bounds)- 40, CGRectGetHeight(self.view.bounds)-125, 30, 30);
    self.myLocationButton.layer.cornerRadius = self.myLocationButton.frame.size.height/2;
    self.myLocationButton.layer.masksToBounds = NO;
    self.myLocationButton.layer.shadowOffset = CGSizeMake(0, 1);
    self.myLocationButton.layer.shadowRadius = 5;
    self.myLocationButton.layer.shadowOpacity = 0.2;
    [self.view addSubview:self.myLocationButton];
}

-(void)InitBackButton
{
    UIImageView *menuImage = [[UIImageView alloc]initWithFrame:CGRectMake(25,35, 16, 14)];
    menuImage.image = [UIImage imageWithPDFNamed:@"back.pdf"
                                       fitInSize:CGSizeMake(16, 14)];

    menuImage.contentMode= UIViewContentModeScaleAspectFit;
    menuImage.clipsToBounds = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:menuImage];
    
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self
                   action:@selector(BackwardClicked) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    
    backButton.userInteractionEnabled = YES;
    backButton.frame = CGRectMake(15, 35, 30, 30);
    [[UIApplication sharedApplication].keyWindow addSubview:backButton];
}


-(void)presentMenuButtonTapped
{
    [self.sideBarController showMenuViewControllerInDirection:LMSideBarControllerDirectionRight];
}

-(void)stepButtonPressed
{
    if (orderState == SourceStep) {
        orderState = SourceView;
        
        sourceMarker = [[GMSMarker alloc] init];
        sourceMarker.appearAnimation = YES;
        sourceMarker.flat = YES;
        
        double latitude =  mapView.camera.target.latitude;
        double longitude = mapView.camera.target.longitude;
        
        self.pinLocationSource = CLLocationCoordinate2DMake(latitude,longitude);;
        [DataCollector sharedInstance].sourceLat = [NSString stringWithFormat:@"%f",latitude];
        [DataCollector sharedInstance].sourceLon = [NSString stringWithFormat:@"%f",longitude];
        
        sourceMarker.position = CLLocationCoordinate2DMake(latitude,longitude);
        sourceMarker.map = mapView;
        sourceMarker.icon = [UIImage imageWithPDFNamed:@"sourcemarker.pdf"
                                       fitInSize:CGSizeMake(50, 50)];
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude+0.001
                                                                longitude:longitude+0.001
                                                                     zoom:17.0];
        [mapView animateToCameraPosition:camera];
        
        [stepButton setTitle:@"تأیید مقصد" forState:UIControlStateNormal];
        
        self.HumanPin.image = [UIImage imageWithPDFNamed:@"destinationpin.pdf"
                                               fitInSize:self.HumanPin.bounds.size];
        
        compassImage.image = [UIImage imageNamed:@"destinationcompass"];
        
    
        
        [UIView animateWithDuration:.3 animations:^(){
            
            menuContainer.alpha = 0;
        }];
        
        self.kindSwitch.alpha = 0;
        
        if (requestType == Box) {
            [DataCollector sharedInstance].sourceAddress = self.searchBarWithDelegate.searchField.text;
            [self showPopupWithStyle:CNPPopupStyleActionSheet];
        }
        
        [self InitBackButton];
    }
    else
    {
        desmarker = [[GMSMarker alloc] init];
        desmarker.appearAnimation = YES;
        desmarker.flat = YES;
        
        double latitude =  mapView.camera.target.latitude;
        double longitude = mapView.camera.target.longitude;
        self.pinLocationDestination = CLLocationCoordinate2DMake(latitude,longitude);;
        [DataCollector sharedInstance].destinationLat = [NSString stringWithFormat:@"%f",latitude];
        [DataCollector sharedInstance].destinationLon = [NSString stringWithFormat:@"%f",longitude];
        desmarker.position = CLLocationCoordinate2DMake(latitude,longitude);
        desmarker.map = mapView;
        desmarker.icon =  [UIImage imageWithPDFNamed:@"destinationmarker.pdf"
                                        fitInSize:CGSizeMake(50, 50)];
        
        GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:self.pinLocationSource coordinate:self.pinLocationDestination];
        GMSCameraPosition *camera = [mapView cameraForBounds:bounds insets:UIEdgeInsetsMake(190, 60, 210, 60)];
   
        [mapView animateToCameraPosition:camera];
//        mapView.userInteractionEnabled = NO;
        
        self.HumanPin.alpha = 0;
        
        self.myLocationButton.hidden = YES;
        stepButton.hidden = YES;
        
        
        if (requestType == Box) {
            [DataCollector sharedInstance].destinationAddress = self.searchBarWithDelegate.searchField.text;
            [self showPopupWithStyle:CNPPopupStyleActionSheet];
        }
        
        [UIView animateWithDuration:.3 animations:^(){
        
            self.searchBarWithDelegate.alpha = 0;
        }];
    }
}

- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle {
    UIView *customView;
    
    if (orderState == SourceView) {
        customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
        sourceDetails *sourceView = [[sourceDetails alloc]initWithFrame:customView.frame];
        sourceView.delegate = self;
        [customView addSubview:sourceView];
    }
    else if (orderState == DestinationStep)
    {
        customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 190)];
        DestinationDetails *destinationView = [[DestinationDetails alloc]initWithFrame:customView.frame];
        destinationView.delegate = self;
        [customView addSubview:destinationView];
    
    }
    else if(orderState == SummaryStep)
    {
        customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 350)];
        SummaryView *summaryView = [[SummaryView alloc]initWithFrame:customView.frame];
        summaryView.delegate = self;
        [customView addSubview:summaryView];
    }
   
    self.popupController = [[CNPPopupController alloc] initWithContents:@[customView]];
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    [self.popupController presentPopupControllerAnimated:YES];
    
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:backButton];
}

-(void)ForwardClicked
{
    DataCollector *instance = [DataCollector sharedInstance];
    NSString *test = instance.sourceBell;
    
    if (orderState != SummaryStep) {
        
        [self.popupController dismissPopupControllerAnimated:YES];
    }
    
    if (orderState == SourceView) {
        orderState = DestinationStep;
    }
    else if (orderState == DestinationStep) {
        orderState = SummaryStep;
        [self showPopupWithStyle:CNPPopupStyleActionSheet];
    }
    else if (orderState == SummaryStep)
    {
        orderState = FindEmployee;
    
    }
    else if (orderState == FindEmployee)
    {
        orderState = SourceStep;
        [self.popupController dismissPopupControllerAnimated:YES];
        
    }
    
    
}

-(void)BackwardClicked
{

}

- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size
{
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}

-(void)InitLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest; // 100 m
    
    if (self.isAuthorised) {
        [self.locationManager startUpdatingLocation];
    }
}

-(void)InitPin
{
    self.HumanPin = [[UIImageView alloc]initWithFrame: CGRectMake(self.view.center.x-35, self.view.center.y-70, 70, 70)];
    self.HumanPin.image = [UIImage imageWithPDFNamed:@"sourcepin.pdf"
                                           fitInSize:self.HumanPin.bounds.size];
    self.HumanPin.contentMode = UIViewContentModeScaleAspectFit;

    [self.view addSubview:self.HumanPin];
    
    self.HumanPin.userInteractionEnabled = YES;
    
    compassImage = [[UIImageView alloc]initWithFrame:CGRectMake(27, 10, 15, 30)];
    compassImage.image = [UIImage imageWithPDFNamed:@"sourcecompass.pdf"
                                          fitInSize:compassImage.frame.size];
    compassImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.HumanPin addSubview:compassImage];

}

- (void)tapGesture: (id)sender
{
    
}

-(void)setupMapView {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:35.6961
                                                            longitude:51.4231
                                                                 zoom:18];
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height) camera:camera];
    
    mapView.myLocationEnabled = YES;
    
    //Shows the compass button on the map
    mapView.settings.compassButton = NO;
    
    //Shows the my location button on the map
    mapView.settings.myLocationButton = NO;
    mapView.delegate = self;
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *styleUrl = [mainBundle URLForResource:@"MapStyle" withExtension:@"json"];
    NSError *error;
    
    // Set the map style by passing the URL for style.json.
    GMSMapStyle *style = [GMSMapStyle styleWithContentsOfFileURL:styleUrl error:&error];
    
    if (!style) {
        NSLog(@"The style definition could not be loaded: %@", error);
    }
    
    mapView.mapStyle = style;
    
    [self.view addSubview:mapView];
}

- (IBAction)GoToMyLocation:(id)sender
{
    [self.locationManager startUpdatingLocation];
    self.isPressed = YES;
    
    if (self.isAuthorised)
    {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.myLocation.coordinate.latitude
                                                                longitude:self.myLocation.coordinate.longitude
                                                                     zoom:18.0];
        [mapView animateToCameraPosition:camera];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    
    self.myLocation = location;
    self.deviceLocation = location;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.myLocation.coordinate.latitude
                                                            longitude:self.myLocation.coordinate.longitude
                                                                 zoom:18.0];
    [mapView animateToCameraPosition:camera];
    
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.isAuthorised = YES;
        [self.locationManager startUpdatingLocation];
    }
    
    else if(status == kCLAuthorizationStatusNotDetermined)
    {
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
    }
    else if(status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"موقعیت"
                                                        message:@"اجازه دسترسی به موقعیت داده نشده"
                                                       delegate:self
                                              cancelButtonTitle:@"تنظیمات"
                                              otherButtonTitles:@"لغو",nil];
        [alert show];
        self.isAuthorised = NO;
    }
}

-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    [NSTimer scheduledTimerWithTimeInterval:.3f
                                     target:self
                                   selector:@selector(pin)
                                   userInfo:nil
                                    repeats:NO];
    [compassImage.layer removeAllAnimations];
    isIdle = YES;
    double latitude =  mapView.camera.target.latitude;
    double longitude = mapView.camera.target.longitude;
    
    self.pinLocation = CLLocationCoordinate2DMake(latitude,longitude);
    CLLocationCoordinate2D addressCoordinates = CLLocationCoordinate2DMake(latitude,longitude);
    GMSGeocoder* coder = [[GMSGeocoder alloc] init];
    
    [coder reverseGeocodeCoordinate:addressCoordinates completionHandler:^(GMSReverseGeocodeResponse *results, NSError *error) {
        if (error) {
            // NSLog(@"Error %@", error.description);
        } else {
            GMSAddress* address = [results firstResult];
            NSArray *arr = [address valueForKey:@"lines"];
            NSString *str1 = [NSString stringWithFormat:@"%lu",(unsigned long)[arr count]];
            if ([str1 isEqualToString:@"0"]) {
                //            self.txtPlaceSearch.text = @"";
            }
            else if ([str1 isEqualToString:@"1"]) {
                NSString *str2 = [arr objectAtIndex:0];
                //          self.txtPlaceSearch.text = str2;
            }
            else if ([str1 isEqualToString:@"2"]) {
                str2 = [arr objectAtIndex:0];
                str3 = [arr objectAtIndex:1];
                
                self.searchBarWithDelegate.searchField.text = [NSString stringWithFormat:@"%@",str2];
                _address = str2;
                [searchActivityIndicatorView stopAnimating];
                
            }
        }
    }];
}

-(void)pin
{
    [UIView animateWithDuration:0.8
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         stepButton.alpha = 1;
                         
                     } completion:NULL];
}

- (void)mapView:(GMSMapView *)pMapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    [searchActivityIndicatorView startAnimating];
    
    double latitude = mapView.camera.target.latitude;
    double longitude = mapView.camera.target.longitude;
    
    [self spinLayer:compassImage.layer duration:.5 direction:-1 degrees:40];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                      
                         stepButton.alpha = 0;
                         
                     } completion:NULL];
}

- (void)spinLayer:(CALayer *)inLayer duration:(CFTimeInterval)inDuration
        direction:(int)direction degrees:(CGFloat)degrees
{
    if (isIdle) {
        isIdle = NO;
        [compassImage.layer removeAllAnimations];
    
    // Rotate about the z axis
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [[inLayer presentationLayer] valueForKeyPath:@"transform.rotation.z"];
    // Rotate 360 degress, in direction specified
    rotationAnimation.toValue = [NSNumber numberWithFloat:direction * DEGREES_TO_RADIANS(degrees)];
    
    // Perform the rotation over this many seconds
    rotationAnimation.duration = inDuration;
    
    // Set the pacing of the animation
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.repeatCount = INFINITY;
//    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.cumulative = kCAAnimationPaced;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    // Add animation to the layer and make it so
    [inLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
}

- (void)searchBarDidTapReturn:(INSSearchBar *)searchBar
{
    [self.view bringSubviewToFront:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterGeocode;
    filter.country = @"IR";
    
    [_placesClient autocompleteQuery:searchBar.searchField.text
                              bounds:nil
                              filter:filter
                            callback:^(NSArray *results, NSError *error) {
                                if (error != nil) {
                                    NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                    return;
                                    
                                }
                                NSMutableArray *temp = [[NSMutableArray alloc] init];
                                for (GMSAutocompletePrediction* result in results) {
                                    NSLog(@"Result '%@' with placeID %@", result.attributedFullText.string, result.placeID);
                                    ASJDropDownMenuItem *menuItem = [ASJDropDownMenuItem itemWithTitle:result.attributedFullText.string subtitle:@"" image:[UIImage imageNamed:@"Pin.png"]];
                                    [temp addObject:menuItem];
                                }
                                if (temp.count>0) {
                                    
                                    
                                    _dropDown.menuItems = temp;
                                    [activityIndicatorView stopAnimating];
                                    
                                    [_dropDown showMenuWithCompletion:^(ASJDropDownMenu *dropDownMenu, ASJDropDownMenuItem *menuItem, NSUInteger index)
                                     {
                                         searchBar.searchField.text = menuItem.title;
                                         GMSAutocompletePrediction *place;
                                         for (GMSAutocompletePrediction *item in results) {
                                             
                                             if ([[item attributedFullText].string isEqualToString:menuItem.title]) {
                                                 place = item;
                                             }
                                         }
                                         
                                         [activityIndicatorView startAnimating];
                                         [_placesClient lookUpPlaceID:place.placeID callback:^(GMSPlace *place, NSError *error) {
                                             [activityIndicatorView stopAnimating];
                                             [self ResetView];
                                             if (error != nil) {
                                                 NSLog(@"Place Details error %@", [error localizedDescription]);
                                                 return;
                                             }
                                             
                                             if (place != nil) {
                                                 
                                                 GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:place.coordinate.latitude
                                                                                                         longitude:place.coordinate.longitude
                                                                                                              zoom:18.0];
                                                 [mapView animateToCameraPosition:camera];
                                                 
                                             } else {
                                                 
                                             }
                                         }];
                                         
                                     }];
                                }
                            }];
    
    
}

-(void)searchBarTextDidChange:(INSSearchBar *)searchBar
{
    [self.view bringSubviewToFront:activityIndicatorView];
    
    [activityIndicatorView startAnimating];
    
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterGeocode;
    filter.type = kGMSPlacesAutocompleteTypeFilterGeocode;
    filter.country = @"IR";
    
    
    [_placesClient autocompleteQuery:searchBar.searchField.text
                              bounds:nil
                              filter:filter
                            callback:^(NSArray *results, NSError *error) {
                                if (error != nil) {
                                    NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                    return;
                                    
                                }
                                NSMutableArray *temp = [[NSMutableArray alloc] init];
                                for (GMSAutocompletePrediction* result in results) {
                                    NSLog(@"Result '%@' with placeID %@", result.attributedFullText.string, result.placeID);
                                    ASJDropDownMenuItem *menuItem = [ASJDropDownMenuItem itemWithTitle:result.attributedFullText.string subtitle:@"" image:[UIImage imageNamed:@"Pin.png"]];
                                    [temp addObject:menuItem];
                                }
                                if (temp.count>0) {
                                    
                                    
                                    _dropDown.menuItems = temp;
                                    [activityIndicatorView stopAnimating];
                                    
                                    [_dropDown showMenuWithCompletion:^(ASJDropDownMenu *dropDownMenu, ASJDropDownMenuItem *menuItem, NSUInteger index)
                                     {
                                         searchBar.searchField.text = menuItem.title;
                                         GMSAutocompletePrediction *place;
                                         for (GMSAutocompletePrediction *item in results) {
                                             
                                             if ([[item attributedFullText].string isEqualToString:menuItem.title]) {
                                                 place = item;
                                             }
                                         }
                                         
                                         [activityIndicatorView startAnimating];
                                         [_placesClient lookUpPlaceID:place.placeID callback:^(GMSPlace *place, NSError *error) {
                                             [activityIndicatorView stopAnimating];
                                             [self ResetView];
                                             if (error != nil) {
                                                 NSLog(@"Place Details error %@", [error localizedDescription]);
                                                 return;
                                             }
                                             
                                             if (place != nil) {
                                                 
                                                 GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:place.coordinate.latitude
                                                                                                         longitude:place.coordinate.longitude
                                                                                                              zoom:18.0];
                                                 [mapView animateToCameraPosition:camera];
                                                 
                                             } else {
                                                 
                                             }
                                         }];
                                         
                                     }];
                                }
                            }];
    
}


-(void)searchBarDidTap:(INSSearchBar *)searchBar
{
    searchBar.searchField.text = @"";
    
    UIGraphicsBeginImageContext(mapView.frame.size);
    [[mapView layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(screenshot,  .00001f);

    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.HumanPin.alpha = 0;
                         self.bluredView.alpha = 1;
                         layer.alpha = .2f;

                     } completion:NULL];
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self.view endEditing:YES];
    [self ResetView];
}

-(void)ResetView
{
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.HumanPin.alpha = 1;
                         self.bluredView.alpha = 0;
                         layer.alpha = 0;
//                         self.searchBarWithDelegate.frame = CGRectMake(10, 72, CGRectGetWidth(self.view.bounds) - 20.0, 50.0);
                         self.navigationController.navigationBar.alpha = 1.0f;
                     } completion:NULL];
    
    [_dropDown hideMenu];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)CustomizeNavigationBar
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIViewController *previousVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 1];
    // Create a UIBarButtonItem
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(popViewController)];
    // Associate the barButtonItem to the previous view
    [previousVC.navigationItem setBackBarButtonItem:barButtonItem];
}

- (DataDownloader *)getData
{
    if (!_getData) {
        self.getData = [[DataDownloader alloc] init];
    }
    
    return _getData;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
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
