//
//  ShopingMallTableBarViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/26.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "ShopingMallTableBarViewController.h"
#import "XFNavigationController.h"

@interface ShopingMallTableBarViewController ()

@end

@implementation ShopingMallTableBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTabBarVC];
}


- (void)initTabBarVC{
    UIColor *titleHighlightedColor = RGB(79, 141, 238);
    UIColor *titleNormalColor = [UIColor colorWithHex:0x313131 alpha:1.0f];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, UITextAttributeTextColor,
                                                       nil] forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor grayColor], UITextAttributeTextColor, [UIFont systemFontOfSize:11.0f weight:UIFontWeightBold], UITextAttributeFont,
                                                       nil] forState:UIControlStateNormal];
    //FIXME: 需要写死在list文件中
    NSArray *dataArr = @[@"找店铺",@"免费开店",@"线上商城",@"帮助"];
    NSArray *ClassArr = @[@"SearchStore",@"OpenStore",@"LineStore",@"StoreHelper"];
    
    for (int i = 0; i<4; i++) {
        NSString *className = [NSString stringWithFormat:@"%@ViewController", ClassArr[i]];
        Class class = NSClassFromString(className);
        UIViewController *uv = [[class alloc]init];
        XFNavigationController *nav = [[XFNavigationController alloc]initWithRootViewController:uv];
        uv.navigationItem.title = dataArr[i];
        
        NSString *path = [NSString stringWithFormat:@"%@",ClassArr[i]];
        NSString *path1 =[NSString stringWithFormat:@"%@_selected",ClassArr[i]];
        
        UIImage *image1 = [UIImage imageNamed:path1];
        image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *image = [UIImage imageNamed:path];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:dataArr[i] image:image selectedImage:image1];
        nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 0);
        [self addChildViewController:nav];
    }

}

@end
