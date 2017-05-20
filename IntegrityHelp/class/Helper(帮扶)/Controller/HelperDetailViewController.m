//
//  HelperDetailViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/4.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "HelperDetailViewController.h"
#import "Helper_DetailV.h"
#import "HelpDetailModel.h"

@interface HelperDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) Helper_DetailV *detailView;
@property(nonatomic,copy) UITableView *tableView;
@property(nonatomic,strong) HelpDetailModel *detailModel;
@property(nonatomic,strong) UIButton *helpBtn;

@end

@implementation HelperDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavi];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kMainGray;
    
    [self setUI];
    [self loadData];
}






- (void)setNavi{
    [self initNav:_titleStr color:kWhite imgName:@"back_black"];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kDarkText,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
}


- (void)loadData{
    [self.view loadingOnAnyView];
    [HYBNetworking getWithUrl:@"IosProject/projectDetail" refreshCache:NO params:@{@"p_id":_ID} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            _detailModel = [[HelpDetailModel alloc] initWithDictionary:response[@"data"] error:&error];
            if (!error) {
                [_detailView initWithModel:_detailModel];
                _detailView.username = [Utils getValueForKey:@"name"];
                [_detailView.icon sd_setImageWithURL:[NSURL URLWithString:imageUrl(_detailModel.face)] placeholderImage:[UIImage imageNamed:@"placehlder_person"]];
                if ([_detailModel.Status integerValue] != 2) {
                    _helpBtn.hidden = YES;
                }
            }
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}



- (void)setUI{
    
    [self.view addSubview:({
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 64) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kMainGray;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView;
    })];
    
    [self.view addSubview:({
        _detailView = [[[NSBundle mainBundle] loadNibNamed:@"Helper_DetailV" owner:nil options:nil] firstObject];
        _detailView.frame = CGRectMake(0, 0, ScreenW, 432);
        _detailView;
    })];
    _tableView.tableHeaderView = _detailView;
    
    [self.view addSubview:({
        _helpBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_helpBtn setTitle:@"帮扶" forState:(UIControlStateNormal)];
        _helpBtn.backgroundColor = kMainColor;
        _helpBtn.layer.cornerRadius = 5;
        _helpBtn.layer.masksToBounds = YES;
        _helpBtn.frame = CGRectMake(15, ScreenH - 64 - 30 - 50, ScreenW - 30, 50);
        [_helpBtn addTarget:self action:@selector(helpAction) forControlEvents:(UIControlEventTouchUpInside)];
        _helpBtn;
    })];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}



- (void)helpAction{
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosProject/dohelp" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"],@"p_id":_ID} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:YES showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}


@end
