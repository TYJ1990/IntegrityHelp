//
//  FundCardViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/18.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "FundCardViewController.h"
#import "FundCardTableViewCell.h"
#import "FundCardModel.h"

@interface FundCardViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong) FundCardModel *cardModel;
@property(nonatomic,strong) UIView *footView;
@property(nonatomic,strong) UIButton *submitBtn;
@property(nonatomic,strong) NSString *bankID;

@end

@implementation FundCardViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initnavi];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self downloadData];
}


- (void)initnavi{
    [self initNav:@"下一步" color:[UIColor whiteColor] imgName:@"back_black"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kDarkText,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
}

- (void)setUI{
    [self.view addSubview:({
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 64) style:(UITableViewStyleGrouped)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.rowHeight = 60;
        [_tableview registerNib:[UINib nibWithNibName:@"FundCardTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
        _tableview;
    })];
    
    [_tableview setTableFooterView:({
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
        _footView.backgroundColor = kMainGray;
        _footView;
    })];
    
    [_footView addSubview:({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenW - 30, 50)];
        label.textColor = kLightGray;
        label.font = kFont(12);
        label.numberOfLines = 0;
        label.text = @"目前支持：网商银行、工行、招行、建行、中行、农行、交行、浦发、广发、中信、广大、兴业、民生、平安、杭州银行、邮政银行。";
        label;
    })];
    
    [_footView addSubview:({
        _submitBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _submitBtn.backgroundColor = kGrayBtn;
        _submitBtn.enabled = NO;
        [_submitBtn setTitle:@"提交审核" forState:(UIControlStateNormal)];
        [_submitBtn setTitleColor:kWhite forState:(UIControlStateNormal)];
        [_submitBtn addTarget:self action:@selector(submit) forControlEvents:(UIControlEventTouchUpInside)];
        _submitBtn.frame = CGRectMake(15, 70, ScreenW - 30, 50);
        _submitBtn.layer.cornerRadius = 5;
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn;
    })];
}

- (void)downloadData{
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosBorrow/userCard" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"],@"u_pwd":[Utils getValueForKey:@"pwdMd5"]} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            _cardModel = [[FundCardModel alloc] initWithDictionary:response error:&error];
            if (!error) {
                [_tableview reloadData];
            }
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}

- (void)submit{
    [_dic setValue:_bankID forKey:@"bank_id"];
    
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosBorrow/create" refreshCache:NO params:_dic success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];

}



//delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _cardModel.data.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        FundCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.icon.layer.cornerRadius = 20;
        cell.icon.layer.masksToBounds = YES;
        cell.icon.image = [UIImage imageNamed:@"placeholder_person"];
        cell.cardName.text = [_cardModel.data[indexPath.row] Name];
        NSString *card_number = [_cardModel.data[indexPath.row] Card_no];
        cell.cardNumber.text = [NSString stringWithFormat:@"尾号%@",[card_number substringFromIndex:card_number.length - 4]];
        if ([_cardModel.data[indexPath.row] isSelect]) {
            cell.selectFlag.hidden = NO;
        }else{
            cell.selectFlag.hidden = YES;
        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bottomCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"bottomCell"];
        }
        cell.textLabel.text = @"添加储蓄卡";
        cell.textLabel.font = kFont(16);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FundCardTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectFlag.hidden = NO;
    _bankID = [_cardModel.data[indexPath.row] Id];
    _submitBtn.backgroundColor = kMainColor;
    _submitBtn.enabled = YES;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    FundCardTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectFlag.hidden = YES;
}

@end
