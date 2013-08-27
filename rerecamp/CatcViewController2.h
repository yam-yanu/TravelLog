//
//  CatcViewController.h
//  rerecamp
//
//  Created by yukihara on 2013/08/23.
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

@interface CatcViewController2 : UIViewController<GMSMapViewDelegate,UIActionSheetDelegate,CLLocationManagerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    int _travelNo;

}

@property (nonatomic, weak) IBOutlet GMSMapView *mapView;
@property (nonatomic, weak) IBOutlet GMSCameraPosition *camera;
@property (nonatomic, weak) IBOutlet GMSPolyline *line;
@property (weak, nonatomic) IBOutlet UIView *subview;
@property (nonatomic, retain) CLLocationManager *locationManagerForpic;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) set_location *sl;
@property (nonatomic, retain) GMSPolyline *rectangle;

- (void)configureView;
- (void)toolAction;
- (void)set_gps;

@end
