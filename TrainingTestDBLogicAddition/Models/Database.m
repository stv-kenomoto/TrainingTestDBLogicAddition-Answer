//
//  Database.m
//  TrainingTestDBLogicAddition
//
//  Created by Kouki Enomoto on 2017/01/25.
//  Copyright © 2017年 enomt. All rights reserved.
//

#import "Database.h"

static NSString *const DatabaseName = @"training_test.db";

@implementation Database

+ (FMDatabase *)database {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir = [path objectAtIndex:0];
    return [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DatabaseName]];
}

@end
