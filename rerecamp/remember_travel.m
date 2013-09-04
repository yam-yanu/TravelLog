//
//  remember_travel.m
//  rerecamp
//
//  Created by yukihara on 2013/08/28.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import "remember_travel.h"

@implementation remember_travel
@synthesize travelName;
@synthesize date;
@synthesize picture;
@synthesize paths;
@synthesize dir;
@synthesize db_path;
@synthesize db;

//イニシャライザ
-(id)init{
    travelName = [NSMutableArray array];
    date = [NSMutableArray array];
    picture = [NSMutableArray array];
    paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    dir   = [paths objectAtIndex:0];
    db_path  = [dir stringByAppendingPathComponent:@"travel_log.db"];
    db = [FMDatabase databaseWithPath:db_path];
    return self;
}

//旅一覧用の配列を作成
-(void)setTravelList{
    [db open];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int travelNo = [userDefaults integerForKey:@"travelNo"];
    for(int i=0;i<=travelNo;i++){
        //旅行の名前を配列に格納
        NSString *tn = [NSString stringWithFormat:@"旅行%d",i];
        [travelName insertObject:tn atIndex:(i)];
        
        //日時の初期化
        NSDate *startDate = [[NSDate alloc]init];
        NSDate *finishDate = [[NSDate alloc]init];
        
        //はじめの時間を取得
        NSString *sql = [[NSString alloc] initWithFormat:@"SELECT travelNo,date,picture FROM location WHERE travelNo = %d ORDER BY id ASC LIMIT 1",i];//AND travelpicture IS NOT NULL LIMIT 1;",travelNo];
        FMResultSet *result = [db executeQuery:sql];
        while ( [result next] ) {
            startDate = [result dateForColumn:@"date"];
        }
        
        //旅行が終了した時刻を取得
        sql = [[NSString alloc] initWithFormat:@"SELECT travelNo,date,picture FROM location WHERE travelNo = %d ORDER BY id DESC LIMIT 1",i];//AND travelpicture IS NOT NULL LIMIT 1;",travelNo];
        result = [db executeQuery:sql];
        while ( [result next] ) {
            finishDate = [result dateForColumn:@"date"];
        }
        
        //日時の成形
        // 2つの日付が同じ(○年○/○)違う(○年○/○〜○/○)に成形
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc]init];
        [outputFormatter setDateFormat:@"yyyy年 M/d"];
        NSString *startStr = [outputFormatter stringFromDate:startDate];
        NSString *finishStr = [outputFormatter stringFromDate:finishDate];
        
        if ([startStr isEqualToString:finishStr]) {
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"yyyy年 M/d"];
            NSString *str =  [outputFormatter stringFromDate:startDate];
            [date insertObject:str atIndex:(i)];
        }else{
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"yyyy年 M/d"];
            NSString *startStr =  [outputFormatter stringFromDate:startDate];
            outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"M/d"];
            NSString *finishStr =  [outputFormatter stringFromDate:finishDate];
            NSString *str = [NSString stringWithFormat:@"%@~%@",startStr,finishStr];
            [date insertObject:str atIndex:(i)];
        }
        
        //旅行ごとの写真を取得
        sql = [[NSString alloc] initWithFormat:@"SELECT travelNo,date,picture FROM location WHERE travelNo = %d AND picture IS NOT NULL ORDER BY id ASC LIMIT 1",i];//AND travelpicture IS NOT NULL LIMIT 1;",travelNo];
        result = [db executeQuery:sql];
        int j = 0;
        while ( [result next] ) {
            [picture insertObject:[result dataForColumn:@"picture"] atIndex:(i)];
            j = 1;
        }
        if(j == 0){
            NSData* pngData = [[NSData alloc] initWithData:UIImagePNGRepresentation([UIImage imageNamed:@"gyoumurei.jpg"])];
            [picture insertObject:pngData atIndex:(i)];
        }
    }
    [db close];
}

//旅の詳細を見たときの写真一覧を配列に格納
-(void)set_array:(int)travelNo{
    NSString *sql = [[NSString alloc] initWithFormat:@"SELECT id,latitude,longitude,date,picture FROM location WHERE travelNo = %d AND travelpicture IS NOT NULL;",travelNo];
    [db open];
    FMResultSet *result = [db executeQuery:sql];
    int i=0;
    while ( [result next] ) {
        //変換用
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"HH:mm 'on' EEEE MMMM d"];
        NSString *str =  [outputFormatter stringFromDate:[result dateForColumn:@"date"]];
        //UIImage *pic = [[UIImage alloc] initWithData:[result dataForColumn:@"picture"]];
        [date insertObject:str atIndex:i];
        //[picture insertObject:[result dataForColumn:@"picture"] atIndex:i];
        i += 1;
    }
    [db close];
}

+(void)resetTravelNo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:0 forKey:@"referenceTravelNo"];
}

+(void)changeTravelNo:(int)newTravelNo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:newTravelNo forKey:@"referenceTravelNo"];
}

+(int)referTravelNo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:@"referenceTravelNo"];
}

@end
