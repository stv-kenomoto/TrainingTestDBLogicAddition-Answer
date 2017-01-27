//
//  ToDoService.m
//  TrainingTestDBLogicAddition
//
//  Created by Kouki Enomoto on 2017/01/25.
//  Copyright © 2017年 enomt. All rights reserved.
//

#import "CloseHistoryDB.h"
#import "Database.h"
#import "ToDoDB.h"
#import "ToDoService.h"

@implementation ToDoService

+ (void)configure {
    FMDatabase *database = [Database database];
    [database open];
    [ToDoDB executeCreateWithDatabase:database];
    [CloseHistoryDB executeCreateWithDatabase:database];
    [database close];
}

+ (NSArray<ToDo *> *)todoList {
    FMDatabase *database = [Database database];
    [database open];
    NSArray<ToDo *> *todo = [ToDoDB executeSelectWithDatabase:database isClose:NO];
    [database close];
    return todo;
}

+ (NSArray<CloseHistory *> *)closeHistories {
    FMDatabase *database = [Database database];
    [database open];
    NSArray<CloseHistory *> *closeHistories = [CloseHistoryDB executeSelectWithDatabase:database];
    [database close];
    return closeHistories;
}

+ (BOOL)saveWithTodo:(ToDo *)todo {
    FMDatabase *database = [Database database];
    [database open];

    BOOL isSucceeded = YES;
    if (todo.identifier == ToDoDefaultIdentifier) {
        isSucceeded = [ToDoDB executeInsertWithDatabase:database todo:todo];
    } else {
        isSucceeded =  [ToDoDB executeUpdateWithDatabase:database todo:todo];
    }

    [database close];
    return isSucceeded;
}

+ (BOOL)changeStarWithToDo:(ToDo *)todo {
    FMDatabase *database = [Database database];
    [database open];
    BOOL result = [ToDoDB executeUpdateWithDatabase:database isStar:!todo.isStar identifier:todo.identifier];
    [database close];
    return result ? !todo.isStar : todo.isStar;
}

+ (BOOL)closeWithToDo:(ToDo *)todo {
    FMDatabase *database = [Database database];
    [database open];
    [database beginTransaction];

    BOOL isSucceeded = YES;
    if (![ToDoDB executeUpdateWithDatabase:database isClose:YES identifier:todo.identifier]) {
        isSucceeded = NO;
    }

    if (![CloseHistoryDB executeInsertWithDatabase:database todoIdentifier:todo.identifier]) {
        isSucceeded = NO;
    }

    if (isSucceeded) {
        [database commit];
    } else {
        [database rollback];
    }

    [database close];
    return isSucceeded;
}

+ (BOOL)unCloseWithCloseHistory:(CloseHistory *)closeHistory {
    FMDatabase *database = [Database database];
    [database open];
    [database beginTransaction];

    BOOL isSucceeded = YES;
    if (![ToDoDB executeUpdateWithDatabase:database isClose:NO identifier:closeHistory.todoIdentifier]) {
        isSucceeded = NO;
    }

    if (![CloseHistoryDB executeDeleteWithDatabase:database identifier:closeHistory.identifier]) {
        isSucceeded = NO;
    }

    if (isSucceeded) {
        [database commit];
    } else {
        [database rollback];
    }

    [database close];
    return isSucceeded;
}

+ (BOOL)deleteWithToDo:(ToDo *)todo {
    FMDatabase *database = [Database database];
    [database open];
    BOOL isSucceeded = [ToDoDB executeDeleteWithDatabase:database identifier:todo.identifier];
    [database close];
    return isSucceeded;
}

+ (BOOL)deleteWithCloseHistory:(CloseHistory *)closeHistory {
    FMDatabase *database = [Database database];
    [database open];
    [database beginTransaction];

    BOOL isSucceeded = YES;
    if (![ToDoDB executeDeleteWithDatabase:database identifier:closeHistory.todoIdentifier]) {
        isSucceeded = NO;
    }

    if (![CloseHistoryDB executeDeleteWithDatabase:database identifier:closeHistory.identifier]) {
        isSucceeded = NO;
    }

    if (isSucceeded) {
        [database commit];
    } else {
        [database rollback];
    }

    [database close];
    return isSucceeded;
}

@end
