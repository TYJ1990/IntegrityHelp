//
//  QQNavigationController.m
//  Customer
//
//  Created by 秦慕乔 on 16/5/16.
//  Copyright © 2016年 秦慕乔. All rights reserved.
//

#import "XFNavigationController.h"

@interface XFNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation XFNavigationController

+ (void)initialize{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加系统自带的手势返回
    self.delegate = self;
    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    //设置透明度  相差64像素
    self.navigationBar.translucent = YES;
    //设置颜色
//    self.navigationBar.barTintColor = NAVBGCOLOR;
    //处理ScrollViewInsets的自动下沉
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:NAVBTEXTGCOLOR, NSForegroundColorAttributeName, [UIFont systemFontOfSize:16.0f weight:UIFontWeightBold], NSFontAttributeName, nil]];

    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //如应用中出现seachbar的跳动，视图位置出现问题，有可能是这里引起的
        self.edgesForExtendedLayout = UIRectEdgeNone;//视图控制器，四条边不指定 设置了UIRectEdgeNone之后，你嵌在UIViewController里面的UITableView和UIScrollView就不会穿过UINavigationBar了
        self.extendedLayoutIncludesOpaqueBars = YES;//不透明的操作栏
        
        self.modalPresentationCapturesStatusBarAppearance = NO;
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@""]
                                          forBarPosition:UIBarPositionTop
                                              barMetrics:UIBarMetricsCompact];
        //设置navi透明需要translucent = yes,设置图片，barMetrics（更改类型的道不同的效果）
    }
    else
    {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@""]
                                 forBarMetrics:UIBarMetricsDefault];
    }
    
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //防止在push的过程中触发返回的时间导致崩溃
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if (self.childViewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"Arrow_back"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"Arrow_back"] forState:UIControlStateHighlighted];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        button.bounds = CGRectMake(0, 0, 70, 30);
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    [super pushViewController:viewController animated:animated];
}
- (void)back
{
    [self popViewControllerAnimated:YES];
}
//推送的视图将要出现时将侧滑返回设置为真
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if (navigationController.viewControllers.count == 1){
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    }else{
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
// 为了解决与scroll的手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]
        && [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
    {
        //        [_scrollView.panGestureRecognizer requireGestureRecognizerToFail:screenEdgePanGestureRecognizer];
        return YES;
    }
    else
    {
        return  NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
