//
//  OwnerPropetyViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/22.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "OwnerPropetyViewController.h"
#import "IntegralView.h"


@interface OwnerPropetyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy) UITableView *tableView;
@property (nonatomic,strong)IntegralView *integralView;

@end

@implementation OwnerPropetyViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initnavi];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
//    [self loadDataList];
//    [self loadData];
}


- (void)initnavi{
    [self initNav:@"我的资产" color:[UIColor whiteColor] imgName:@"back_black"];
//    [self rightTitle:@"搜索"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kDarkText,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
}



- (void)setUI{
    [self.view addSubview:({
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 64) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 55;
        _tableView.tableFooterView = [UIView new];
        _tableView;
    })];
    
    [_tableView setTableHeaderView:({
        _integralView = [[[NSBundle mainBundle] loadNibNamed:@"IntegralView" owner:nil options:nil] firstObject];
        _integralView.frame = CGRectMake(0, 0, ScreenW, 385);
        _integralView.icon.image = _icon;
        _integralView.username.text = _name;
        _integralView.rankingLabel.hidden = YES;
        _integralView;
    })];
    [_integralView getChartsWithPropetyValueArray:@[@"12",@"21",@"32",@"12"] nameArray:@[@"资产状况",@"我的捐款",@"我的借款",@"我的银行卡"]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
@end
