//
//  UIScrollView+Refresh.m
//  Refresh
//
//  Created by Macx on 2017/11/20.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "UIScrollView+Refresh.h"

#import <objc/runtime.h>

@interface UIScrollView()

@property (nonatomic , strong) RefreshNormalHeader *headerView;
@property (nonatomic , strong) RefreshNormalFooter *footerView;


@end

@implementation UIScrollView (Refresh)

// 下拉刷新
- (void)addHeaderRefreshWithBlock:(headerRefresh)block{
    self.headerBlock = block;
    if (self.headerView == nil) {
        self.headerView = [[RefreshNormalHeader alloc]initWithFrame:CGRectMake(0, -50, KScreenWidth, 50)];
    }
    [self addSubview:self.headerView];
    // 监听偏移量
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"RefreshStatu" options:NSKeyValueObservingOptionNew context:nil];
}

// 停止下拉刷新
- (void)endHeaderRefresh{
    [self getRefreshStatus:RefreshStatusCancelRefresh];
    [UIView animateWithDuration:0.5 animations:^{
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
}

// 上拉加载
- (void)addFooterRefreshWithBlock:(footerRefresh)block{

    self.footerBlock = block;
    if (self.footerView == nil) {
        self.footerView = [[RefreshNormalFooter alloc]initWithFrame:CGRectMake(0, self.frame.size.height, KScreenWidth, 50)];
    }
    [self addSubview:self.footerView];
    //    self.jw_loading = NO;
    // 监听偏移量
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"RefreshStatu" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

// 停止上拉加载
- (void)endFooterRefresh{
    [self getRefreshStatus:RefreshStatusCancelLoad];
    [UIView animateWithDuration:0.5 animations:^{
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
}

// 设置刷新状态
- (void)getRefreshStatus:(RefreshStatus)status{

    switch (status) {
            // 设置下拉刷新状态
        case RefreshStatusWillRefresh:// 将要下拉刷新
            self.RefreshStatu = @"RefreshStatusWillRefresh";
            self.headerView.showType = RefreshShowTypeWillRefresh
            ;
            break;
        case RefreshStatusRefreshing:// 正在下拉刷新
            self.RefreshStatu = @"RefreshStatusRefreshing";
            self.headerView.showType = RefreshShowTypeRefreshing;
            break;
        case RefreshStatusCancelRefresh:// 取消下拉刷新
            self.RefreshStatu = @"RefreshStatusCancelRefresh";
            self.headerView.showType = RefreshShowTypeCancelRefresh;
            break;
            // 设置上拉加载状态
        case RefreshStatusWillLoad:// 将要上拉加载
            self.RefreshStatu = @"RefreshStatusWillLoad";
            self.footerView.loadType = LoadShowTypeWillLoad;
            break;
        case RefreshStatusLoading:// 正在上拉加载
            self.RefreshStatu = @"RefreshStatusLoading";
            self.footerView.loadType = LoadShowTypeLoading;
            break;
        case RefreshStatusCancelLoad:// 取消上拉加载
            self.RefreshStatu = @"RefreshStatusCancelLoad";
            self.footerView.loadType = LoadShowTypeCancelLoad;
            break;
        default:
            break;
    }
}
#pragma mark 观察者方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{

    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (self.dragging) {
            if (self.contentOffset.y < 0) {// 处理下拉刷新
                if (![self.RefreshStatu isEqualToString:@"RefreshStatusRefreshing"]) {// 判断是否正在刷新

                    if (self.contentOffset.y <= -50) {// 准备下拉刷新
                        [self getRefreshStatus:RefreshStatusWillRefresh];
                    }else{// 取消下拉刷新
                        [self getRefreshStatus:RefreshStatusCancelRefresh];}
                }
            }else{// 处理上拉加载

                if (![self.RefreshStatu isEqualToString:@"RefreshStatusLoading"]) {// 判断是否处于上拉加载中

                    CGPoint offset = self.contentOffset;
                    CGSize size = self.frame.size;
                    CGSize contentSize = self.contentSize;
                    float load_Y = offset.y + size.height - contentSize.height;// 根据这个值来判断是否到了tableView的最低点
                    if (load_Y > 50) {// 准备上拉加载
                        [self getRefreshStatus:RefreshStatusWillLoad];
                    }else{// 取消上拉加载
                        [self getRefreshStatus:RefreshStatusCancelLoad];
                    }
                }
            }
        }else if([self.RefreshStatu isEqualToString:@"RefreshStatusWillRefresh"]){// 下拉刷新

            [self getRefreshStatus:RefreshStatusRefreshing];
            self.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
            self.headerBlock();
        }else if ([self.RefreshStatu isEqualToString:@"RefreshStatusWillLoad"]){// 上拉加载

            [self getRefreshStatus:RefreshStatusLoading];
            self.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
            self.footerBlock();
        }
    }
    if ([keyPath isEqualToString:@"RefreshStatu"]) {
        if (!self.dragging) {
            if ([self.RefreshStatu isEqualToString:@"RefreshStatusWillRefresh"]) {
                [self getRefreshStatus:RefreshStatusRefreshing];
                self.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
                self.headerBlock();
            }else if ([self.RefreshStatu isEqualToString:@"RefreshStatusWillLoad"]) {
                [self getRefreshStatus:RefreshStatusLoading];
                self.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
                self.footerBlock();
            }
        }
    }
    if ([keyPath isEqualToString:@"contentSize"]) {
        if (self.footerView) {
            CGSize contentSize = self.contentSize;
            float load_y = contentSize.height;
            self.footerView.frame = CGRectMake(0, load_y, KScreenWidth, 50);
        }
    }
}
- (void)dealloc{
    [self removeObserver:self forKeyPath:@"contentOffset"];
    [self removeObserver:self forKeyPath:@"RefreshStatu"];
    [self removeObserver:self forKeyPath:@"contentSize"];
}

#pragma mark 动态添加属性
// 利用runtime来添加视图属性
- (void)setHeaderView:(RefreshNormalHeader *)headerView{
    objc_setAssociatedObject(self, @selector(headerView), headerView, OBJC_ASSOCIATION_RETAIN);
}
- (RefreshNormalHeader *)headerView{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFooterView:(RefreshNormalFooter *)footerView{
    objc_setAssociatedObject(self, @selector(footerView), footerView, OBJC_ASSOCIATION_RETAIN);
}

- (RefreshNormalFooter *)footerView{
    return objc_getAssociatedObject(self, _cmd);
}

// 添加block属性最好使用copy（栈block -> 堆block）
- (void)setHeaderBlock:(headerRefresh)headerBlock{
    objc_setAssociatedObject(self, @selector(headerBlock), headerBlock, OBJC_ASSOCIATION_COPY);
}
- (headerRefresh)headerBlock{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFooterBlock:(footerRefresh)footerBlock{
    objc_setAssociatedObject(self, @selector(footerBlock), footerBlock, OBJC_ASSOCIATION_COPY);
}
- (footerRefresh)footerBlock{
    return objc_getAssociatedObject(self, _cmd);
}

// 添加刷新状态属性
- (void)setRefreshStatu:(NSString *)RefreshStatu{
    objc_setAssociatedObject(self, @selector(RefreshStatu), RefreshStatu, OBJC_ASSOCIATION_COPY);
}

- (NSString *)RefreshStatu{
    return objc_getAssociatedObject(self, _cmd);
}

@end
