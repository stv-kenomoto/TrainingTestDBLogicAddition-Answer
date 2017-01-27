//
//  ToDoService.h
//  TrainingTestDBLogicAddition
//
//  Created by Kouki Enomoto on 2017/01/25.
//  Copyright © 2017年 enomt. All rights reserved.
//

@import Foundation;

#import "ToDo.h"
#import "CloseHistory.h"

@interface ToDoService : NSObject

+ (void)configure;

+ (NSArray<ToDo *> *)todoList;

+ (NSArray<CloseHistory *> *)closeHistories;

+ (BOOL)saveWithTodo:(ToDo *)todo;

+ (BOOL)changeStarWithToDo:(ToDo *)todo;

+ (BOOL)closeWithToDo:(ToDo *)todo;

+ (BOOL)unCloseWithCloseHistory:(CloseHistory *)closeHistory;

+ (BOOL)deleteWithToDo:(ToDo *)todo;

+ (BOOL)deleteWithCloseHistory:(CloseHistory *)closeHistory;

@end
