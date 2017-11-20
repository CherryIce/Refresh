//
//  Const.h
//  Refresh
//
//  Created by Macx on 2017/11/20.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#define KScreenWidth  [UIScreen mainScreen].bounds.size.width

#define KScreenHeight [UIScreen mainScreen].bounds.size.height

/**
 下拉刷新状态
 */
typedef NS_ENUM(NSInteger, RefreshShowType) {
    RefreshShowTypeWillRefresh = 0,
    RefreshShowTypeRefreshing = 1,
    RefreshShowTypeCancelRefresh = 2
};

/**
 上拉加载状态
 */
typedef NS_ENUM(NSInteger, LoadShowType) {
    LoadShowTypeWillLoad = 0,
    LoadShowTypeLoading = 1,
    LoadShowTypeCancelLoad = 2
};

@interface Const : NSObject

extern NSString * PullDownRefreshing;

extern NSString * PullDownWillRefresh;

extern NSString * PullDownCancleRefresh;

extern NSString * LoadMoreRefreshing;

extern NSString * LoadMoreWillRefresh;

extern NSString * LoadMoreCancleRefresh;

@end
