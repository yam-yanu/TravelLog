//
//  CatcViewController4.m
//  rerecamp
//
//  Created by yukihara on 2013/08/27.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import "CatcViewController4.h"

@interface CatcViewController4 ()

@end

@implementation CatcViewController4

@synthesize photoTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem* right1 = [[UIBarButtonItem alloc]
                               initWithTitle:@"アルバム"
                               style:UIBarButtonItemStyleBordered
                               target:self
                               action:@selector(nextView)];

    //MAP表示画面
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:34.702310
                                                            longitude:135.500231
                                                                 zoom:13];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    //self.mapView.myLocationEnabled = YES;
    [mapView setFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-40)];
    self.view = self.mapView;
	// Do any additional setup after loading the view.
//    
//    
//    //フォトライブラリ画面
//    photoTableView = [[UITableView alloc] initWithFrame:CGRectMake(280, 0, 260, 480) style:UITableViewStylePlain];
//    [self.view addSubview:photoTableView];
}

- (void)nextView
{
    CatcViewController5 *view = [[CatcViewController5 alloc]init];
    [self.navigationController pushViewController:view animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
