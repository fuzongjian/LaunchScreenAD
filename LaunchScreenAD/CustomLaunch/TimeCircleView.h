//
//  TimeCircleView.h
//  timeCircle
//
//  Created by Shao Jie on 16/7/6.
//  Copyright © 2016年 yourangroup. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol timeCircleClick;
@interface TimeCircleView : UIView
@property (nonatomic,assign) id<timeCircleClick>circleDelegate;
- (void)startAnimationWithDuration:(CGFloat)duration;
@end
@protocol timeCircleClick <NSObject>
- (void)timeCircleButtonClick:(TimeCircleView *)timeCircleView;
@end