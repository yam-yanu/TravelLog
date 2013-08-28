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
    
-(void)setTravelList{
    //リスト用
    travelName = [NSMutableArray array];
    date = [NSMutableArray array];
    picture = [NSMutableArray array];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    NSString *db_path  = [dir stringByAppendingPathComponent:@"travel_log.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:db_path];
    [db open];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int travelNo = [userDefaults integerForKey:@"travelNo"];
    for(int i=1;i<=travelNo;i++){
        NSString *sql = [[NSString alloc] initWithFormat:@"SELECT travelNo,date,picture FROM location WHERE travelNo = %d AND travelpicture IS NOT NULL LIMIT 1;",travelNo];
        FMResultSet *result = [db executeQuery:sql];
        while ( [result next] ) {
            //変換用
            [travelName insertObject:[NSString stringWithFormat:@"旅行%d",i] atIndex:(i-0)];
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"HH:mm 'on' EEEE MMMM d"];
            NSString *str =  [outputFormatter stringFromDate:[result dateForColumn:@"date"]];
            UIImage *pic = [[UIImage alloc] initWithData:[result dataForColumn:@"picture"]];
            [date insertObject:str atIndex:(i-0)];
            [picture insertObject:[result dataForColumn:@"picture"] atIndex:(i-0)];
        }
    }
    [db close];
}

-(void)set_array:(int)travelNo{
    //写真用を描画
    date = [NSMutableArray array];
    picture = [NSMutableArray array];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir   = [paths objectAtIndex:0];
    NSString *db_path  = [dir stringByAppendingPathComponent:@"travel_log.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:db_path];
    NSString *sql = [[NSString alloc] initWithFormat:@"SELECT id,latitude,longitude,date,picture FROM location WHERE travelNo = %d AND travelpicture IS NOT NULL;",travelNo];
    [db open];
    FMResultSet *result = [db executeQuery:sql];
    int i=0;
    while ( [result next] ) {
        //変換用
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"HH:mm 'on' EEEE MMMM d"];
        NSString *str =  [outputFormatter stringFromDate:[result dateForColumn:@"date"]];
        UIImage *pic = [[UIImage alloc] initWithData:[result dataForColumn:@"picture"]];
        [date insertObject:str atIndex:i];
        [picture insertObject:[result dataForColumn:@"picture"] atIndex:i];
        i += 1;
    }
    [db close];
}

@end
