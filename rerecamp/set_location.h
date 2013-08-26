//
//  set_location.h
//  travel_log
//
//  Created by ami on 2013/08/25.
//  Copyright (c) 2013年 inishie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface set_location : NSObject<CLLocationManagerDelegate>{
    NSMutableArray *latitude;
    NSMutableArray *longitude;
    NSMutableArray *date;
    NSMutableArray *picture;
    NSMutableArray *latitudeForpic;
    NSMutableArray *longitudeForpic;
    NSMutableArray *dateForpic;
    int index;
    int _travelNo;
    double now_latitude;
    double now_longitude;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocationManager *locationManagerForpic;
- (void)set_location:(int)travelNo;
- (void)set_gps;
- (void)did_takePicture:(UIImage *)taked_picture;
- (void)instance_release;

@end
