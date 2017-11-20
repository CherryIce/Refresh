//
//  UIScrollView+GifHeaderRefresh.h
//  Refresh
//
//  Created by Macx on 2017/11/20.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RefreshGifHeader;

@interface UIScrollView (GifHeaderRefresh)

@property (nonatomic, weak, readonly) RefreshGifHeader * header;

- (void)addRefreshHeaderWithHandle:(void (^)(void))handle;

- (void)endRefreshHeader;

@end
