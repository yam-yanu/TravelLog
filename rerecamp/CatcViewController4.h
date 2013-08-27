//
//  CatcViewController4.h
//  rerecamp
//
//  Created by yukihara on 2013/08/27.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "travel_sequence.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "set_location.h"
#import "ImgComposer.h"
#import "CatcViewController5.h"

@interface CatcViewController4 : UIViewController
{
    UIView *mapView;
@private
NSTimeInterval timestampBegan;
    CGPoint pointBegan;
}

@property (nonatomic, weak) IBOutlet GMSMapView *mapView;
@property (nonatomic, weak) IBOutlet GMSCameraPosition *camera;
@property (nonatomic, weak) IBOutlet GMSPolyline *line;
@property (weak, nonatomic) IBOutlet UIView *subview;
@property (nonatomic, retain) CLLocationManager *locationManagerForpic;
@property (nonatomic, retain) set_location *sl;
@property (strong, atomic) UITableView *photoTableView;

- (void)configureView;
- (void)toolAction;

@end
