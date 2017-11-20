//
//  UIScrollView+Refresh.h
//  Refresh
//
//  Created by Macx on 2017/11/20.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RefreshNormalHeader.h"
#import "RefreshNormalFooter.h"

typedef NS_ENUM(NSInteger , RefreshStatus) {
    // 刷新状态
    RefreshStatusWillRefresh = 0,
    RefreshStatusRefreshing = 1,
    RefreshStatusCancelRefresh = 2,
    RefreshStatusWillLoad = 3,
    RefreshStatusLoading = 4,
    RefreshStatusCancelLoad
};

// 刷新的回调
typedef void(^headerRefresh)(void);
typedef void(^footerRefresh)(void);

@interface UIScrollView (Refresh)

@property (nonatomic , copy) headerRefresh headerBlock;
@property (nonatomic , copy) footerRefresh footerBlock;
@property (nonatomic , copy) NSString * RefreshStatu;

// 下拉刷新
- (void)addHeaderRefreshWithBlock:(headerRefresh)block;
- (void)endHeaderRefresh;

// 上拉加载
- (void)addFooterRefreshWithBlock:(footerRefresh)block;
- (void)endFooterRefresh;

@end
