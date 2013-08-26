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
+ (void)first_launch{
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

        //データベース作成
        NSArray  *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dir   = [paths objectAtIndex:0];
        NSString *db_path  = [dir stringByAppendingPathComponent:@"travel_log.db"];
        FMDatabase *db = [FMDatabase databaseWithPath:db_path];
        NSString *sql = @"CREATE TABLE IF NOT EXISTS location (id INTEGER PRIMARY KEY AUTOINCREMENT, travelNo INTEGER ,latitude REAL , longitude REAL , date INTEGER , picture BLOB); ";
        [db open];
        [db executeUpdate:sql];
        [db close];
    
    //旅の途中か判定
    }else if(traveling == 1 ){

    }

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
