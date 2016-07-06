//
//  TimeCircleView.m
//  timeCircle
//
//  Created by Shao Jie on 16/7/6.
//  Copyright © 2016年 yourangroup. All rights reserved.
//

#import "TimeCircleView.h"
@interface TimeCircleView ()
@property (nonatomic,strong) CAShapeLayer * trackLayer;
@property (nonatomic,strong) CAShapeLayer * progressLayer;
@property (nonatomic,strong) CAGradientLayer * gradientLayer;
@property (nonatomic,strong) UIColor * trackColor;
@property (nonatomic,strong) UIColor * progressColor;
@property (nonatomic,strong) UIImageView * shadowImageView;
@property (nonatomic,strong) UIBezierPath * path;
@property (nonatomic,strong) UIButton * skipButton;
@property (nonatomic,assign) CGFloat pathWidth;
@property (nonatomic,assign) CGFloat lineWidth;
@property (nonatomic,assign) NSInteger duration;
@end
@implementation TimeCircleView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configTimeCircleViewUI];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self configTimeCircleViewUI];
}
- (void)configTimeCircleViewUI{
    self.trackColor = [UIColor blackColor];
    self.progressColor = [UIColor redColor];
    self.pathWidth = self.bounds.size.width / 1.15;
    [self addSubview:self.shadowImageView];
    [self addSubview:self.skipButton];
    [self.layer addSublayer:self.trackLayer];
    [self.layer addSublayer:self.gradientLayer];
}
- (void)startAnimationWithDuration:(CGFloat)duration{
    [self.progressLayer removeAllAnimations];
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    animation.duration = duration;
    animation.removedOnCompletion = YES;
    animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    self.progressLayer.strokeEnd = 1.0;
    [self.progressLayer addAnimation:animation forKey:@"strokeEndAnimation"];
}
#pragma mark --- CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim{
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
}
#pragma mark --- setter getter
- (UIBezierPath *)path{
    if (_path == nil) {
        CGFloat halfWidth = self.pathWidth / 2.0;
        _path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(halfWidth, halfWidth) radius:(self.pathWidth - self.lineWidth)/2 startAngle:-M_PI/2*3 endAngle:M_PI/2 clockwise:YES];
    }
    return _path;
}
- (CGFloat)lineWidth{
    if (_lineWidth == 0) {
        _lineWidth = 2.5;
    }
    return _lineWidth;
}
- (UIImageView *)shadowImageView{
    if (_shadowImageView == nil) {
        _shadowImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _shadowImageView.image = [UIImage imageNamed:@"shadow"];
    }
    return _shadowImageView;
}
- (CAShapeLayer *)trackLayer{
    if (_trackLayer == nil) {
        _trackLayer = [CAShapeLayer layer];
        [self configLayer:_trackLayer color:self.trackColor];
    }
    return _trackLayer;
}
- (CAShapeLayer *)progressLayer{
    if (_progressLayer == nil) {
        _progressLayer = [CAShapeLayer layer];
        [self configLayer:_progressLayer color:self.progressColor];
        _progressLayer.strokeEnd = 0;
    }
    return _progressLayer;
}
- (CAGradientLayer *)gradientLayer{
    if (_gradientLayer == nil) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.colors = @[(id)[UIColor cyanColor].CGColor,
                                  (id)[UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000].CGColor];
        [_gradientLayer setStartPoint:CGPointMake(0.5, 1.0)];
        [_gradientLayer setEndPoint:CGPointMake(0.5, 0.0)];
        [_gradientLayer setMask:self.progressLayer];
    }
    return _gradientLayer;
}
- (void)configLayer:(CAShapeLayer *)layer color:(UIColor *)color{
    CGFloat layerWidth = self.pathWidth;
    CGFloat layerX = (self.bounds.size.width - layerWidth)/2;
    layer.frame = CGRectMake(layerX, layerX, layerWidth, layerWidth);
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = color.CGColor;
    layer.lineCap = kCALineCapButt;
    layer.lineWidth = self.lineWidth;
    layer.path = self.path.CGPath;
}
- (UIButton *)skipButton{
    if (_skipButton == nil) {
        _skipButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _skipButton.frame = self.bounds;
        [_skipButton setTitle:@"跳过" forState:UIControlStateNormal];
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_skipButton addTarget:self action:@selector(skipButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipButton;
}
- (void)skipButtonClicked:(UIButton *)sender{
    if ([self.circleDelegate conformsToProtocol:@protocol(timeCircleClick)] && [self.circleDelegate respondsToSelector:@selector(timeCircleButtonClick:)]) {
        [self.circleDelegate timeCircleButtonClick:self];
    }
}
@end
