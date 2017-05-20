//
//  LineStoreViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/26.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "LineStoreViewController.h"

@interface LineStoreViewController ()

@end

@implementation LineStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = kMainColor;
    self.navigationController.navigationBar.backgroundColor = kMainColor;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kWhite,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
    
    UIImage *img = [[UIImage imageNamed:@"back_white"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:img style:(UIBarButtonItemStyleDone) target:self action:@selector(leftImgAction)];
}


- (void)leftImgAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
