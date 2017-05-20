//
//  SearchStoreViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/26.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "SearchStoreViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface SearchStoreViewController ()<UISearchBarDelegate>

@end

@implementation SearchStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initGaodeMap];
}



- (void)initNav{
    
//    [self.navigationItem setTitleView:({
//        UISearchBar *searchBar = [[UISearchBar alloc] init];
//        searchBar.placeholder = @"搜索";
//        searchBar.delegate = self;
//        searchBar.searchBarStyle = UISearchBarStyleMinimal;
//        searchBar;
//    })];
    
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kWhite,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = kMainColor;
    self.navigationController.navigationBar.backgroundColor = kMainColor;
    
//    UIImage *img = [[UIImage imageNamed:@"back_white"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:img style:(UIBarButtonItemStyleDone) target:self action:@selector(leftImgAction)];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
//        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        [btn setImage:[UIImage imageNamed:@"rightPlus"] forState:(UIControlStateNormal)];
//        btn.titleLabel.font = kBlodFont(24.0f);
//        btn.frame = CGRectMake(0, 0, 30, 30);
//        [btn addTarget:self action:@selector(btnMoreAction) forControlEvents:(UIControlEventTouchUpInside)];
//        btn;
//    })];
}

- (void)leftImgAction{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"returnOwner" object:nil];
    }];
}

- (void)btnMoreAction{
    
}



- (void)initGaodeMap{
    [self.view addSubview:({
        MAMapView *mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        [AMapServices sharedServices].enableHTTPS = YES;
        mapView.showsUserLocation = YES;
        mapView.userTrackingMode = MAUserTrackingModeFollow;
        [mapView setZoomLevel:17.1 animated:YES];
        mapView;
    })];
}











@end
