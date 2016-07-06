//
//  DisplayWebViewController.m
//  LaunchScreenAD
//
//  Created by Shao Jie on 16/7/6.
//  Copyright © 2016年 yourangroup. All rights reserved.
//

#import "DisplayWebViewController.h"

@interface DisplayWebViewController ()

@end

@implementation DisplayWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"广告展示";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    [self.view addSubview:webView];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
@implementation UIViewController (RootViewController)
- (UINavigationController *)getRootViewController{
    UINavigationController * Nav = nil;
    if ([self isKindOfClass:[UINavigationController class]]) {
        Nav = (id)self;
    }else if ([self isKindOfClass:[UITabBarController class]]){
        Nav = [((UITabBarController *)self).selectedViewController getRootViewController];
    }else{
        Nav = self.navigationController;
    }
    return Nav;
}
@end




