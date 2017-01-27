//
//  Database.h
//  TrainingTestDBLogicAddition
//
//  Created by Kouki Enomoto on 2017/01/25.
//  Copyright © 2017年 enomt. All rights reserved.
//

@import Foundation;

#import <FMDB.h>

@interface Database : NSObject

+ (FMDatabase *)database;

@end
