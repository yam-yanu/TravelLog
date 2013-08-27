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

    //MAP表示画面
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:34.702310
                                                            longitude:135.500231
                                                                 zoom:13];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    //self.mapView.myLocationEnabled = YES;
    [mapView setFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-40)];
    self.view = self.mapView;
	// Do any additional setup after loading the view.
    
    
    //フリック先フォトライブラリ画面
    photoTableView = [[UITableView alloc] initWithFrame:CGRectMake(280, 0, 260, 480) style:UITableViewStylePlain];
    [self.view addSubview:photoTableView];
}

/*フリック検知*/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //タッチした時間と位置を保存
    UITouch *touch = [touches anyObject];
    timestampBegan = event.timestamp;
    pointBegan = [touch locationInView:self.view];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    static const NSTimeInterval kFlickJudgeTimeInterval = 0.4;  //フリック検出時間
    static const NSInteger kFlickMinimumDistance = 3;  //フリック検出の最低距離
    UITouch *touchEnded = [touches anyObject];
    CGPoint pointEnded = [touchEnded locationInView:self.view];
    NSInteger distanceHorizontal = abs(pointEnded.x - pointBegan.x);
    NSInteger distanceVertical = abs(pointEnded.y - pointBegan.y);
    
    if (kFlickMinimumDistance > distanceHorizontal &&
        kFlickMinimumDistance > distanceVertical){
        //縦にも横にもあまり移動してなければreturn
        return;
    }
    
    NSTimeInterval timeBeganToEnded = event.timestamp - timestampBegan;
    
        //フリック扱い
        if (kFlickJudgeTimeInterval > timeBeganToEnded) {
            //フリック方向の判定
            if (distanceHorizontal > distanceVertical) {
                if (pointEnded.x > pointBegan.x) {
                    //右フリック(動かす)
                    NSLog(@"右");
                    [UIView animateWithDuration:0.5 animations:^{
                        [photoTableView setFrame:CGRectMake(60, 40, 260, self.view.bounds.size.height-40)];
                    }];
                    mapView.center = CGPointMake(self.view.bounds.size.width/2+250, self.view.bounds.size.height/2);
                }
                else{
                    //左フリック(戻す)
                    NSLog(@"左");
                    mapView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
                }
            }
        }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
