//
//  HelperSearchResultViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/4.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "HelperSearchResultViewController.h"
#import "HelperModel.h"
#import "HelperSearchListTableViewCell.h"
#import "HelperDetailViewController.h"
#import "HelperTableViewCell.h"


@interface HelperSearchResultViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;

@end

@implementation HelperSearchResultViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavi];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
}


- (void)initNavi{
    [self initNav:@"帮扶大厅" color:kMainColor imgName:@"back_white"];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kWhite,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
}




- (void)setUI{
    [self.view addSubview:({
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 64) style:(UITableViewStyleGrouped)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.rowHeight = 133;
        [_tableview registerNib:[UINib nibWithNibName:@"HelperTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
        _tableview;
    })];
}






- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _model.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HelperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell cellConfigureModel:_model.data[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HelperDetailViewController *detailVC = [[HelperDetailViewController alloc] init];
    detailVC.titleStr = [_model.data[indexPath.row] Title];
    detailVC.ID = [_model.data[indexPath.row] Id];
    [self.navigationController pushViewController:detailVC animated:YES];
}


@end
