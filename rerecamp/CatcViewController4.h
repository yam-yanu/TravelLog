//
//  CatcViewController4.h
//  rerecamp
//
//  Created by yukihara on 2013/08/27.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "set_location.h"
#import "ImgComposer.h"
#import "CatcViewController5.h"
#import "remember_travel.h"

@interface CatcViewController4 : UIViewController<GMSMapViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet GMSMapView *mapView;
@property (nonatomic, weak) IBOutlet GMSCameraPosition *camera;
@property (nonatomic, weak) IBOutlet GMSPolyline *line;
@property (weak, nonatomic) IBOutlet UIView *subview;
@property (nonatomic, retain) set_location *sl;
@property (nonatomic, retain) GMSPolyline *rectangle;



@end
