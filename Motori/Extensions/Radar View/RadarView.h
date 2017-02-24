//
//  RadarView.h
//  Motori
//
//  Created by aDb on 2/23/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Arcs.h"
#import "Radar.h"
#import "Dot.h"
#import <CoreLocation/CoreLocation.h>

@interface RadarView : UIView <CLLocationManagerDelegate>
{
    Arcs *arcsView;
    Radar *radarView;
    float currentDeviceBearing;
    NSMutableArray *dots;
    NSArray *nearbyUsers;
    NSTimer *detectCollisionTimer;
    UIView *radarViewHolder;
    UIView *radarLine;

}
@property (nonatomic, retain) CLLocationManager *locManager;

@end
