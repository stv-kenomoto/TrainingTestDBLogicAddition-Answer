//
//  CloseHistoryDB.h
//  TrainingTestDBLogicAddition
//
//  Created by Kouki Enomoto on 2017/01/27.
//  Copyright © 2017年 enomt. All rights reserved.
//

@import UIKit;

#import <FMDB.h>
#import "CloseHistory.h"

@interface CloseHistoryDB : NSObject

UIKIT_EXTERN NSString *const CloseHistoryDBTable;

UIKIT_EXTERN NSString *const CloseHistoryDBID;
UIKIT_EXTERN NSString *const CloseHistoryDBToDoID;
UIKIT_EXTERN NSString *const CloseHistoryDBDate;

+ (void)executeCreateWithDatabase:(FMDatabase *)database;

+ (NSArray<CloseHistory *> *)executeSelectWithDatabase:(FMDatabase *)database;

+ (BOOL)executeInsertWithDatabase:(FMDatabase *)database todoIdentifier:(NSInteger)todoIdentifier;

+ (BOOL)executeDeleteWithDatabase:(FMDatabase *)database identifier:(NSInteger)identifier;

@end
