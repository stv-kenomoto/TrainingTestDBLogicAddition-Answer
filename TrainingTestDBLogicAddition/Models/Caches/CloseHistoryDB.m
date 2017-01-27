//
//  CloseHistoryDB.m
//  TrainingTestDBLogicAddition
//
//  Created by Kouki Enomoto on 2017/01/27.
//  Copyright © 2017年 enomt. All rights reserved.
//

#import "CloseHistoryDB.h"
#import "Database.h"
#import "ToDoDB.h"

@implementation CloseHistoryDB

NSString *const CloseHistoryDBTable = @"close_history";

NSString *const CloseHistoryDBID = @"id";
NSString *const CloseHistoryDBToDoID = @"todo_id";
NSString *const CloseHistoryDBDate = @"date";

+ (void)executeCreateWithDatabase:(FMDatabase *)database; {
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY AUTOINCREMENT, %@ INTEGER, %@ DATETIME);",
                     CloseHistoryDBTable,
                     CloseHistoryDBID,
                     CloseHistoryDBToDoID,
                     CloseHistoryDBDate];

    [database executeUpdate:sql];
}

+ (NSArray<CloseHistory *> *)executeSelectWithDatabase:(FMDatabase *)database {
    NSString *sql = [NSMutableString stringWithFormat:@"SELECT %@, %@, %@, %@, %@, %@, %@ FROM %@ LEFT OUTER JOIN %@ ON %@ = %@;",
                     [NSString stringWithFormat:@"%@.%@", CloseHistoryDBTable, CloseHistoryDBID],
                     [NSString stringWithFormat:@"%@.%@", CloseHistoryDBTable, CloseHistoryDBToDoID],
                     [NSString stringWithFormat:@"%@.%@", ToDoDBTable, ToDoDBTitle],
                     [NSString stringWithFormat:@"%@.%@", CloseHistoryDBTable, CloseHistoryDBDate],
                     [NSString stringWithFormat:@"%@.%@", ToDoDBTable, ToDoDBLocale],
                     [NSString stringWithFormat:@"%@.%@", ToDoDBTable, ToDoDBPriority],
                     [NSString stringWithFormat:@"%@.%@", ToDoDBTable, ToDoDBTag],
                     CloseHistoryDBTable,
                     ToDoDBTable,
                     [NSString stringWithFormat:@"%@.%@", CloseHistoryDBTable, CloseHistoryDBToDoID],
                     [NSString stringWithFormat:@"%@.%@", ToDoDBTable, ToDoDBID]];

    FMResultSet *result = [database executeQuery:sql];
    NSMutableArray<CloseHistory *> *closeHistories = [@[] mutableCopy];
    while ([result next]) {
        CloseHistory *closeHistory = [[CloseHistory alloc] init];
        closeHistory.identifier = [result intForColumn:CloseHistoryDBID];
        closeHistory.todoIdentifier = [result intForColumn:CloseHistoryDBToDoID];
        closeHistory.title = [result stringForColumn:ToDoDBTitle];
        closeHistory.closeDate = [result dateForColumn:CloseHistoryDBDate];
        closeHistory.locale = [result stringForColumn:ToDoDBLocale];
        closeHistory.priority = [result intForColumn:ToDoDBPriority];
        closeHistory.tag = [result intForColumn:ToDoDBTag];
        [closeHistories addObject:closeHistory];
    }

    return closeHistories;
}

+ (BOOL)executeInsertWithDatabase:(FMDatabase *)database todoIdentifier:(NSInteger)todoIdentifier {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@) VALUES (?, ?)",
                     CloseHistoryDBTable,
                     CloseHistoryDBToDoID,
                     CloseHistoryDBDate];

    return [database executeUpdate:sql, [NSNumber numberWithInteger:todoIdentifier], [NSDate date]];
}

+ (BOOL)executeDeleteWithDatabase:(FMDatabase *)database identifier:(NSInteger)identifier {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",
                     CloseHistoryDBTable,
                     CloseHistoryDBID];

    return [database executeUpdate:sql, [NSNumber numberWithInteger:identifier]];
}

@end
