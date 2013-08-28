//
//  travel_sequence.h
//  travel_log
//
//  Created by ami on 2013/08/25.
//  Copyright (c) 2013年 inishie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface travel_sequence : NSObject


+ (int)first_launch;
+ (void)start_travel;
+ (void)finish_travel;

@end
