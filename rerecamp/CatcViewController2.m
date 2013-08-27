//
//  CatcViewController.m
//  rerecamp
//
//  Created by yukihara on 2013/08/23.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import "CatcViewController2.h"

@interface CatcViewController2 ()

@end

@implementation CatcViewController2
@synthesize locationManagerForpic;
@synthesize sl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _travelNo = [userDefaults integerForKey:@"travelNo"];
    sl = [[set_location alloc]init];
    [sl set_gps];
    [sl set_location:_travelNo];

    //地図の作成
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[userDefaults doubleForKey:@"latitude"]
                                                            longitude:[userDefaults doubleForKey:@"longitude"]
                                                                 zoom:13];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    //self.mapView.myLocationEnabled = YES;
    self.view = self.mapView;


//    //マーカーの描画
//    for (int i = 0; i < sl.latitudeForpic.count; i++){
//         GMSMarker *option = [[GMSMarker alloc] init];
//         option.position = CLLocationCoordinate2DMake([sl.latitudeForpic[i] doubleValue], [sl.longitudeForpic[i] doubleValue]);
//         //if (imagearray[i] != nil) option.icon = imagearray[i];//[UIImage imageNamed:@"testicon1.jpg"];
//         option.map = _mapView;
//    }
    //マーカーの描画
    for (int i = 0; i < [sl.optionArray count]; i++){
        GMSMarker *option = [[GMSMarker alloc] init];
        option = [[sl optionArray] objectAtIndex: i];
        option.map = _mapView;
    }

    
    //パスの描画
    GMSPolyline *rectangle = [GMSPolyline polylineWithPath:[sl path]];
    rectangle.map = _mapView;
    
    
    GMSMarker *options = [[GMSMarker alloc] init];
    options.position = CLLocationCoordinate2DMake(34.702252, 135.500231);
    ImgComposer *imc = [ImgComposer sharedManager];
    UIImage *cameraimg = [UIImage imageNamed:@"testicon1.jpg"];
    UIImage *image = [imc composedImageWithOriginal:cameraimg];
    options.icon = image;
    options.title = @"大阪富国生命ビル";
    options.snippet = @"日本";
    options.map = _mapView;
    
    GMSMarker *options1 = [[GMSMarker alloc] init];
    options1.position = CLLocationCoordinate2DMake(34.705, 135.6);
    options1.title = @"大阪富国生命ビル";
    options1.snippet = @"日本";
    options1.map = _mapView;
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//    imageView.frame = CGRectMake(100, 100, 90, 90);
//    imageView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:imageView];

    
//  [self.mapView MarkerWithPosition:options];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self configureView];
    
}

- (void)configureView
{
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0, 416.0, 320.0, 44.0)];
    toolbar.barStyle = UIBarStyleBlack;
    UIBarButtonItem *camerabtn = [[UIBarButtonItem alloc]  initWithTitle:@"カメラ" style:UIBarButtonItemStyleBordered target:self action:@selector( onTapCamera: ) ];
    UIBarButtonItem *top = [[UIBarButtonItem alloc]  initWithTitle:@"おわる" style:UIBarButtonItemStyleBordered target:self action:@selector( onTapOwaru: ) ];
    toolbar.items = [ NSArray arrayWithObjects:camerabtn, top,
                     nil ];
    [self.view addSubview:toolbar];
}

- (void)onTapCamera:(id)inSender
{
    //写真用に現在地を更新
    locationManagerForpic = [[CLLocationManager alloc] init];
    locationManagerForpic.delegate = self;
    [locationManagerForpic startUpdatingLocation];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
		// カメラかライブラリからの読込指定。カメラを指定。
		[imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
		// Delegate
		[imagePickerController setDelegate:self];
		// アニメーションをしてカメラUIを起動
		[self presentViewController:imagePickerController animated:YES completion:nil];
	}
	else
	{
		NSLog(@"camera invalid.");
	}
}

- (void) onTapOwaru:(id)inSender{
    [travel_sequence finish_travel];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    //撮ったデータをUIImageにセットする
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    //カメラロールに画像を保存
    UIImageWriteToSavedPhotosAlbum(image,
                                   self,
                                   @selector(image:didFinishSavingWithError:contextInfo:),
                                   nil);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    //ここからPOSTDATAの作成
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    NSString *db_path  = [dir stringByAppendingPathComponent:@"travel_log.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:db_path];
    NSString* sql = @"UPDATE location SET picture = (?) WHERE id = (SELECT MAX(id) FROM location)";
    [db open];
    [db executeUpdate:sql,image];
    [db close];
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 標準位置情報サービス・大幅変更位置情報サービスの取得に成功した場合
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    //写真用に現在地を更新
    now_latitude = [newLocation coordinate].latitude;
    now_longitude = [newLocation coordinate].longitude;
    [locationManagerForpic stopUpdatingLocation];
    
    
    //データベースに写真情報を登録
    NSArray  *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    NSString *db_path  = [dir stringByAppendingPathComponent:@"travel_log.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:db_path];
    NSString* sql = @"INSERT INTO location (travelNo,latitude,longitude,date) VALUES (?,?,?,?)";
    
    [db open];
    //写真以外の情報を入れる
    [db executeUpdate:sql,[NSNumber numberWithInt:_travelNo],[NSNumber numberWithDouble:now_latitude],[NSNumber numberWithDouble:now_longitude],[NSDate date]];
    
    [db close];
    
    //緯度・経度を出力
    NSLog(@"didUpdateToLocation latitude=%f, longitude=%f",
          [newLocation coordinate].latitude,
          [newLocation coordinate].longitude);
    
}

// 標準位置情報サービス・大幅変更位置情報サービスの取得に失敗した場合
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if (![CLLocationManager locationServicesEnabled])
    {
        UIAlertView *locationSettingConfirm;
        locationSettingConfirm = [[UIAlertView alloc]init];
        [locationSettingConfirm setTitle:@"エラー"];
        [locationSettingConfirm setMessage:@"位置情報設定をOnにしてください"];
        [locationSettingConfirm setDelegate:self];
        
        //「OK」ボタンと「キャンセル」ボタンを表示できるようにしておく
        [locationSettingConfirm addButtonWithTitle:@"OK"];
        [locationSettingConfirm addButtonWithTitle:@"キャンセル"];
        [locationSettingConfirm setCancelButtonIndex:1];
        
        [locationSettingConfirm show];
    }
}

@end

//CGRectMake(0,0,0,0)
