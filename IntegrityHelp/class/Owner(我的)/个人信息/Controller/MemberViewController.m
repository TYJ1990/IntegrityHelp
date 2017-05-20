//
//  MemberViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/27.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "MemberViewController.h"
#import "HeaderInfoViewController.h"
#import "UpdataMemberInfoViewController.h"
#import "MemberInfoModel.h"
#import "ItemModel.h"

@interface MemberViewController ()<UITableViewDelegate ,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong) UITableView *tableview;
@property(nonatomic,strong) NSArray *titleArray;
@property (strong, nonatomic) UIPickerView *pickerView;
@property(nonatomic,strong) UIView *grayView;
@property(nonatomic,strong) NSIndexPath *indexPath;
@property(nonatomic,strong) MemberInfoModel *memberModel;
@property(nonatomic,strong) UIDatePicker *datePicker;
@property(nonatomic,strong) ItemModel *itemModel;
@property(nonatomic,strong) NSString *typeId;

@end



@implementation MemberViewController


- (void)viewWillAppear:(BOOL)animated{
    [self initnavi];
    [self downloadData];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
}


- (void)initnavi{
    [self initNav:@"个人信息" color:kWhite imgName:@"back_black"];
//    [self rightTitle:@"保存"];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kDarkText,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kDarkText,NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:(UIControlStateNormal)];
}


- (void)setUI{
    [self.view addSubview:({
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 64) style:(UITableViewStyleGrouped)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview;
    })];
    _titleArray = @[@"头像",@"姓名",@"出生年月",@"证件信息",@"联系方式",@"邮箱地址",@"所在行业",@"岗位",@"当前年薪",@"修改密码",@"注册时间"];
}



- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 3 ? 2 : 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && indexPath.section == 0) {
        return [self cellImgHead];
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"CELL"];
        }
        cell.textLabel.textColor = kDarkText;
        cell.detailTextLabel.textColor = kLightGray;
        cell.textLabel.font = kFont(16);
        cell.detailTextLabel.font = kFont(16);
        cell.textLabel.text = _titleArray[indexPath.section * 3 + indexPath.row];
        if ([cell.textLabel.text isEqualToString:@"出生年月"] || [cell.textLabel.text isEqualToString:@"所在行业"] || [cell.textLabel.text isEqualToString:@"邮箱地址"] || [cell.textLabel.text isEqualToString:@"岗位"] || [cell.textLabel.text isEqualToString:@"当前年薪"]) {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ *",cell.textLabel.text]];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(string.length -2, 2)];
            cell.textLabel.attributedText = string;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSInteger index = indexPath.section * 3 + indexPath.row;
        switch (index) {
            case 1:
                cell.detailTextLabel.text = _name;
                break;
            case 2:{
                if (_memberModel.Borntime) {
                    cell.detailTextLabel.text = [Utils TransformTimestampWith:_memberModel.Borntime dateDormate:@"yyyy年MM月dd日"];
                }else{
                    cell.detailTextLabel.text = @"未选择";
                }
            }
                break;
            case 3:{
                if (_memberModel.Idcard.length > 0) {
                    cell.detailTextLabel.text = _memberModel.Idcard;
                }else{
                    cell.detailTextLabel.text = @"未填写";
                }
            }
                break;
            case 4:
                cell.detailTextLabel.text = _phone;
                break;
            case 5:{
                if (_memberModel.Email) {
                    cell.detailTextLabel.text = _memberModel.Email;
                }else{
                    cell.detailTextLabel.text = @"未填写";
                }
            }
                break;
            case 6:{
                if (_memberModel.job_name) {
                    cell.detailTextLabel.text = _memberModel.job_name;
                }else{
                    cell.detailTextLabel.text = @"未选择";
                }
            }
                break;
            case 7:{
                if (_memberModel.Vocation) {
                    cell.detailTextLabel.text = _memberModel.Vocation;
                }else{
                    cell.detailTextLabel.text = @"未填写";
                }
            }
                break;
            case 8:{
                if (_memberModel.yearpay_name) {
                    cell.detailTextLabel.text = _memberModel.yearpay_name;
                }else{
                    cell.detailTextLabel.text = @"未选择";
                }
            }
                break;
            case 9:{
                cell.detailTextLabel.text = @"";
            }
                break;
            default:
                break;
        }
        
        if (indexPath.section == 3 && indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailTextLabel.textColor = kMainColor;
            cell.detailTextLabel.text = [Utils TransformTimestampWith:[Utils getValueForKey:@"u_regtime"] dateDormate:@"yyyy-MM-dd"];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (indexPath.section == 0 && indexPath.row == 0 ) ? 70 : 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imageV = [cell viewWithTag:199];
    if (indexPath.section == 0 && indexPath.row == 0) {
        HeaderInfoViewController *headVC = [[HeaderInfoViewController alloc] init];
        WS(weakSelf)
        headVC.callBack = ^(NSString *img){
            weakSelf.icon = img;
            [imageV sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"placeholder_person"]];
        };
        headVC.imageUrl = _icon;
        [self.navigationController pushViewController:headVC animated:YES];
    }else if(indexPath.section == 2 && indexPath.row != 1){
        _indexPath = indexPath;
        [self selectType];
    }else if(indexPath.section == 0 && indexPath.row == 2){
        _indexPath = indexPath;
        [self selectType];
    }
    else if((indexPath.section == 0 && indexPath.row == 1) || indexPath.section ==1 || (indexPath.section == 3 && indexPath.row == 0) || (indexPath.section == 2 && indexPath.row == 1)){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UpdataMemberInfoViewController *updataVC = [[UpdataMemberInfoViewController alloc] init];
        updataVC.content = [cell.detailTextLabel.text isEqualToString:@"未填写"] ? @"" : cell.detailTextLabel.text;
        updataVC.type = _titleArray[indexPath.section * 3 + indexPath.row];
        updataVC.callBack = ^(NSString *string){
            cell.detailTextLabel.text = string;
            if (indexPath.section == 0 && indexPath.row == 1) {
                [Utils setValue:string key:@"name"];
            }else if (indexPath.section == 1 && indexPath.row == 1){
                [Utils setValue:string key:@"phone"];
            }
        };
        [self.navigationController pushViewController:updataVC animated:YES];
    }
}



- (UITableViewCell *)cellImgHead{
    UITableViewCell *cell = [UITableViewCell new];
    cell.textLabel.textColor = kDarkText;
    cell.textLabel.font = kFont(16);
    cell.textLabel.text = @"修改头像";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIImageView *imgHeader;
    [cell.contentView addSubview:({
        imgHeader = [[UIImageView alloc] init];
        imgHeader.layer.cornerRadius = 25;
        imgHeader.layer.masksToBounds = YES;
        [imgHeader sd_setImageWithURL:[NSURL URLWithString:_icon] placeholderImage:[UIImage imageNamed:@"placeholder_person"]];
        imgHeader.tag = 199;
        imgHeader;
    })];
    
    [imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.width.height.mas_equalTo(50.0f);
        make.centerY.mas_equalTo(cell.contentView.mas_centerY);
    }];
    return cell;
}





- (void)downloadData{
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosIndex/showInfo" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"],@"u_pwd":[Utils getValueForKey:@"pwdMd5"]} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            _memberModel = [[MemberInfoModel alloc] initWithDictionary:response[@"data"] error:&error];
            if (!error) {
                [_tableview reloadData];
            }
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}

- (void)downloadVocation{
    [self.view loadingOnAnyView];
    [HYBNetworking getWithUrl:@"IosIndex/jobType" refreshCache:NO params:nil success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            _itemModel = [[ItemModel alloc] initWithDictionary:response error:&error];
            if (!error) {
                [self initPickView];
            }
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}

- (void)downloadYearpay{
    [self.view loadingOnAnyView];
    [HYBNetworking getWithUrl:@"IosIndex/moneyType" refreshCache:NO params:nil success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            _itemModel = [[ItemModel alloc] initWithDictionary:response error:&error];
            if (!error) {
                [self initPickView];
            }
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}





- (void)selectType{
    if (_indexPath.section == 0) {
        [self initDatePick];
        return;
    }else if (_indexPath.section == 2 && _indexPath.row == 0){
        [self downloadVocation];
    }else{
        [self downloadYearpay];
    }
}

- (void)initPickView{
    [self.view addSubview:({
        _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW, ScreenH/2 - 32)];
        _grayView.backgroundColor = [UIColor blackColor];
        _grayView.alpha = 0;
        _grayView;
    })];
    
    [self.view addSubview:({
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenH/2 - 32 + ScreenH ,ScreenW , ScreenH/2 - 32)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = kWhite;
        [_pickerView selectRow:2 inComponent:0 animated:YES];
        _pickerView;
    })];
    
    UIButton *btn;
    [self.view addSubview:({
        btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setTitle:@"确定" forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor colorWithHex:0x333333] forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(selelctClick) forControlEvents:(UIControlEventTouchUpInside)];
        btn.frame = CGRectMake(ScreenW - 55, ScreenH/2 - 32 + ScreenH, 40, 30);
        btn.tag = 1000;
        btn.alpha = 0 ;
        btn;
    })];
    
    UIButton *btn2;
    [self.view addSubview:({
        btn2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn2 setTitle:@"取消" forState:(UIControlStateNormal)];
        [btn2 setTitleColor:[UIColor colorWithHex:0x333333] forState:(UIControlStateNormal)];
        btn2.frame = CGRectMake(15, ScreenH/2 - 32 + ScreenH, 40, 30);
        [btn2 addTarget:self action:@selector(cancelSelect) forControlEvents:(UIControlEventTouchUpInside)];
        btn2.tag = 2000;
        btn.alpha = 0 ;
        btn2;
    })];
    
    [UIView animateWithDuration:0.3 animations:^{
        _grayView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        _pickerView.frame = CGRectMake(0, ScreenH/2 - 32 ,ScreenW , ScreenH/2 - 32);
        btn.frame = CGRectMake(ScreenW - 55, ScreenH/2 - 32, 40, 30);
        btn2.frame = CGRectMake(15, ScreenH/2 - 32, 40, 30);
        _grayView.alpha = 0.5;
        _pickerView.alpha = 1;
        btn2.alpha = 1;
        btn.alpha = 1;
    }];
}

- (void)initDatePick{
    [self.view addSubview:({
        _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW, ScreenH/2 - 32)];
        _grayView.backgroundColor = [UIColor blackColor];
        _grayView.alpha = 0;
        _grayView;
    })];
    
    [self.view addSubview:({
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, ScreenH/2 - 32 + ScreenH ,ScreenW , ScreenH/2 - 32)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
         [_datePicker addTarget:self action:@selector(rollAction:) forControlEvents:(UIControlEventValueChanged)];
        _datePicker;
    })];
    
    UIButton *btn;
    [self.view addSubview:({
        btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setTitle:@"确定" forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor colorWithHex:0x333333] forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(selecBirth) forControlEvents:(UIControlEventTouchUpInside)];
        btn.frame = CGRectMake(ScreenW - 55, ScreenH/2 - 32 + ScreenH, 40, 30);
        btn.tag = 1000;
        btn.alpha = 0 ;
        btn;
    })];
    
    UIButton *btn2;
    [self.view addSubview:({
        btn2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn2 setTitle:@"取消" forState:(UIControlStateNormal)];
        [btn2 setTitleColor:[UIColor colorWithHex:0x333333] forState:(UIControlStateNormal)];
        btn2.frame = CGRectMake(15, ScreenH/2 - 32 + ScreenH, 40, 30);
        [btn2 addTarget:self action:@selector(cancelSelect) forControlEvents:(UIControlEventTouchUpInside)];
        btn2.tag = 2000;
        btn.alpha = 0 ;
        btn2;
    })];
    
    [UIView animateWithDuration:0.3 animations:^{
        _grayView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        _datePicker.frame = CGRectMake(0, ScreenH/2 - 32 ,ScreenW , ScreenH/2 - 32);
        btn.frame = CGRectMake(ScreenW - 55, ScreenH/2 - 32, 40, 30);
        btn2.frame = CGRectMake(15, ScreenH/2 - 32, 40, 30);
        _grayView.alpha = 0.5;
        _datePicker.alpha = 1;
        btn.alpha = 1;
        btn2.alpha = 1;
    }];
}


- (void)selecBirth{
    [self cancelSelect];
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosIndex/saveInfo" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"],@"u_pwd":[Utils getValueForKey:@"pwdMd5"],@"borntime":[NSString stringWithFormat:@"%.0f",[_datePicker.date timeIntervalSince1970]]} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:YES showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}

- (void)cancelSelect{
    [UIView animateWithDuration:0.3 animations:^{
        UIButton *btn = [self.view viewWithTag:1000];
        UIButton *btn2 = [self.view viewWithTag:1000];
        _grayView.frame = CGRectMake(0, ScreenH, ScreenW, ScreenH);
        _pickerView.frame = CGRectMake(0, ScreenH/2 - 32 + ScreenH,ScreenW , ScreenH/2 - 32);
        _datePicker.frame = CGRectMake(0, ScreenH/2 - 32 + ScreenH,ScreenW , ScreenH/2 - 32);
        btn.frame = CGRectMake(ScreenW - 55, ScreenH/2 - 32 + ScreenH, 40, 30);
        btn2.frame = CGRectMake(15, ScreenH/2 - 32 + ScreenH, 40, 30);
        _grayView.alpha = 0;
        _pickerView.alpha = 0;
        _datePicker.alpha = 0;
        btn.alpha = 0;
        btn2.alpha = 0;
    } completion:^(BOOL finished) {
        _typeId = @"";
        [_grayView removeFromSuperview];
        [_pickerView removeFromSuperview];
        [_datePicker removeFromSuperview];
        UIButton *btn = [self.view viewWithTag:1000];
        [btn removeFromSuperview];
        UIButton *btn2 = [self.view viewWithTag:2000];
        [btn2 removeFromSuperview];
    }];
}

- (void)selelctClick{
    [self cancelSelect];
    NSString *key = _indexPath.row == 0 ? @"job_id" :@"yearpay_id";
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosIndex/saveInfo" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"],@"u_pwd":[Utils getValueForKey:@"pwdMd5"],key:_typeId} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:YES showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            [self downloadData];
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}




- (void)rollAction:(UIDatePicker *)sender{
    UITableViewCell *cell = [_tableview cellForRowAtIndexPath:_indexPath];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    // UIDatePicker 滚动也就是日期改变
    cell.detailTextLabel.text = [formatter stringFromDate:sender.date];
}




- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _itemModel.data.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_itemModel.data[row] Name];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _typeId = [_itemModel.data[row] Id];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self cancelSelect];
}


@end
