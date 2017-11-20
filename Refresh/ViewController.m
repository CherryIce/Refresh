//
//  ViewController.m
//  Refresh
//
//  Created by Macx on 2017/11/20.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "ViewController.h"

#import "RefreshHeader.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%zd-%zd",indexPath.section,indexPath.row];
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView reloadData];
    //[self normalPullDown];
    //[self normalLoadMore];
    [self gitPullDown];
}

/**
 普通下拉刷新
 */
- (void) normalPullDown
{
    __weak typeof(self) weakSelf = self;
    [self.tableView addHeaderRefreshWithBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView endHeaderRefresh];
        });
    }];
}

/**
 gif下拉刷新
 */
- (void) gitPullDown
{
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshHeaderWithHandle:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView endRefreshHeader];
        });
    }];
}

/**
 普通上拉加载
 */
- (void) normalLoadMore
{
    __weak typeof(self) weakSelf = self;
    [self.tableView addFooterRefreshWithBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView endFooterRefresh];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
