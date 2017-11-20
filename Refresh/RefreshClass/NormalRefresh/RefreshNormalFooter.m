//
//  RefreshNormalFooter.m
//  Refresh
//
//  Created by Macx on 2017/11/20.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RefreshNormalFooter.h"

@interface RefreshNormalFooter()

// 标题
@property (nonatomic , strong) UILabel *title;
// 图片
@property (nonatomic , strong) UIImageView *img;
// 菊花
@property (nonatomic , strong) UIActivityIndicatorView *refreshView;

@end

@implementation RefreshNormalFooter

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        //如果是动画效果，那就三种动画效果配置各个状态
        [self creatViews];
        //KVO是关键
        [self addObserver:self forKeyPath:@"loadType" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
- (void)creatViews{
    
    if (self.title == nil) {
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth/3, 0, KScreenWidth/3, 50)];
        [self addSubview:self.title];
    }
    if (self.img == nil) {
        self.img = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth/3-30, 10, 30, 30)];
        self.img.image = [UIImage imageNamed:@"refresh"];
        [self addSubview:self.img];
    }
    if (self.refreshView == nil) {
        self.refreshView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.refreshView.center = CGPointMake(KScreenWidth/3-15, 25);
        self.refreshView.hidden = YES;
        [self.refreshView startAnimating];
        [self addSubview:self.refreshView];
    }
    self.title.font = [UIFont systemFontOfSize:18];
    self.title.text = LoadMoreCancleRefresh;
    self.title.textAlignment = NSTextAlignmentCenter;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    // 处理刷新视图的改变
    if ([keyPath isEqualToString:@"loadType"]) {
        self.title.text = [self getRefreshStatus:_loadType];
        if (_loadType == LoadShowTypeWillLoad) {
            self.img.hidden = NO;
            self.refreshView.hidden = YES;
            [UIView animateWithDuration:0.3 animations:^{
                self.img.transform=CGAffineTransformMakeRotation(M_PI);
            }];
        }else if (_loadType == LoadShowTypeLoading) {
            self.img.hidden = YES;
            self.refreshView.hidden = NO;
        }else{
            self.img.hidden = NO;
            self.refreshView.hidden = YES;
            [UIView animateWithDuration:0.3 animations:^{
                self.img.transform=CGAffineTransformMakeRotation(0);
            }];
        }
    }
    
}
- (NSString *)getRefreshStatus:(LoadShowType)status{
    
    switch (status) {
        case LoadShowTypeWillLoad:
            return LoadMoreWillRefresh;
        case LoadShowTypeLoading:
            return LoadMoreRefreshing;
        case LoadShowTypeCancelLoad:
            return LoadMoreCancleRefresh;
        default:
            break;
    }
}

@end
