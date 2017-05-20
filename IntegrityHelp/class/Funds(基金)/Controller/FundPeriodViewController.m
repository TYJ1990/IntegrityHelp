//
//  FundPeriodViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/18.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "FundPeriodViewController.h"

@interface FundPeriodViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong) NSArray *titleArray;

@end

@implementation FundPeriodViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initnavi];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}


- (void)initnavi{
    [self initNav:@"我要借款" color:[UIColor whiteColor] imgName:@"back_black"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kDarkText,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
}

- (void)setUI{
    [self.view addSubview:({
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 64) style:(UITableViewStylePlain)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview;
    })];
    _tableview.tableFooterView = [UIView new];
    _titleArray = @[@"1个月",@"2个月",@"3个月",@"4个月",@"5个月",@"6个月",@"7个月",@"8个月",@"9个月",@"10个月",@"11个月",@"12个月"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    if (indexPath.row == 0) {
        [cell.contentView addSubview:({
            UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(16, 0, ScreenW, 30)];
            tf.borderStyle = UITextBorderStyleNone;
            tf.font = kFont(15);
            tf.placeholder = @"手动输入";
            tf.delegate = self;
            tf.returnKeyType = UIReturnKeyDone;
            tf;
        })];
    }else{
        cell.textLabel.text = _titleArray[indexPath.row - 1];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _callBack(_titleArray[indexPath.row-1]);
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    _callBack(textField.text);
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}

@end
