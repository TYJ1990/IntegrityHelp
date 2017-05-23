//
//  HelperServiceViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/25.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "HelperServiceViewController.h"
#import "SDCycleScrollView.h"
#import "HelperTableViewCell.h"
#import "HelperModel.h"
#import "HelperPruductViewController.h"
#import "HelperSearchViewController.h"
#import "HelperDetailViewController.h"
#import "CompleteMemberView.h"
#import "MemberViewController.h"

@interface HelperServiceViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy) UITableView *tableView;
@property(nonatomic,strong) HelperModel *helperModel;
@property(nonatomic,strong) NSMutableArray *imagesURLStrings;
@property(nonatomic,strong) CompleteMemberView *completeView;
@property(nonatomic,strong) UIView *grayView;
@property(nonatomic,assign) NSInteger pageNumber;

@end

@implementation HelperServiceViewController


- (void)viewWillAppear:(BOOL)animated{
    [self initNav];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent)];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self downloadData];
    [self downloadImg];
}

- (void)initNav{
    
    self.title = @"帮扶大厅";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = kMainColor;
    self.navigationController.navigationBar.backgroundColor = kMainColor;
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kWhite,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"help_search"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftImgAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"help_pruduct"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStyleDone) target:self action:@selector(rightAction)];
}


- (void)setUI{
    _pageNumber = 1;
    [self.view addSubview:({
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 133;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            _pageNumber = 1;
            [self downloadData];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _pageNumber ++;
            [self downloadData];
        }];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"HelperTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"helpCell"];
        _tableView;
    })];
    WS(weakSelf)
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(ScreenH * 0.25);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).with.offset(0);
    }];
}


- (void)leftImgAction{
    HelperSearchViewController *searchVC = [[HelperSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)rightAction{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"profile"]) {
        [self initCompleteView];
    }else{
        HelperPruductViewController *pruduVC = [[HelperPruductViewController alloc] init];
        pruduVC.hidesBottomBarWhenPushed = YES;
        WS(weakSelf);
        pruduVC.callBack = ^(){
            [weakSelf downloadData];
        };
        [self.navigationController pushViewController:pruduVC animated:YES];
    }
}

- (void)initCompleteView{
    [self.view addSubview:({
        _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _grayView.backgroundColor = [UIColor blackColor];
        _grayView.alpha = 0;
        _grayView;
    })];
    
    [self.view addSubview:({
        _completeView = [[[NSBundle mainBundle] loadNibNamed:@"CompleteMemberView" owner:nil options:nil] firstObject];
        _completeView.frame = CGRectMake(40, (ScreenH-315)/2 - ScreenH, ScreenW - 80, 315);
        [_completeView.close addTarget:self action:@selector(closeTip) forControlEvents:(UIControlEventTouchUpInside)];
        [_completeView.completeBtn addTarget:self action:@selector(pushToCenter) forControlEvents:(UIControlEventTouchUpInside)];
        _completeView;
    })];
    
    [UIView animateWithDuration:0.5 animations:^{
        _grayView.alpha = 0.6;
        _completeView.frame = CGRectMake(40, (ScreenH-415)/2, ScreenW - 80, 315);
    }];
}

- (void)closeTip{
    [UIView animateWithDuration:0.3 animations:^{
        _grayView.alpha = 0;
        _completeView.frame = CGRectMake(40, (ScreenH-315)/2 - ScreenH, ScreenW - 80, 315);
    } completion:^(BOOL finished) {
        [_grayView removeFromSuperview];
        [_completeView removeFromSuperview];
    }];
}

- (void)pushToCenter{
    MemberViewController *mmeberVC = [[MemberViewController alloc] init];
    mmeberVC.name = [Utils getValueForKey:@"name"];
    mmeberVC.icon = imageUrl([Utils getValueForKey:@"icon"]);
    mmeberVC.phone = [Utils getValueForKey:@"phone"];
    mmeberVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mmeberVC animated:YES];
    [_grayView removeFromSuperview];
    [_completeView removeFromSuperview];
}


- (void)downloadData{
    [self.view loadingOnAnyView];
    [HYBNetworking getWithUrl:@"IosProject/index" refreshCache:NO params:@{@"page":[NSNumber numberWithInteger:_pageNumber],@"pagesize":@10} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            if (_pageNumber == 1) {
                _helperModel = [[HelperModel alloc] initWithDictionary:response error:&error];
            }else{
                HelperModel *model = [[HelperModel alloc] initWithDictionary:response error:&error];
                if (model.data.count == 0) {
                    [self.view Message:@"没有更多数据了" HiddenAfterDelay:1];
                }
                [_helperModel.data addObjectsFromArray:model.data];
            }
            if (!error) {
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                [_tableView reloadData];
            }
        }
    } fail:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [self.view removeAnyView];
    }];
}


- (void)downloadImg{
    [self.view loadingOnAnyView];
    [HYBNetworking getWithUrl:@"IosProject/banner" refreshCache:NO params:nil success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            
            _imagesURLStrings = [NSMutableArray array];
            [_imagesURLStrings addObject:imageUrl(response[@"data"][@"App_picpath"])];
            [_imagesURLStrings addObject:imageUrl(response[@"data"][@"App_picpath2"])];
            [_imagesURLStrings addObject:imageUrl(response[@"data"][@"App_picpath3"])];
            SDCycleScrollView *cycleScrollView;
            [self.view addSubview:({
                cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenW, ScreenH * 0.25) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
                cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
                cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    cycleScrollView.imageURLStringsGroup = _imagesURLStrings;
                });
                cycleScrollView;
            })];
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}


#pragma mark tableviewDalegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _helperModel.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HelperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"helpCell" forIndexPath:indexPath];
    [cell cellConfigureModel:_helperModel.data[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HelperDetailViewController *detailVC = [[HelperDetailViewController alloc] init];
    detailVC.titleStr = [_helperModel.data[indexPath.row] Title];
    detailVC.ID = [_helperModel.data[indexPath.row] Id];
    [self.navigationController pushViewController:detailVC animated:YES];
}





- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
    [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}



@end
