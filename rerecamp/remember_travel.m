//
//  remember_travel.m
//  rerecamp
//
//  Created by yukihara on 2013/08/28.
//  Copyright (c) 2013年 edu.self. All rights reserved.
//

#import "remember_travel.h"

@implementation remember_travel
@synthesize date;
@synthesize picture;
    
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
        [picture insertObject:pic atIndex:i];
        i += 1;
    }
    [db close];
}

@end
