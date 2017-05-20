//
//  OwnerHistorySignViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/12.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "OwnerHistorySignViewController.h"
#import "OwnerHistoryModel.h"
#import "OwnerHistoryTableViewCell.h"

@interface OwnerHistorySignViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableview;
@property(nonatomic,strong) OwnerHistoryModel *historyModel;

@end

@implementation OwnerHistorySignViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavi];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self downloadData];
}


-(void)setNavi{
    [self initNav:@"历史签名" color:kWhite imgName:@"back_black"];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kDarkText,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
}



- (void)setUI{
    [self.view addSubview:({
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 64) style:(UITableViewStylePlain)];
        _tableview.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:@"OwnerHistoryTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
        _tableview;
    })];
    
    UIView *view;
    [self.view addSubview:({
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 70)];
        view.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
        view;
    })];
    
    UIImageView *headView;
    [view addSubview:({
        headView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 50, 50)];
        [headView sd_setImageWithURL:[NSURL URLWithString:imageUrl([Utils getValueForKey:@"icon"])]];
        headView.layer.masksToBounds = YES;
        headView.layer.cornerRadius = 25;
        headView;
    })];
    
    [view addSubview:({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 150, 20)];
        label.text = [Utils getValueForKey:@"name"];
        label;
    })];
    _tableview.tableHeaderView = view;
}

- (void)downloadData{
    [self.view loadingOnAnyView];
    [HYBNetworking getWithUrl:@"IosIndex/myContentList" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"]} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            _historyModel = [[OwnerHistoryModel alloc] initWithDictionary:response error:&error];
            if (!error) {
                [_tableview reloadData];
            }
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}




- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _historyModel.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OwnerHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell cellConfigureModel:_historyModel.data[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [TXUtilsString AutoHeight:[_historyModel.data[indexPath.row] Content] font:14.0 andCGsize:CGSizeMake(ScreenW - 160, 1000)];
    
    return  height + 75;
}

@end
