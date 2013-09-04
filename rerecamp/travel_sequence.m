//
//  travel_sequence.m
//  travel_log
//
//  Created by ami on 2013/08/25.
//  Copyright (c) 2013年 inishie. All rights reserved.
//

#import "travel_sequence.h"

@implementation travel_sequence

//アプリを最初に起動したときに使用
+ (int)first_launch{
    //ユーザーデフォルト
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //ユーザーIDを取得
    int id = [userDefaults integerForKey:@"id"];
    //旅の途中かを取得
    int traveling = [userDefaults integerForKey:@"traveling"];
    NSLog(@"%d",id);
    
    //初めてアプリを起動する人はユーザーIDを配布
    if(id == 0){
        /*後々サーバーと連携
        //通信コネクト
        NSURLConnection *conect;
        //受信データ
        NSMutableData *data;
        //PHPファイルのURLを設定
        NSString *url =@"http://49.212.200.39/techcamp/give_id.php";//ここにはそれぞれのPHPファイルのURLを指定して下さい
        //非同期通信　準備
        NSURL *myURL = [NSURL URLWithString:url];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:myURL];        
        //非同期通信　開始
        conect = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
        */
        
        // ユーザーデフォルトにIDを登録
        [userDefaults setInteger:1 forKey:@"id"];
        // ユーザーデフォルトに旅中かを登録
        [userDefaults setInteger:0 forKey:@"traveling"];
        // ユーザーデフォルトに旅Noを登録
        [userDefaults setInteger:0 forKey:@"travelNo"];
        // ユーザーデフォルトに地図の現在地（初期値は梅田）を登録
        [userDefaults setDouble:34.698695 forKey:@"latitude"];
        [userDefaults setDouble:135.491582 forKey:@"longitude"];
        // ユーザーデフォルトに現在参照している旅Noを登録
        [userDefaults setInteger:0 forKey:@"referenceTravelNo"];

        //データベース作成+ダミーデータの挿入
        NSArray  *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dir   = [paths objectAtIndex:0];
        NSString *db_path  = [dir stringByAppendingPathComponent:@"travel_log.db"];
        FMDatabase *db = [FMDatabase databaseWithPath:db_path];
        NSString *sql = @"CREATE TABLE IF NOT EXISTS location (id INTEGER PRIMARY KEY AUTOINCREMENT, travelNo INTEGER ,latitude REAL , longitude REAL , date INTEGER , picture BLOB); ";
        NSString *sql2 = @"INSERT INTO location (travelNo,latitude,longitude,date) VALUES (0,?,?,?);";
        [db open];
        [db executeUpdate:sql];
//        double debug_lati = 34.698695;
//        double debug_longi = 135.491582;
//        for(double i =0 ;i < 40; i++){
//            if(arc4random() % 2 == 1){
//                debug_lati += 0.001;
//            }else{
//                debug_longi += 0.001;
//            }
//            [db executeUpdate:sql2,[NSNumber numberWithDouble:debug_lati],[NSNumber numberWithDouble:debug_longi],[NSDate date]];
//        }
        [db close];
        
    
    //旅の途中か判定
    }else if(traveling == 1 ){
        
        return 1;
    }
    return 0;
}


//旅行を始めた時に使用
+ (void)start_travel{
    //ユーザーデフォルト
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //旅中にする
    [userDefaults setInteger:1 forKey:@"traveling"];
    //旅Noを取得しNoを１増やす
    NSInteger travelID = [userDefaults integerForKey:@"travelNo"];
    travelID += 1;
    [userDefaults setInteger:travelID forKey:@"travelNo"];
    
}

//旅行を終えるときに使用
+ (void)finish_travel{
    //ユーザーデフォルト
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //旅中にする
    [userDefaults setInteger:0 forKey:@"traveling"];
}


@end
