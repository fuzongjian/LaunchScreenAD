//
//  DisplayWebViewController.h
//  LaunchScreenAD
//
//  Created by Shao Jie on 16/7/6.
//  Copyright © 2016年 yourangroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisplayWebViewController : UIViewController

@end

@interface UIViewController (RootViewController)
// 取到该控制器的UINavigationController
- (UINavigationController *)getRootViewController;
@end