//
//  OwnerBossViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/17.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "OwnerBossViewController.h"
#import "MemberSystem.h"
#import "BossTableViewCell.h"
#import "OnerInfoViewController.h"

@interface OwnerBossViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) MemberSystem *memberSystemModel;
@property(nonatomic,copy) UITableView *tableView;

@end

@implementation OwnerBossViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initnavi];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self downloadDataFromServer];
}

- (void)initnavi{
    [self initNav:@"会员体系" color:kMainColor imgName:@"back_white"];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kWhite,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
}


- (void)setUI{
    [self.view addSubview:({
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 64) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"BossTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
        _tableView;
    })];
}


- (void)downloadDataFromServer{
    [self.view loadingOnAnyView];
    [HYBNetworking getWithUrl:@"IosIndex/memberTree" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"]} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            _memberSystemModel = [[MemberSystem alloc] initWithDictionary:response error:&error];
            if (!error) {
                [_tableView reloadData];
            }
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _memberSystemModel.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_memberSystemModel.data[section] son].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BossTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:imageUrl3([[_memberSystemModel.data[indexPath.section] son][indexPath.row] Face])] placeholderImage:[UIImage imageNamed:@"placeholder_person"]];
    cell.name.text = [[_memberSystemModel.data[indexPath.section] son][indexPath.row] Name];
    cell.icon.layer.cornerRadius = 15;
    cell.icon.layer.masksToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    [view addSubview:({
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 40, 40)];
        img.layer.cornerRadius = 20;
        img.layer.masksToBounds = YES;
        [img sd_setImageWithURL:[NSURL URLWithString:imageUrl3([_memberSystemModel.data[section] Face])] placeholderImage:[UIImage imageNamed:@"placeholder_person"]];
        img;
    })];
    
    [view addSubview:({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(65, 15, 80, 20)];
        label.text = [_memberSystemModel.data[section] Name];
        label.font = kFont(15);
        label.textColor = kDarkGray;
        label;
    })];
    
    [view addSubview:({
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, ScreenW, 1)];
        line.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
        line;
    })];
    
    [view addSubview:({
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn addTarget:self action:@selector(clickSection:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.frame = CGRectMake(0, 0, ScreenW, 50);
        btn.tag = section + 100;
        btn;
    })];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OnerInfoViewController *infoVC = [[OnerInfoViewController alloc] init];
    infoVC.oid = [[_memberSystemModel.data[indexPath.section] son][indexPath.row] Id];
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (void)clickSection:(UIButton *)btn{
    OnerInfoViewController *infoVC = [[OnerInfoViewController alloc] init];
    infoVC.oid = [_memberSystemModel.data[btn.tag - 100] Id];
    [self.navigationController pushViewController:infoVC animated:YES];
}


@end
