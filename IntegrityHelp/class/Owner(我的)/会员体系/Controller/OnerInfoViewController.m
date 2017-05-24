//
//  OnerInfoViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/17.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "OnerInfoViewController.h"
#import "MemberInfoModel.h"

@interface OnerInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableview;
@property(nonatomic,strong) NSArray *titleArray;
@property(nonatomic,strong) MemberInfoModel *memberModel;
@property(nonatomic,strong) UIImageView *icon;
@property(nonatomic,strong) UILabel *name;
@property(nonatomic,strong) UILabel *phone;
@property(nonatomic,strong) UIView *bottomView;

@end

@implementation OnerInfoViewController

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
    [self initNav:@"详细信息" color:kWhite imgName:@"back_black"];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kDarkText,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
}



-(void)setUI{
    [self.view addSubview:({
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 64) style:(UITableViewStyleGrouped)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview;
    })];
    
    UIView *view;
    [_tableview setTableHeaderView:({
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 150)];
        view.backgroundColor = kMainColor;
        view;
    })];
    
    [view addSubview:({
        _icon = [[UIImageView alloc] init];
        _icon.layer.cornerRadius = 30;
        _icon.layer.masksToBounds = YES;
        _icon;
    })];
    
    [view addSubview:({
        _name = [[UILabel alloc] init];
        _name.font = kFont(17);
        _name.textColor = kWhite;
        _name;
    })];
    
    [view addSubview:({
        _phone = [[UILabel alloc] init];
        _phone.font = kFont(13);
        _phone.textColor = kWhite;
        _phone;
    })];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.top.mas_equalTo(view.mas_top).with.offset(15.0f);
        make.height.width.mas_equalTo(60.0f);
    }];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.top.mas_equalTo(_icon.mas_bottom).with.offset(10.0f);
    }];
    
    [_phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.top.mas_equalTo(_name.mas_bottom).with.offset(5.0f);
    }];
    
    _titleArray = @[@"真实姓名",@"出生年月",@"邮箱地址",@"所在行业",@"岗位",@"当前年薪",@"注册时间"];
    
    [self.view addSubview:({
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - 60 - 64, ScreenW, 60)];
        _bottomView.backgroundColor = [[UIColor colorWithHex:0xf2f2f2] colorWithAlphaComponent:0.85];
        _bottomView;
    })];
    
    [_bottomView addSubview:({
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
        line.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
        line;
    })];
    
    [_bottomView addSubview:({
        UIButton *sendMessegeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        sendMessegeBtn.frame = CGRectMake(ScreenW/2 + 7.5, 10, (ScreenW-45)/2, 40);
        sendMessegeBtn.layer.cornerRadius = 3;
        sendMessegeBtn.layer.masksToBounds = YES;
        sendMessegeBtn.backgroundColor = kMainColor;
        [sendMessegeBtn setTitle:@"发消息" forState:(UIControlStateNormal)];
        [sendMessegeBtn setTitleColor:kWhite forState:(UIControlStateNormal)];
        sendMessegeBtn.titleLabel.font = kFont(15);
        sendMessegeBtn;
    })];
    
    [_bottomView addSubview:({
        UIButton *detailBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        detailBtn.frame = CGRectMake(15, 10, (ScreenW-45)/2, 40);
        detailBtn.layer.cornerRadius = 3;
        detailBtn.layer.masksToBounds = YES;
        detailBtn.backgroundColor = kWhite;
        detailBtn.layer.borderColor = [UIColor colorWithHex:0xdfdfdf].CGColor;
        detailBtn.layer.borderWidth = 1;
        [detailBtn setTitle:@"查看帮扶历史" forState:(UIControlStateNormal)];
        [detailBtn setTitleColor:kDarkText forState:(UIControlStateNormal)];
        detailBtn.titleLabel.font = kFont(15);
        detailBtn;
    })];
}


- (void)downloadData{
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosIndex/otherMemberInfo" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"],@"u_pwd":[Utils getValueForKey:@"pwdMd5"],@"o_id":_oid} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            _memberModel = [[MemberInfoModel alloc] initWithDictionary:response[@"data"] error:&error];
            if (!error) {
                [_icon sd_setImageWithURL:[NSURL URLWithString:imageUrl(_memberModel.face)] placeholderImage:[UIImage imageNamed:@"placeholder_person"]];
                _name.text = _memberModel.name;
                _phone.text = _memberModel.Tel;
                [_tableview reloadData];
            }
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}




//delegate
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return 3;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"CELL"];
    }
    cell.textLabel.textColor = kDarkText;
    cell.detailTextLabel.textColor = kLightGray;
    cell.textLabel.font = kFont(16);
    cell.detailTextLabel.font = kFont(16);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger index = indexPath.section * 3 + indexPath.row;
    switch (index) {
        case 0:
            cell.detailTextLabel.text = _memberModel.name;
            cell.textLabel.text = _titleArray[0];
            break;
        case 1:{
            cell.textLabel.text = _titleArray[1];
            if (_memberModel.Borntime) {
                cell.detailTextLabel.text = [Utils TransformTimestampWith:_memberModel.Borntime dateDormate:@"yyyy-MM-dd"];
            }else{
                cell.detailTextLabel.text = @"";
            }
        }
            break;
        case 3:{
            cell.textLabel.text = _titleArray[2];
            cell.detailTextLabel.text = _memberModel.Email;
        }
            break;
        case 6:{
            cell.textLabel.text = _titleArray[3];
            cell.detailTextLabel.text = _memberModel.job_name;
        }
            break;
        case 7:{
            cell.textLabel.text = _titleArray[4];
            cell.detailTextLabel.text = _memberModel.Vocation;
        }
            break;
        case 8:{
            cell.textLabel.text = _titleArray[5];
            cell.detailTextLabel.text = _memberModel.yearpay_name;
        }
            break;
        case 9:{
            cell.textLabel.text = _titleArray[6];
            cell.detailTextLabel.text = [Utils TransformTimestampWith:_memberModel.Updatetime dateDormate:@"yyyy-MM-dd"];;
            cell.detailTextLabel.textColor = kMainColor;
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}



@end
