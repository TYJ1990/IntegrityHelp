//
//  OwnerViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/25.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "OwnerViewController.h"
#import "OwnerHeadView.h"
#import "WBPopOverView.h"
#import "OwnerInfoModel.h"
#import "LoginViewController.h"
#import "OwnerMyInviteViewController.h"
#import "MemberViewController.h"
#import "OwnerQdViewController.h"
#import "OwnerIntegralViewController.h"
#import "OpenStoreViewController.h"
#import "OwnerTruthNameViewController.h"
#import "OwnerMemberSystemViewController.h"
#import "OwnerMyCheckViewController.h"
#import "OwnerMyTopicViewController.h"
#import "CompleteMemberView.h"
#import "ApliyCardViewController.h"
#import "OwnerSignViewController.h"
#import "OwnerBossViewController.h"
#import "OwnerPropetyViewController.h"


@interface OwnerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)OwnerHeadView *headView;
@property(nonatomic,copy) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *titleArray;
@property(nonatomic,strong) NSMutableArray *imageArray;
@property(nonatomic,strong) NSArray *menuTitle;
@property(nonatomic,strong) NSArray *menuPic;
@property (strong, nonatomic) WBPopOverView *wbpopView;
@property(nonatomic,assign) BOOL isFirst;
@property(nonatomic,strong)OwnerInfoModel *model;
@property(nonatomic,strong) CompleteMemberView *completeView;
@property(nonatomic,strong) UIView *grayView;
@property(nonatomic,assign) BOOL first;

@end

@implementation OwnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initnavi];
    [self setUI];
   
}

- (void)initnavi{
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = RGB(57, 64, 72);
    self.navigationController.navigationBar.backgroundColor = RGB(57, 64, 72);
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kWhite,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    UIButton *btnMore = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnMore setTitle:@"   ···" forState:(UIControlStateNormal)];
    btnMore.titleLabel.font = kFont(24);
    btnMore.frame = CGRectMake(20, 0, 40, 20);
    [btnMore addTarget:self action:@selector(btnMoreAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithCustomView:btnMore];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFixedSpace) target:nil action:nil];
    self.navigationItem.rightBarButtonItems = @[spacer,more];
    
}


- (void)btnMoreAction{
    
    UIView *grayView;
    [self.view addSubview:({
        grayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        grayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        grayView;
    })];
    
    _wbpopView = [[WBPopOverView alloc] initWithOrigin:CGPointMake(ScreenW - 25, 55) Width:ScreenW*0.4 Height:45*_menuTitle.count Direction:(WBArrowDirectionUp3) view:grayView];
    [_wbpopView.backView addSubview:({
        UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,ScreenW*0.4, 45*_menuTitle.count) style:(UITableViewStylePlain)];
        tableV.delegate = self;
        tableV.dataSource = self;
        tableV.rowHeight = 45;
        tableV;
    })];
    [_wbpopView popView];
}


- (void)setUI{
    [self.view addSubview:({
        _headView = [[[NSBundle mainBundle] loadNibNamed:@"OwnerHeadView" owner:nil options:nil] firstObject];
        _headView.frame = CGRectMake(0, 0, ScreenW, 225 +100);
        [_headView.applyForCard addTarget:self action:@selector(appliForCard) forControlEvents:(UIControlEventTouchUpInside)];
        [_headView.ownerView addTarget:self action:@selector(ownerDetail) forControlEvents:(UIControlEventTouchUpInside)];
        [_headView.signBtn addTarget:self action:@selector(checkSign) forControlEvents:(UIControlEventTouchUpInside)];
        _headView;
    })];
    
    [self.view addSubview:({
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 225 - NavH, ScreenW, ScreenH - 225 - 49) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = kMainGray;
//        [_tableView setEditing:YES animated:YES];
        _tableView;
    })];
    
    
    _titleArray = [@[@"我的邀请",@"会员体系",@"我的审核",@"我的主题",@"我的资产",@"我的基金",@"退出登录"] mutableCopy];
    _imageArray = [@[@"owner_invite",@"owner_member",@"owner_select",@"owner_topic",@"owner_property",@"owner_funds",@"owner_exit"] mutableCopy];
    _menuTitle = @[@"积分排行", @"签到", @"实名认证"];
    _menuPic = @[@"owner_integral", @"owner_list", @"owner_trueName"];
}


- (void)downloadData{
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosIndex/login" refreshCache:NO params:@{@"phone":[Utils getValueForKey:@"phone"],@"pwd":[Utils getValueForKey:@"pwd"]} success:^(id response) {
        [self.view removeAnyView];
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:!_isFirst showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            _isFirst = YES;
            _model = [[OwnerInfoModel alloc] initWithDictionary:response[@"data"] error:&error];
            if (!error) {
                [_headView.icon sd_setImageWithURL:[NSURL URLWithString:imageUrl(_model.u_avatar)] placeholderImage:[UIImage imageNamed:@"owner_header"]];
                _headView.phone.text = _model.u_name;
                _headView.code.text = _model.u_card;
                _headView.sign.text = [_model.u_content isEqualToString:@" "]?@"编辑个性签名🖌":_model.u_content.length>0?_model.u_content:@"编辑个性签名🖌";
                if ([_model.u_profile integerValue] == 0 && _first == NO) {
                    _first = YES;
                    [self initCompleteView];
                }
                [Utils setValue:_model.u_avatar ? _model.u_avatar:@"" key:@"icon"];
                [[NSUserDefaults standardUserDefaults] setBool:[_model.u_profile boolValue] forKey:@"profile"];
            }
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}




#pragma mark tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableView == _tableView ? _titleArray.count : 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
            cell.textLabel.text = _titleArray[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
            cell.textLabel.textColor = kDarkText;
            cell.selectionStyle =  UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:nil];
        cell.textLabel.text = _menuTitle[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:_menuPic[indexPath.row]];
        cell.textLabel.textColor = kDarkGray;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        switch (indexPath.row) {
            case 0:{
                OwnerMyInviteViewController *ownerInviet = [[OwnerMyInviteViewController alloc] init];
                ownerInviet.hidesBottomBarWhenPushed = YES;
                ownerInviet.Img = _headView.icon.image;
                [self.navigationController pushViewController:ownerInviet animated:YES];
            }
                break;
            case 1:{
                if ([_model.u_id integerValue] == 1) {
                    OwnerBossViewController *bossVC = [[OwnerBossViewController alloc] init];
                    [self.navigationController pushViewController:bossVC animated:YES];
                }else{
                    
                    OwnerMemberSystemViewController *mmeberSys = [[OwnerMemberSystemViewController alloc] init];
                    mmeberSys.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:mmeberSys animated:YES];
                }
            }
                break;
            case 2:{
                OwnerMyCheckViewController *checkVC= [[OwnerMyCheckViewController alloc] init];
                checkVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:checkVC animated:YES];
            }
                break;
            case 3:{
                OwnerMyTopicViewController *topicVC = [[OwnerMyTopicViewController alloc] init];
                topicVC.hidesBottomBarWhenPushed = YES;
                topicVC.myImg = _model.u_avatar;
                [self.navigationController pushViewController:topicVC animated:YES];
            }
                break;
            case 4:{
                OwnerPropetyViewController *integralVC = [[OwnerPropetyViewController alloc] init];
                integralVC.hidesBottomBarWhenPushed = YES;
                integralVC.icon = _headView.icon.image;
                integralVC.name = _model.u_name;
                [self.navigationController pushViewController:integralVC animated:YES];
            }
                break;
            case 5:{
                
            }
                break;
            case 6:{
                [self ExitAction];
            }
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:{
                OwnerIntegralViewController *integralVC = [[OwnerIntegralViewController alloc] init];
                integralVC.hidesBottomBarWhenPushed = YES;
                integralVC.icon = _headView.icon.image;
                integralVC.name = _model.u_name;
                [self.navigationController pushViewController:integralVC animated:YES];
            }
                break;
            case 1:{
                OwnerQdViewController *qdVC = [[OwnerQdViewController alloc] init];
                qdVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:qdVC animated:YES];
            }
                break;
            case 2:{
                OwnerTruthNameViewController *truthName = [[OwnerTruthNameViewController alloc] init];
                truthName.hidesBottomBarWhenPushed = YES;
                truthName.name = _model.u_name;
                [self.navigationController pushViewController:truthName animated:YES];
            }
                break;
            default:
                break;
        }
        
        [_wbpopView dismiss];
    }
}

//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
//    [_titleArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
//    [_imageArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
//}
//
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return  UITableViewCellEditingStyleNone;
//}



- (void)initCompleteView{
    [self.view addSubview:({
        _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _grayView.backgroundColor = [UIColor blackColor];
        _grayView.alpha = 0;
        _grayView;
    })];
    
    [self.view addSubview:({
        _completeView = [[[NSBundle mainBundle] loadNibNamed:@"CompleteMemberView" owner:nil options:nil] firstObject];
        _completeView.frame = CGRectMake(40, (ScreenH-315)/2 - ScreenH, ScreenW - 80, 315);
        [_completeView.close addTarget:self action:@selector(closeTip) forControlEvents:(UIControlEventTouchUpInside)];
        [_completeView.completeBtn addTarget:self action:@selector(pushToCenter) forControlEvents:(UIControlEventTouchUpInside)];
        _completeView;
    })];
    
    [UIView animateWithDuration:0.5 animations:^{
        _grayView.alpha = 0.6;
        _completeView.frame = CGRectMake(40, (ScreenH-415)/2, ScreenW - 80, 315);
    }];
}

- (void)closeTip{
    [UIView animateWithDuration:0.3 animations:^{
        _grayView.alpha = 0;
        _completeView.frame = CGRectMake(40, (ScreenH-315)/2 - ScreenH, ScreenW - 80, 315);
    } completion:^(BOOL finished) {
        [_grayView removeFromSuperview];
        [_completeView removeFromSuperview];
    }];
}

- (void)pushToCenter{
    [self ownerDetail];
    [_grayView removeFromSuperview];
    [_completeView removeFromSuperview];
}



- (void)appliForCard{
    ApliyCardViewController *appliyV = [[ApliyCardViewController alloc] init];
    [self.navigationController pushViewController:appliyV animated:YES];
}


- (void)ownerDetail{
    MemberViewController *mmeberVC = [[MemberViewController alloc] init];
    mmeberVC.name = _model.u_name;
    mmeberVC.icon = imageUrl(_model.u_avatar);
    mmeberVC.phone = _model.u_phone;
    mmeberVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mmeberVC animated:YES];
}

- (void)checkSign{
    OwnerSignViewController *signVC = [[OwnerSignViewController alloc] init];
    signVC.sign = _model.u_content;
    [self.navigationController pushViewController:signVC animated:YES];
}


- (void)ExitAction{
    dispatch_async(dispatch_get_main_queue(), ^{
        BaseAlertControler *view = [[BaseAlertControler alloc] init];
        UIAlertController *alert = [view alertmessage:@"确定退出" Title:@"退出可能会使你的下次登录需要账号密码，确定退出？" andBlock:^{
            [Utils removeAllValue];
            LoginViewController *hvc = [[LoginViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:hvc];
            self.view.window.rootViewController = nav;
        }];
        [self presentViewController:alert animated:YES completion:nil];
    });
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self downloadData];
    [self initnavi];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
