//
//  OpenStoreViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/26.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "OpenStoreViewController.h"

@interface OpenStoreViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeight;
@property (weak, nonatomic) IBOutlet UIButton *iconBg;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

@end

@implementation OpenStoreViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNav];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _iconHeight.constant = ScreenW *0.3;
    _backgroundView.layer.cornerRadius = ScreenW *0.15;
    _backgroundView.layer.masksToBounds = YES;
    
    if (_flag) {
        _bottomHeight.constant = 0;
    }
}

- (void)initNav{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = RGB(21, 164, 173);
    self.navigationController.navigationBar.backgroundColor = RGB(21, 164, 173);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kWhite,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
    
    UIImage *img = [[UIImage imageNamed:@"back_white"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:img style:(UIBarButtonItemStyleDone) target:self action:@selector(leftImgAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"帮助" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kWhite,NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:(UIControlStateNormal)];
}


- (void)leftImgAction{
    if (_flag) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)rightAction{
    
}

@end
