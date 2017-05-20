//
//  ShoppingMallViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/25.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "ShoppingMallViewController.h"
#import "ShopingMallTableBarViewController.h"

@interface ShoppingMallViewController ()

@end

@implementation ShoppingMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    ShopingMallTableBarViewController *shopingTableBarVC = [[ShopingMallTableBarViewController alloc] init];
    [self presentViewController:shopingTableBarVC animated:NO completion:^{
        self.tabBarController.selectedIndex = 0;
    }];
}


@end
