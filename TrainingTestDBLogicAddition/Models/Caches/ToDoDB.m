//
//  ToDoDB.m
//  TrainingTestDBLogicAddition
//
//  Created by Kouki Enomoto on 2017/01/25.
//  Copyright © 2017年 enomt. All rights reserved.
//

#import "Database.h"
#import "ToDoDB.h"

@implementation ToDoDB

NSString *const ToDoDBTable = @"todo";

NSString *const ToDoDBID = @"id";
NSString *const ToDoDBTitle = @"title";
NSString *const ToDoDBDate = @"date";
NSString *const ToDoDBLocale = @"locale";
NSString *const ToDoDBPriority = @"priority";
NSString *const ToDoDBTag = @"tag";
NSString *const ToDoDBStar = @"isStar";
NSString *const ToDoDBClose = @"isClose";

+ (void)executeCreateWithDatabase:(FMDatabase *)database {
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY AUTOINCREMENT, %@ TEXT, %@ DATETIME, %@ TEXT, %@ INTEGER, %@ INTEGER, %@ BOOL, %@ BOOL);",
                     ToDoDBTable,
                     ToDoDBID,
                     ToDoDBTitle,
                     ToDoDBDate,
                     ToDoDBLocale,
                     ToDoDBPriority,
                     ToDoDBTag,
                     ToDoDBStar,
                     ToDoDBClose];

    [database executeUpdate:sql];
}

+ (NSArray<ToDo *> *)executeSelectWithDatabase:(FMDatabase *)database isClose:(BOOL)isClose {
    NSString *sql = [NSMutableString stringWithFormat:@"SELECT %@, %@, %@, %@, %@, %@, %@, %@ FROM %@ WHERE %@ = ?",
                     ToDoDBID,
                     ToDoDBTitle,
                     ToDoDBDate,
                     ToDoDBLocale,
                     ToDoDBPriority,
                     ToDoDBTag,
                     ToDoDBStar,
                     ToDoDBClose,
                     ToDoDBTable,
                     ToDoDBClose];

    FMResultSet *result = [database executeQuery:sql, [NSNumber numberWithBool:isClose]];
    NSMutableArray<ToDo *> *todoList = [@[] mutableCopy];
    while ([result next]) {
        ToDo *todo = [[ToDo alloc] init];
        todo.identifier = [result intForColumn:ToDoDBID];
        todo.title = [result stringForColumn:ToDoDBTitle];
        todo.date = [result dateForColumn:ToDoDBDate];
        todo.locale = [result stringForColumn:ToDoDBLocale];
        todo.priority = [result intForColumn:ToDoDBPriority];
        todo.tag = [result intForColumn:ToDoDBTag];
        todo.isStar = [result boolForColumn:ToDoDBStar];
        todo.isClose= [result boolForColumn:ToDoDBClose];
        [todoList addObject:todo];
    }

    return todoList;
}

+ (BOOL)executeInsertWithDatabase:(FMDatabase *)database todo:(ToDo *)todo {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@, %@, %@, %@) VALUES (?, ?, ?, ?, ?, ?, ?)",
                     ToDoDBTable,
                     ToDoDBTitle,
                     ToDoDBDate,
                     ToDoDBLocale,
                     ToDoDBPriority,
                     ToDoDBTag,
                     ToDoDBStar,
                     ToDoDBClose];

    return [database executeUpdate:sql,
                   todo.title,
                   todo.date,
                   todo.locale,
                   [NSNumber numberWithInteger:todo.priority],
                   [NSNumber numberWithInteger:todo.tag],
                   [NSNumber numberWithBool:todo.isStar],
                   [NSNumber numberWithBool:todo.isClose]];
}

+ (BOOL)executeUpdateWithDatabase:(FMDatabase *)database todo:(ToDo *)todo {
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ? WHERE %@ = ?",
                     ToDoDBTable,
                     ToDoDBTitle,
                     ToDoDBDate,
                     ToDoDBLocale,
                     ToDoDBPriority,
                     ToDoDBTag,
                     ToDoDBStar,
                     ToDoDBClose,
                     ToDoDBID];

    return [database executeUpdate:sql,
                   todo.title,
                   todo.date,
                   todo.locale,
                   [NSNumber numberWithInteger:todo.priority],
                   [NSNumber numberWithInteger:todo.tag],
                   [NSNumber numberWithBool:todo.isStar],
                   [NSNumber numberWithBool:todo.isClose],
                   [NSNumber numberWithInteger:todo.identifier]];
}

+ (BOOL)executeUpdateWithDatabase:(FMDatabase *)database isStar:(BOOL)isStar identifier:(NSInteger)identifier {
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?",
                     ToDoDBTable,
                     ToDoDBStar,
                     ToDoDBID];

    return [database executeUpdate:sql, [NSNumber numberWithBool:isStar], [NSNumber numberWithInteger:identifier]];
}

+ (BOOL)executeUpdateWithDatabase:(FMDatabase *)database isClose:(BOOL)isClose identifier:(NSInteger)identifier {
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?",
                     ToDoDBTable,
                     ToDoDBClose,
                     ToDoDBID];

    return [database executeUpdate:sql, [NSNumber numberWithBool:isClose], [NSNumber numberWithInteger:identifier]];
}

+ (BOOL)executeDeleteWithDatabase:(FMDatabase *)database identifier:(NSInteger)identifier {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",
                     ToDoDBTable,
                     ToDoDBID];

    return [database executeUpdate:sql, [NSNumber numberWithInteger:identifier]];
}

@end
