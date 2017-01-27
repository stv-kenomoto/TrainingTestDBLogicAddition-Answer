//
//  ClosedListViewController.m
//  TrainingTestDBLogicAddition
//
//  Created by Kouki Enomoto on 2017/01/27.
//  Copyright © 2017年 enomt. All rights reserved.
//

#import "ClosedListViewController.h"
#import "ClosedListViewDataSource.h"
#import "EmptyClosedView.h"
#import "LocalizedString.h"
#import "NSString+Localization.h"
#import "ToDoService.h"
#import "UIView+Nib.h"

@interface ClosedListViewController () <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) EmptyClosedView *emptyClosedView;
@property (strong, nonatomic) ClosedListViewDataSource *dataSource;

@end

@implementation ClosedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupEmptyView];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadToDo];
}

- (void)setupEmptyView {
    self.emptyClosedView = [EmptyClosedView defaultViewFromNib];
}

- (void)setupTableView {
    self.tableView.delegate = self;
}

- (void)deleteToDoInTableViewWithIndexPath:(NSIndexPath *)indexPath {
    [self.dataSource.closeHistories removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    if (self.dataSource.closeHistories.count == 0) {
        [self.view addSubview:self.emptyClosedView];
    }
}

- (void)loadToDo {
    NSArray<CloseHistory *> *closeHistories = [ToDoService closeHistories];
    if (closeHistories.count == 0) {
        [self.view addSubview:self.emptyClosedView];
    } else {
        [self.emptyClosedView removeFromSuperview];
        self.dataSource = [[ClosedListViewDataSource alloc] initWithCloseHistories:[closeHistories mutableCopy]];
        self.tableView.dataSource = self.dataSource;
    }
}

#pragma mark - UITableViewDelegate
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @[
             [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                title:LocalizedStringUnclosed.localized
                                              handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                  if ([ToDoService unCloseWithCloseHistory:self.dataSource.closeHistories[indexPath.row]]) {
                                                      [self deleteToDoInTableViewWithIndexPath:indexPath];
                                                  } else {
                                                      [tableView setEditing:NO animated:YES];
                                                  }
                                              }],
             [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                title:LocalizedStringDelete.localized
                                              handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                  if ([ToDoService deleteWithCloseHistory:self.dataSource.closeHistories[indexPath.row]]) {
                                                      [self deleteToDoInTableViewWithIndexPath:indexPath];
                                                  } else {
                                                      [tableView setEditing:NO animated:YES];
                                                  }
                                              }]];
}

@end
