//
//  set_location.h
//  travel_log
//
//  Created by ami on 2013/08/25.
//  Copyright (c) 2013年 inishie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "ImgComposer.h"

@interface set_location : NSObject<GMSMapViewDelegate,UIActionSheetDelegate,CLLocationManagerDelegate>{
    int index;
    int indexForpic;
    int _travelNo;
}

@property (nonatomic, retain) GMSMutablePath *path;
@property (nonatomic, retain) GMSMarker *option;
@property (nonatomic, retain) NSMutableArray *optionArray;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocationManager *locationManagerForpic;
@property (nonatomic, retain) NSMutableArray *latitude;
@property (nonatomic, retain) NSMutableArray *longitude;
@property (nonatomic, retain) NSMutableArray *date;
@property (nonatomic, retain) NSMutableArray *picture;
@property (nonatomic, retain) NSMutableArray *latitudeForpic;
@property (nonatomic, retain) NSMutableArray *longitudeForpic;
@property (nonatomic, retain) NSMutableArray *dateForpic;
@property (assign) double now_latitude;
@property (assign) double now_longitude;

- (void)set_location:(int)travelNo;
- (void)set_gps;
- (void)finish_location;
-(GMSMarker *)makeMarker:(UIImage *)image;
-(void)makePath;

@end
