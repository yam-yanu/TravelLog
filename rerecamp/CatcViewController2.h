//
//  CatcViewController.h
//  rerecamp
//
//  Created by yukihara on 2013/08/23.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface CatcViewController2 : UIViewController<GMSMapViewDelegate,UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet GMSMapView *mapView;
@property (nonatomic, weak) IBOutlet GMSCameraPosition *camera;
@property (nonatomic, weak) IBOutlet GMSPolyline *line;
@property (weak, nonatomic) IBOutlet UIView *subview;

- (void)configureView;
- (void)toolAction;

@end
