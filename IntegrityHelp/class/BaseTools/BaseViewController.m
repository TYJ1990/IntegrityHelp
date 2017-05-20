//
//  BaseViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/25.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhite;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
}


/// 返回按钮
///
/// - Parameter title: 返回按钮文字

- (void)initNav:(NSString *)title{
    self.title = title;
    self.navigationController.navigationBar.barTintColor = kMainColor;
    self.navigationController.navigationBar.backgroundColor = kMainColor;
    UIImage *img = [UIImage imageNamed:@"back_white"];
    img = [img imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:img style:(UIBarButtonItemStyleDone) target:self action:@selector(leftImgAction)];
}


/// 返回按钮
///
/// - Parameters:
///   - title: 返回按钮文字
///   - color: 文字颜色
///   - imgName: 图片
- (void)initNav:(NSString *)title color:(UIColor *)color imgName:(NSString *)imgName{
    self.title = title;
    self.navigationController.navigationBar.barTintColor = color;
    self.navigationController.navigationBar.backgroundColor = color;
    UIImage *img = [UIImage imageNamed:imgName];
    img = [img imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:img style:(UIBarButtonItemStyleDone) target:self action:@selector(leftImgAction)];
}


// MARK: showBackImg - 返回按钮 (图片格式)
- (void)leftImg:(NSString *)imgName{
    UIImage *img = [UIImage imageNamed:imgName];
    img = [img imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:img style:(UIBarButtonItemStyleDone) target:self action:@selector(leftImgAction)];
}


/// 返回事件
- (void)leftImgAction{
    [self.navigationController popViewControllerAnimated:YES];
}


/// 导航栏右边的文字按钮
///
/// - Parameter title: 按钮文字
- (void)rightTitle:(NSString *)title{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:(UIBarButtonItemStyleDone) target:self action:@selector(rightAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kBlack,NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
}


/// 导航栏右边的图片按钮
///
/// - Parameter imgName: 图片名称
- (void)rightImage:(NSString *)imgName{
    UIImage *img = [UIImage imageNamed:imgName];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[img imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStyleDone) target:self action:@selector(rightAction)];
    self.navigationItem.rightBarButtonItem = item;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kBlack,NSForegroundColorAttributeName,[UIFont systemFontOfSize:16],NSFontAttributeName, nil] forState:UIControlStateNormal];
}


 /// 右边按钮执行事件
- (void)rightAction{
    NSLog(@"这里是右边文字按钮或者图片按钮…………");
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}


- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}


@end
