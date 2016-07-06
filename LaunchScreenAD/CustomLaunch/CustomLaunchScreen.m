//
//  CustomLaunchScreen.m
//  LaunchScreenAD
//
//  Created by Shao Jie on 16/7/5.
//  Copyright © 2016年 yourangroup. All rights reserved.
//

#import "CustomLaunchScreen.h"
#import "DisplayWebViewController.h"
#import "TimeCircleView.h"
#define ENTERBACKGROUND @"EnterBackgroundTime"
//进入后台再次启动应用间隔至少 TIMEINTERVAL 时间展示广告
#define TIMEINTERVAL 10.0
//设置广告几秒消失
#define AFTERINTERVAL 60.0
@interface CustomLaunchScreen ()<timeCircleClick>
@property (nonatomic,strong) UIWindow * displayWindow;
@end
@implementation CustomLaunchScreen
//在load方法中，启动监听。
+ (void)load{
    [self defaultInstance];
}
+ (instancetype)defaultInstance{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        __weak __typeof(self) weakSelf = self;
        //第一次启动要展示广告
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            ///要等DidFinished方法结束后才能初始化UIWindow，不然会检测是否有rootViewController
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf dispalyAdvertisement];
            });
        }];
        //进入后台，记录时间，
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [weakSelf recordTime];
        }];
        //后台启动,计算时间是否展示广告，并不是每次进入都要展示广告
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            if ([weakSelf isDisplayAd]) {
                [weakSelf dispalyAdvertisement];
            }
        }];

    }
    return self;
}
//广告展示
- (void)dispalyAdvertisement{
    
    //广告图片
    UIImageView * displayImageView = [[UIImageView alloc] initWithFrame:self.displayWindow.bounds];
    displayImageView.image = [UIImage imageNamed:@"photo"];
    [self addTapGestureOnImageView:displayImageView];
    [self.displayWindow addSubview:displayImageView];
    
    //圆圈动画实现
    TimeCircleView * timeCircle = [[TimeCircleView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 10, 50, 50)];
    [timeCircle startAnimationWithDuration:AFTERINTERVAL];
    timeCircle.circleDelegate = self;
    [displayImageView addSubview:timeCircle];
    
    
    // AFTERINTERVAL时间后跳过广告页
    __weak __typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AFTERINTERVAL * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.displayWindow.alpha = 0;
            displayImageView.frame = CGRectMake(0, 0, 5000, 5000);
            displayImageView.center = weakSelf.displayWindow.center;
        } completion:^(BOOL finished) {
            [weakSelf.displayWindow.subviews.copy enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj removeFromSuperview];
            }];
            weakSelf.displayWindow.hidden = YES;
            weakSelf.displayWindow = nil;
        }];
    });
    

}
#pragma mark --- TimeCircleViewDelegate
- (void)timeCircleButtonClick:(TimeCircleView *)timeCircleView{
    [timeCircleView removeFromSuperview];
    [self removeWindow];
}
- (void)removeWindow{
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.displayWindow.alpha = 0;
        for (UIView * view in self.displayWindow.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                UIImageView * imageView = (UIImageView *)view;
                imageView.frame = CGRectMake(0, 0, 5000, 5000);
                imageView.center = weakSelf.displayWindow.center;
            }
        }
    } completion:^(BOOL finished) {
        [weakSelf.displayWindow.subviews.copy enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        weakSelf.displayWindow.hidden = YES;
        weakSelf.displayWindow = nil;
    }];
}
//点击手势添加
- (void)addTapGestureOnImageView:(UIImageView *)imageView{
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClicked:)];
    tapGesture.numberOfTapsRequired = 1;
    [imageView addGestureRecognizer:tapGesture];
}
- (void)tapGestureClicked:(UIGestureRecognizer *)tap{
    // nil掉最上面一层window
    self.displayWindow.hidden = YES;
    self.displayWindow = nil;
    // 界面跳转
    UIViewController * rootController = [[UIApplication sharedApplication].delegate window].rootViewController;
    [[rootController getRootViewController] pushViewController:[[DisplayWebViewController alloc] init] animated:YES];
}
//懒加载
- (UIWindow *)displayWindow{
    if (_displayWindow == nil) {
        _displayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        //确保创建的window处于最顶层
        _displayWindow.windowLevel = UIWindowLevelStatusBar + 1;
        //显示window，默认不显示
        _displayWindow.hidden = NO;
    }
    return _displayWindow;
}
//记录进入后台的时间
- (void)recordTime{
    @autoreleasepool {
        NSDate * currentDate = [NSDate date];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [[NSUserDefaults standardUserDefaults] setObject:[formatter stringFromDate:currentDate] forKey:ENTERBACKGROUND];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (BOOL)isDisplayAd{
    @autoreleasepool {
        NSString * oldTime = [[NSUserDefaults standardUserDefaults] objectForKey:ENTERBACKGROUND];
        NSDate * currentDate = [NSDate date];
        NSDateFormatter * formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate * oldDate = [formatter dateFromString:oldTime];
        return [currentDate timeIntervalSinceDate:oldDate] >= TIMEINTERVAL;
    }
}
@end
