//
//  OwnerIntegralViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/27.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "OwnerIntegralViewController.h"
#import "IntegralView.h"
#import "OwnerPointModel.h"
#import "OwnerPointTableViewCell.h"
#import "OwnerSearchMemberViewController.h"


@interface OwnerIntegralViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)IntegralView *integralView;
@property(nonatomic,copy) UITableView *tableView;
@property(nonatomic,strong) OwnerPointModel *pointModel;


@end

@implementation OwnerIntegralViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initnavi];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self loadDataList];
    [self loadData];
}


- (void)initnavi{
    [self initNav:@"积分排行" color:[UIColor whiteColor] imgName:@"back_black"];
    [self rightTitle:@"搜索"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kDarkText,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kDarkText,NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:(UIControlStateNormal)];
}

- (void)rightAction{
    OwnerSearchMemberViewController *searchVC = [[OwnerSearchMemberViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}


- (void)setUI{
    [self.view addSubview:({
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 64) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 55;
        [_tableView registerNib:[UINib nibWithNibName:@"OwnerPointTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
        _tableView;
    })];
    
    [_tableView setTableHeaderView:({
        _integralView = [[[NSBundle mainBundle] loadNibNamed:@"IntegralView" owner:nil options:nil] firstObject];
        _integralView.frame = CGRectMake(0, 0, ScreenW, 385);
        _integralView.icon.image = _icon;
        _integralView.username.text = _name;
        _integralView;
    })];
}

- (void)loadDataList{
    [self.view loadingOnAnyView];
    [HYBNetworking getWithUrl:@"IosIndex/pointList" refreshCache:NO params:nil success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            _pointModel = [[OwnerPointModel alloc] initWithDictionary:response error:&error];
            if (!error) {
                [_tableView reloadData];
            }
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}


- (void)loadData{
    [self.view loadingOnAnyView];
    [HYBNetworking getWithUrl:@"IosIndex/myPoint" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"]} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            _integralView.rankingLabel.text = [NSString stringWithFormat:@"第%@名",response[@"data"][@"ming"]];
            _integralView.totalSorce.text = [NSString stringWithFormat:@"%@",response[@"data"][@"zong"]];
            NSMutableArray *nameArr = [NSMutableArray array];
            NSMutableArray *valueArr = [NSMutableArray array];
            for (int i = 1; i < 8; i ++) {
                NSString *key = [NSString stringWithFormat:@"a%d",i];
                NSString *name = response[@"data"][key][@"name"];
                [nameArr addObject:name.length > 0 ? name : @""];
                [valueArr addObject:[response[@"data"][key][@"num"] boolValue] ? response[@"data"][key][@"num"] : @0];
            }
            [_integralView getChartsWithValueArray:valueArr nameArray:nameArr];
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _pointModel.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OwnerPointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell cellConfigureModel:_pointModel.data[indexPath.row] index:indexPath.row];
    [cell.support addTarget:self action:@selector(supportMe:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.support.tag = indexPath.row + 100;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 55)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:({
        UIView *gray = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 8)];
        gray.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
        gray;
    })];
    
    [view addSubview:({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 15, 60, 25)];
        label.text = @"排行榜";
        label.textAlignment = NSTextAlignmentLeft;
        label;
    })];
    
//    [view addSubview:({
//        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 15, ScreenW - 105, 30)];
//        textField.placeholder = @"   搜索行业/人名";
//        textField.font = kFont(15);
//        textField.layer.cornerRadius = 5;
//        textField.layer.masksToBounds = YES;
//        textField.borderStyle = UITextBorderStyleNone;
//        textField.layer.borderColor = [UIColor colorWithHex:0xdfdfdf].CGColor;
//        textField.layer.borderWidth = 0.5;
//        textField.delegate = self;
//        textField;
//    })];
    
    [view addSubview:({
        UIView *gray = [[UIView alloc] initWithFrame:CGRectMake(0, 54, ScreenW, 1)];
        gray.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
        gray;
    })];
    return view;
}



- (void)supportMe:(UIButton *)btn{
    
    [self.view Message:@"关注成功" HiddenAfterDelay:1];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return NO;
}




@end
