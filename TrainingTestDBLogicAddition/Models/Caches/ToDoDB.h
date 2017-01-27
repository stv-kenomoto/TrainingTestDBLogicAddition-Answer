//
//  ToDoDB.h
//  TrainingTestDBLogicAddition
//
//  Created by Kouki Enomoto on 2017/01/25.
//  Copyright © 2017年 enomt. All rights reserved.
//

@import UIKit;

#import <FMDB.h>
#import "ToDo.h"

@interface ToDoDB : NSObject

UIKIT_EXTERN NSString *const ToDoDBTable;

UIKIT_EXTERN NSString *const ToDoDBID;
UIKIT_EXTERN NSString *const ToDoDBTitle;
UIKIT_EXTERN NSString *const ToDoDBDate;
UIKIT_EXTERN NSString *const ToDoDBLocale;
UIKIT_EXTERN NSString *const ToDoDBPriority;
UIKIT_EXTERN NSString *const ToDoDBTag;
UIKIT_EXTERN NSString *const ToDoDBStar;
UIKIT_EXTERN NSString *const ToDoDBClose;

+ (void)executeCreateWithDatabase:(FMDatabase *)database;

+ (NSArray<ToDo *> *)executeSelectWithDatabase:(FMDatabase *)database isClose:(BOOL)isClose;

+ (BOOL)executeInsertWithDatabase:(FMDatabase *)database todo:(ToDo *)todo;

+ (BOOL)executeUpdateWithDatabase:(FMDatabase *)database todo:(ToDo *)todo;

+ (BOOL)executeUpdateWithDatabase:(FMDatabase *)database isStar:(BOOL)isStar identifier:(NSInteger)identifier;

+ (BOOL)executeUpdateWithDatabase:(FMDatabase *)database isClose:(BOOL)isClose identifier:(NSInteger)identifier;

+ (BOOL)executeDeleteWithDatabase:(FMDatabase *)database identifier:(NSInteger)identifier;

@end
