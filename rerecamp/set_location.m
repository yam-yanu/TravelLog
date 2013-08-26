//
//  set_location.m
//  travel_log
//
//  Created by ami on 2013/08/25.
//  Copyright (c) 2013年 inishie. All rights reserved.
//

#import "set_location.h"

@implementation set_location
@synthesize locationManager;
@synthesize locationManagerForpic;

- (void)set_location:(int)travelNo{
    
    //取り出す旅行Noを調べる
    _travelNo = travelNo;
    //フィールド変数の初期化
    latitude = [NSMutableArray array];
    longitude = [NSMutableArray array];
    date = [NSMutableArray array];
    picture = [NSMutableArray array];
    latitudeForpic = [NSMutableArray array];
    longitudeForpic = [NSMutableArray array];
    dateForpic = [NSMutableArray array];
    index = 0;
    
    //データベース作成
    NSArray  *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    NSString *db_path  = [dir stringByAppendingPathComponent:@"travel_log.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:db_path];
    NSString *sql = [[NSString alloc] initWithFormat:@"SELECT latitude,longitude,date,picture FROM location WHERE travelNo = %d;",_travelNo];
    [db open];
    FMResultSet *result = [db executeQuery:sql];
    while ( [result next] ) {
        [latitude insertObject:[NSNumber numberWithDouble:[result doubleForColumn:@"latitude"]] atIndex:index];
        [longitude insertObject:[NSNumber numberWithDouble:[result doubleForColumn:@"longitude"]] atIndex:index];
        [date insertObject:[result dateForColumn:@"date"] atIndex:index];
        //[picture insertObject:[result dataForColumn:@"picture"] atIndex:index];
        NSLog(@"%@",[latitude objectAtIndex:index]);
        index += 1;
    }
    
    [db close];
    
    
}

- (void)set_gps{
    if ([CLLocationManager locationServicesEnabled]) {
        // インスタンスを生成し、デリゲートの設定
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        
        // 使用可能かの確認
        if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
            // サービスの開始
            [locationManager startMonitoringSignificantLocationChanges];
        }
    }
}

- (void)did_takePicture:(UIImage *)taked_picture{
    //写真用に現在地を更新
    locationManagerForpic = [[CLLocationManager alloc] init];
    locationManagerForpic.delegate = self;
    [locationManagerForpic startUpdatingLocation];
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    NSString *db_path  = [dir stringByAppendingPathComponent:@"travel_log.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:db_path];
    NSString* sql = @"UPDATE location SET picture = (?) WHERE id = (SELECT MAX(id) FROM location)";
    [db open];
    [db executeUpdate:sql,taked_picture];
    [db close];
    
    
}


- (void)instance_release{
    latitude = [NSMutableArray array];
    longitude = [NSMutableArray array];
    date = [NSMutableArray array];
    picture = [NSMutableArray array];
    latitudeForpic = [NSMutableArray array];
    longitudeForpic = [NSMutableArray array];
    dateForpic = [NSMutableArray array];
    index = 0;
}

// 標準位置情報サービス・大幅変更位置情報サービスの取得に成功した場合
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    now_latitude = [newLocation coordinate].latitude;
    now_longitude = [newLocation coordinate].longitude;
    [locationManagerForpic stopUpdatingLocation];
    
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
