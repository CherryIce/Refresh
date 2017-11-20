//
//  RefreshNormalHeader.m
//  Refresh
//
//  Created by Macx on 2017/11/20.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "RefreshNormalHeader.h"


@interface RefreshNormalHeader ()

// 标题
@property (nonatomic , strong) UILabel *title;
// 图片
@property (nonatomic , strong) UIImageView *img;
// 菊花
@property (nonatomic , strong) UIActivityIndicatorView *refreshView;

@end

@implementation RefreshNormalHeader

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, -50, KScreenWidth, 50);
        //如果是动画效果，那就三种动画效果配置各个状态
        [self creatViews];
        //KVO是关键
        [self addObserver:self forKeyPath:@"showType" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

// 添加刷新视图
- (void)creatViews{
    
    if (self.title == nil) {
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth/3, 0, KScreenWidth/3, 50)];
        [self addSubview:self.title];
    }
    if (self.img == nil) {
        self.img = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth/3-30, 10, 30, 30)];
        self.img.image = [UIImage imageNamed:@"refresh"];
        self.img.transform=CGAffineTransformMakeRotation(M_PI);
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
    self.title.text = PullDownCancleRefresh;
    self.title.textAlignment = NSTextAlignmentCenter;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    // 处理刷新视图的改变
    if ([keyPath isEqualToString:@"showType"]) {
        self.title.text = [self getRefreshStatus:_showType];
        if (_showType == RefreshShowTypeWillRefresh) {
            self.img.hidden = NO;
            self.refreshView.hidden = YES;
            [UIView animateWithDuration:0.3 animations:^{
                self.img.transform=CGAffineTransformMakeRotation(0);
            }];
        }else if (_showType == RefreshShowTypeRefreshing) {
            self.img.hidden = YES;
            self.refreshView.hidden = NO;
        }else{
            self.img.hidden = NO;
            self.refreshView.hidden = YES;
            [UIView animateWithDuration:0.3 animations:^{
                self.img.transform=CGAffineTransformMakeRotation(M_PI);
            }];
        }
    }
}

- (NSString *)getRefreshStatus:(RefreshShowType)status{
    
   switch (status) {
            
        case RefreshShowTypeWillRefresh:
            return PullDownWillRefresh;
        case RefreshShowTypeRefreshing:
            return PullDownRefreshing;
        case RefreshShowTypeCancelRefresh:
            return PullDownCancleRefresh;
        default:
            break;
    }
}
@end
