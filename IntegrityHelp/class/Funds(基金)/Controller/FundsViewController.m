//
//  FundsViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/25.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "FundsViewController.h"
#import "SDCycleScrollView.h"
#import "HelperTableViewCell.h"
#import "HelperModel.h"
#import "HelperDetailViewController.h"
#import "FundHeadBottomView.h"
#import "FundModel.h"
#import "FundTableViewCell.h"
#import "FundsBorrowViewController.h"
#import "FundDonationView.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "RSADataSigner.h"
#import "OwnerTruthNameViewController.h"


@interface FundsViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,copy) UITableView *tableView;
@property(nonatomic,strong) FundModel *fundModel;
@property(nonatomic,strong) NSMutableArray *imagesURLStrings;
@property(nonatomic,strong) UIView *grayView;
@property(nonatomic,strong) FundDonationView *donationView;
@property(nonatomic,assign) BOOL selected;
@property(nonatomic,strong) NSString *type;
@property(nonatomic,assign) NSInteger pageNumber;
@property(nonatomic,strong) NSString *sn;
@end

@implementation FundsViewController

- (void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"refresh" object:nil];
    
    self.title = @"基金";
    [self setUI];
    [self downloadData];
    [self downloadImg];
}



- (void)setUI{
    
    _pageNumber = 1;
    [self.view addSubview:({
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 100;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _pageNumber = 1;
            [self downloadData];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _pageNumber ++;
            [self downloadData];
        }];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"FundTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"fundCell"];
        _tableView;
    })];
    WS(weakSelf)
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(0);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).with.offset(0);
    }];
}

- (void)refresh{
    [self downloadData];
}


- (void)setHeardView{
    UIView *headView;
    [_tableView setTableHeaderView:({
        headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH * 0.25 + 150)];
        
        headView;
    })];
    
    [headView addSubview:({
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 48, ScreenW, ScreenH * 0.25 + 22) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            cycleScrollView.imageURLStringsGroup = _imagesURLStrings;
        });
        cycleScrollView;
    })];

    UIView *headTopView;
    [headView addSubview:({
        headTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 48)];
        headTopView.backgroundColor = RGB(109, 109, 109);
        
        headTopView;
    })];
    
    [headTopView addSubview:({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 48)];
        label.text = @"已有基金12242元";
        label.font = kFont(15);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kWhite;
        label;
    })];
    
    [headView addSubview:({
        FundHeadBottomView *bottomV = [[FundHeadBottomView alloc] initWithFrame:CGRectMake(0, ScreenH * 0.25 + 70, ScreenW, 80)];
        [bottomV.donationBtn addTarget:self action:@selector(donationAction) forControlEvents:(UIControlEventTouchUpInside)];
        [bottomV.borrowBtn addTarget:self action:@selector(borrowAction) forControlEvents:(UIControlEventTouchUpInside)];
        bottomV;
    })];
}

- (void)donationAction{
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosBorrow/realName" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"],@"u_pwd":[Utils getValueForKey:@"pwdMd5"]} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:NO];
        if (state == SESSIONSUCCESS) {
            [self.view addSubview:({
                _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
                _grayView.backgroundColor = [UIColor blackColor];
                _grayView.alpha = 0;
                _grayView;
            })];
            
            [self.view addSubview:({
                _donationView = [[[NSBundle mainBundle] loadNibNamed:@"FundDonationView" owner:nil options:nil] firstObject];
                _donationView.frame = CGRectMake(0, ScreenH, ScreenW, 205);
                _donationView.alpha = 0;
                _donationView.otherTF.borderStyle= UITextBorderStyleNone;
                _donationView.otherTF.delegate = self;
                _donationView.twentyBtn.layer.cornerRadius = 5;
                _donationView.twentyBtn.layer.masksToBounds = YES;
                _donationView.twentyBtn.layer.borderColor = [UIColor colorWithHex:0xdfdfdf].CGColor;
                _donationView.twentyBtn.layer.borderWidth = 1.5;
                _donationView.fiftyBtn.layer.cornerRadius = 5;
                _donationView.fiftyBtn.layer.masksToBounds = YES;
                _donationView.fiftyBtn.layer.borderColor = [UIColor colorWithHex:0xdfdfdf].CGColor;
                _donationView.fiftyBtn.layer.borderWidth = 1.5;
                _donationView.proticolBtn.layer.cornerRadius = 5;
                _donationView.proticolBtn.layer.masksToBounds = YES;
                _donationView.otherNum.layer.borderColor = [UIColor colorWithHex:0xdfdfdf].CGColor;
                _donationView.otherNum.layer.borderWidth = 1.5;
                _donationView.otherNum.layer.cornerRadius = 5;
                _donationView.otherNum.layer.masksToBounds = YES;
                _donationView.donationBtn.layer.cornerRadius = 5;
                _donationView.donationBtn.layer.masksToBounds = YES;
                [_donationView.twentyBtn addTarget:self action:@selector(selectTwent) forControlEvents:(UIControlEventTouchUpInside)];
                [_donationView.fiftyBtn addTarget:self action:@selector(selectFifty) forControlEvents:(UIControlEventTouchUpInside)];
                [_donationView.agreeProticol addTarget:self action:@selector(agree) forControlEvents:(UIControlEventTouchUpInside)];
                [_donationView.proticolBtn addTarget:self action:@selector(proticol) forControlEvents:(UIControlEventTouchUpInside)];
                [_donationView.donationBtn addTarget:self action:@selector(donationClick) forControlEvents:(UIControlEventTouchUpInside)];
                _donationView;
            })];
            
            [UIView animateWithDuration:0.5 animations:^{
                _grayView.alpha = 0.6;
                _donationView.alpha = 1;
                _donationView.frame = CGRectMake(0, ScreenH-205-49-64, ScreenW, 205);
            }];
            
        }else{
            BaseAlertControler *alert = [[BaseAlertControler alloc] init];
            UIAlertController *alertC = [alert alertmessage:@"前往" Title:@"请先完成实名认证" andBlock:^{
                OwnerTruthNameViewController *truthNameVC = [[OwnerTruthNameViewController alloc] init];
                [self.navigationController pushViewController:truthNameVC animated:YES];
            }];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}

- (void)borrowAction{
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosBorrow/realName" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"],@"u_pwd":[Utils getValueForKey:@"pwdMd5"]} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:NO];
        if (state == SESSIONSUCCESS) {
            FundsBorrowViewController *borrowVC = [[FundsBorrowViewController alloc] init];
            [self.navigationController pushViewController:borrowVC animated:YES];
        }else{
            BaseAlertControler *alert = [[BaseAlertControler alloc] init];
            UIAlertController *alertC = [alert alertmessage:@"前往" Title:@"请先完成实名认证" andBlock:^{
                OwnerTruthNameViewController *truthNameVC = [[OwnerTruthNameViewController alloc] init];
                [self.navigationController pushViewController:truthNameVC animated:YES];
            }];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}

- (void)selectTwent{
    _type = @"twenty";
    _donationView.otherTF.text = @"";
    _donationView.fiftyBtn.layer.borderColor = [UIColor colorWithHex:0xdfdfdf].CGColor;
    _donationView.twentyBtn.layer.borderColor = [UIColor colorWithHex:0xff6d06].CGColor;
    _donationView.fiftyImg.hidden = YES;
    _donationView.twentyImg.hidden = NO;
    _donationView.otherImg.hidden = YES;
}


- (void)selectFifty{
    _type = @"fifty";
    _donationView.otherTF.text = @"";
    _donationView.fiftyBtn.layer.borderColor = [UIColor colorWithHex:0xff6d06].CGColor;
    _donationView.twentyBtn.layer.borderColor = [UIColor colorWithHex:0xdfdfdf].CGColor;
    _donationView.fiftyImg.hidden = NO;
    _donationView.twentyImg.hidden = YES;
    _donationView.otherImg.hidden = YES;
}


- (void)agree{
    if (_selected) {
        [_donationView.agreeProticol setImage:[UIImage imageNamed:@"fund_selected"] forState:(UIControlStateNormal)];
    }else{
        [_donationView.agreeProticol setImage:[UIImage imageNamed:@"fund_disSelect"] forState:(UIControlStateNormal)];
    }
    _selected = !_selected;
}

- (void)proticol{
    
}


- (void)donationClick{
    if (_selected) {
        return [self.view Message:@"请您同意捐款协议哦" HiddenAfterDelay:0.7];
    }
    if ([TXUtilsString isBlankString:_type] || ([_type isEqualToString:@"other"] && _donationView.otherTF.text.length == 0)) {
        return [self.view Message:@"请选择诚信币哦" HiddenAfterDelay:0.7];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        _grayView.alpha = 0;
        _donationView.alpha = 0;
        _donationView.frame = CGRectMake(0, ScreenH, ScreenW, 205);
    } completion:^(BOOL finished) {
        [_grayView removeFromSuperview];
        [_donationView removeFromSuperview];
    }];
    
    NSString *number;
    if ([_type isEqualToString:@"twenty"]) {
        number = @"20";
    }else if ([_type isEqualToString:@"fifty"]){
        number = @"50";
    }else{
        number = _donationView.otherTF.text;
    }
    
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosBorrow/reCharge" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"],@"Ty":@1,@"Money":number} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            _sn = response[@"data"];
            NSString *appScheme = @"xfalipay";
            [[AlipaySDK defaultService] payOrder:_sn fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
            }];
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}




- (void)downloadData{
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosBorrow/index" refreshCache:NO params:@{@"page":[NSNumber numberWithInteger:_pageNumber],@"pagesize":@10} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            if (_pageNumber == 1) {
                _fundModel = [[FundModel alloc] initWithDictionary:response error:&error];
            }else{
                FundModel *model = [[FundModel alloc] initWithDictionary:response error:&error];
                if (model.data.count == 0) {
                    [self.view Message:@"没有更多数据了" HiddenAfterDelay:1];
                }
                [_fundModel.data addObjectsFromArray:model.data];
            }
            if (!error) {
                [_tableView.mj_footer endRefreshing];
                [_tableView.mj_header endRefreshing];
                [_tableView reloadData];
            }
        }
    } fail:^(NSError *error) {
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
        [self.view removeAnyView];
    }];
}


- (void)downloadImg{
    [self.view loadingOnAnyView];
    [HYBNetworking getWithUrl:@"IosBorrow/banner" refreshCache:NO params:nil success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            _imagesURLStrings = [NSMutableArray array];
            [_imagesURLStrings addObject:imageUrl(response[@"data"][@"App_jijinpic1"])];
            [_imagesURLStrings addObject:imageUrl(response[@"data"][@"App_jijinpic2"])];
            [_imagesURLStrings addObject:imageUrl(response[@"data"][@"App_jijinpic3"])];
            [self setHeardView];
        }
    } fail:^(NSError *error) {
        [self setHeardView];
        [self.view removeAnyView];
    }];
}


#pragma mark tableviewDalegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _fundModel.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fundCell" forIndexPath:indexPath];
    [cell cellConfigureModel:_fundModel.data[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    HelperDetailViewController *detailVC = [[HelperDetailViewController alloc] init];
//    detailVC.titleStr = [_helperModel.data[indexPath.row] Title];
//    detailVC.ID = [_helperModel.data[indexPath.row] Id];
//    [self.navigationController pushViewController:detailVC animated:YES];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
    view.backgroundColor = kMainGray;
    [view addSubview:({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 40)];
        label.text = @"项目基金";
        label.font = kFont(15);
        label.textColor = kGray;
        label;
    })];
    
    [view addSubview:({
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
        line.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
        line;
    })];
    
    [view addSubview:({
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, ScreenW, 1)];
        line.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
        line;
    })];
    return view;
}



- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint touchPos = [touches.anyObject locationInView:self.view];
    if (touchPos.y < ScreenH - 49 - 200) {
        [UIView animateWithDuration:0.5 animations:^{
            _grayView.alpha = 0;
            _donationView.alpha = 0;
            _donationView.frame = CGRectMake(0, ScreenH, ScreenW, 205);
        } completion:^(BOOL finished) {
            [_grayView removeFromSuperview];
            [_donationView removeFromSuperview];
        }];
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _type = @"tf";
    _donationView.fiftyBtn.layer.borderColor = [UIColor colorWithHex:0xdfdfdf].CGColor;
    _donationView.twentyBtn.layer.borderColor = [UIColor colorWithHex:0xdfdfdf].CGColor;
    _donationView.fiftyImg.hidden = YES;
    _donationView.twentyImg.hidden = YES;
    _donationView.otherImg.hidden = NO;
    return YES;
}



@end
