//
//  set_location.m
//  travel_log
//
//  Created by ami on 2013/08/25.
//  Copyright (c) 2013年 inishie. All rights reserved.
//

#import "set_location.h"


@implementation set_location
@synthesize option;
@synthesize optionArray;
@synthesize locationManager;
@synthesize locationManagerForpic;
@synthesize latitude;
@synthesize longitude;
@synthesize date;
@synthesize picture;
@synthesize latitudeForpic;
@synthesize longitudeForpic;
@synthesize dateForpic;
@synthesize now_latitude;
@synthesize now_longitude;
@synthesize path;

- (void)set_location:(int)travelNo{
    
    //ユーザーデフォルト(現在地取得用)
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    //取り出す旅行Noを調べる
    _travelNo = travelNo;
    //フィールド変数の初期化
    optionArray = [NSMutableArray array];
    latitude = [NSMutableArray array];
    longitude = [NSMutableArray array];
    date = [NSMutableArray array];
    picture = [NSMutableArray array];
    latitudeForpic = [NSMutableArray array];
    longitudeForpic = [NSMutableArray array];
    dateForpic = [NSMutableArray array];
    now_latitude = [userDefaults doubleForKey:@"latitude"];
    now_longitude = [userDefaults doubleForKey:@"longitude"];
    path = [[GMSMutablePath alloc]init];
    index = 0;
    indexForpic = 0;
    
    //パス用の配列を作成
    NSArray  *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    NSString *db_path  = [dir stringByAppendingPathComponent:@"travel_log.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:db_path];
//    NSString *sql = [[NSString alloc] initWithFormat:@"SELECT latitude,longitude,date FROM location WHERE travelNo = %d;",_travelNo];
    NSString *sql = [[NSString alloc] initWithFormat:@"SELECT latitude,longitude,date FROM location ;"];
    [db open];
    FMResultSet *result = [db executeQuery:sql];
    while ( [result next] ) {
        [latitude insertObject:[NSNumber numberWithDouble:[result doubleForColumn:@"latitude"]] atIndex:index];
        [longitude insertObject:[NSNumber numberWithDouble:[result doubleForColumn:@"longitude"]] atIndex:index];
        [date insertObject:[result dateForColumn:@"date"] atIndex:index];
        index += 1;

        //パス描画用の変数に入れる
        double lati = [result doubleForColumn:@"latitude"];
        [path addCoordinate:CLLocationCoordinate2DMake([result doubleForColumn:@"latitude"], [result doubleForColumn:@"longitude"])];

    }
    [db close];

    
    
    //写真用を描画
    paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    dir   = [paths objectAtIndex:0];
    db_path  = [dir stringByAppendingPathComponent:@"travel_log.db"];
    db = [FMDatabase databaseWithPath:db_path];
    //sql = [[NSString alloc] initWithFormat:@"SELECT id,latitude,longitude,date,picture FROM location WHERE travelNo = %d AND travelpicture IS NOT NULL;",_travelNo];
    sql = [[NSString alloc] initWithFormat:@"SELECT id,latitude,longitude,date,picture FROM location WHERE picture IS NOT NULL;"];
    [db open];
    result = [db executeQuery:sql];
    while ( [result next] ) {
        [latitudeForpic insertObject:[NSNumber numberWithDouble:[result doubleForColumn:@"latitude"]] atIndex:indexForpic];
        [longitudeForpic insertObject:[NSNumber numberWithDouble:[result doubleForColumn:@"longitude"]] atIndex:indexForpic];
        [dateForpic insertObject:[result dateForColumn:@"date"] atIndex:indexForpic];
        [picture insertObject:[result dataForColumn:@"picture"] atIndex:indexForpic];
        int id = [result intForColumn:@"id"];
        NSLog(@"%d",id);

        //マーカー作成用変数
        option = [[GMSMarker alloc] init];
        option.position = CLLocationCoordinate2DMake([result doubleForColumn:@"latitude"], [result doubleForColumn:@"longitude"]);
        ImgComposer *imc = [ImgComposer sharedManager];
        UIImage *cameraimg = [[UIImage alloc] initWithData:[result dataForColumn:@"picture"]];
        UIImage *image = [imc composedImageWithOriginal:cameraimg];
        option.icon = image;
        [optionArray insertObject:option atIndex:indexForpic];
        
        
        indexForpic += 1;
        
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


- (void)finish_location{
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
    //ユーザーデフォルト
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setDouble:[newLocation coordinate].latitude forKey:@"latitude"];
    [userDefaults setDouble:[newLocation coordinate].longitude forKey:@"longitude"];
    
    now_latitude = [newLocation coordinate].latitude;
    now_longitude = [newLocation coordinate].longitude;
    
    //データベースに位置情報を入れる
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

-(GMSMarker *)makeMarker:(UIImage *)image{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    option = [[GMSMarker alloc] init];
    option.position = CLLocationCoordinate2DMake([userDefaults doubleForKey:@"latitude"],[userDefaults doubleForKey:@"longitude"]);
    ImgComposer *imc = [ImgComposer sharedManager];
    UIImage *edited_image = [imc composedImageWithOriginal:image];
    option.icon = edited_image;
    return option;
}

-(void)makePath{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    NSString *db_path  = [dir stringByAppendingPathComponent:@"travel_log.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:db_path];
    NSString *sql = [[NSString alloc] initWithFormat:@"SELECT latitude,longitude FROM location ORDER BY id DESC LIMIT 1;"];
    [db open];
    FMResultSet *result = [db executeQuery:sql];
    while ( [result next] ) {
        //パス描画用の変数
        [path addCoordinate:CLLocationCoordinate2DMake([result doubleForColumn:@"latitude"], [result doubleForColumn:@"longitude"])];
    }
    [db close];
}

@end
