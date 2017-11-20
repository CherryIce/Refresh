//
//  RefreshGifHeader.h
//  Refresh
//
//  Created by Macx on 2017/11/20.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIScrollView+GifHeaderRefresh.h"

@interface RefreshGifHeader : UIView

UIKIT_EXTERN const CGFloat RefreshHeaderHeight;
UIKIT_EXTERN const CGFloat RefreshPointRadius;

@property (nonatomic, copy) void(^handle)(void);

- (void)endRefreshing;

@end
