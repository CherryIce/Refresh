//
//  UIScrollView+GifHeaderRefresh.m
//  Refresh
//
//  Created by Macx on 2017/11/20.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "UIScrollView+GifHeaderRefresh.h"
#import <objc/runtime.h>

#import "RefreshGifHeader.h"

@implementation UIScrollView (GifHeaderRefresh)

/**
 gif header
 */
- (void)addRefreshHeaderWithHandle:(void (^)(void))handle {
    RefreshGifHeader * header = [[RefreshGifHeader alloc]init];
    header.handle = handle;
    self.header = header;
    [self insertSubview:header atIndex:0];
}

- (void)endRefreshHeader
{
    [self.header endRefreshing];
}

- (void)setHeader:(RefreshGifHeader *)header {
    objc_setAssociatedObject(self, @selector(header), header, OBJC_ASSOCIATION_ASSIGN);
}

- (RefreshGifHeader *)header {
    return objc_getAssociatedObject(self, @selector(header));
}

#pragma mark - Swizzle
+ (void)load {
    Method originalMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    Method swizzleMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"su_dealloc"));
    method_exchangeImplementations(originalMethod, swizzleMethod);
}

- (void)su_dealloc {
    self.header = nil;
    [self su_dealloc];
}

@end
