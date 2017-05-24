//
//  OwnerSearchMemberViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/13.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "OwnerSearchMemberViewController.h"
#import "OwnerPointModel.h"
#import "OwnerPointTableViewCell.h"


@interface OwnerSearchMemberViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy) UITableView *tableview;
@property(nonatomic,strong) OwnerPointModel *pointModel;

@end

@implementation OwnerSearchMemberViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavi];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}


- (void)setNavi{
    [self.navigationItem setTitleView:({
        UISearchBar *searchBar = [[UISearchBar alloc] init];
        searchBar.placeholder = @"搜索行业/人名";
        searchBar.delegate = self;
        searchBar.searchBarStyle = UISearchBarStyleMinimal;
        searchBar;
    })];
    
    [self leftImg:@"back_black"];
}



- (void)setUI{
    [self.view addSubview:({
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 64) style:(UITableViewStylePlain)];
        _tableview.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.rowHeight = 55;
        [_tableview registerNib:[UINib nibWithNibName:@"OwnerPointTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
        _tableview.tableFooterView = [UIView new];
        _tableview;
    })];
}



- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _pointModel.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OwnerPointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell cellConfigureModel:_pointModel.data[indexPath.row] index:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self.view loadingOnAnyView];
    [HYBNetworking getWithUrl:@"IosIndex/pointList" refreshCache:NO params:@{@"keywords":searchBar.text} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            _pointModel = [[OwnerPointModel alloc] initWithDictionary:response error:&error];
            if (!error) {
                [_tableview reloadData];
            }
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}


@end
