//
//  OwnerCheckingDetailViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/5.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "OwnerCheckingDetailViewController.h"
#import "Helper_DetailV.h"
#import "HelpDetailModel.h"
#import "CheckingDetailTableViewCell.h"
#import "OwnerDecideViewController.h"
#import "memberInfo.h"

@interface OwnerCheckingDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property(nonatomic,strong) Helper_DetailV *detailView;
@property(nonatomic,copy) UITableView *tableView;
@property(nonatomic,strong) HelpDetailModel *detailModel;
@property(nonatomic,strong) UIButton *helpBtn;
@property(nonatomic,strong) UIButton *agreeBtn;
@property(nonatomic,strong) UIButton *disAgreeBtn;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView *grayView;
@property(nonatomic,strong) memberInfo *memberView;
@property(nonatomic,strong) NSString *chooseID;
@property(nonatomic,assign) NSInteger index;

@end

@implementation OwnerCheckingDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavi];
    [self loadData];
    
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cooperation:) name:@"cooperation" object:nil];
}




- (void)setNavi{
    [self initNav:_titleStr color:kWhite imgName:@"back_black"];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kDarkText,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
    self.view.backgroundColor = kMainGray;
}


- (void)loadData{
    NSString *url;
    NSDictionary *dic;
    if (_flag) {
        url = @"IosIndex/myProjectDetail";
        dic = @{@"p_id":_ID};
    }else{
        url = @"IosIndex/myFviewDetail";
        dic = @{@"p_id":_ID,@"u_id":[Utils getValueForKey:@"u_id"]};
    }
    [self.view loadingOnAnyView];
    [HYBNetworking getWithUrl:url refreshCache:NO params:dic success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            _detailModel = [[HelpDetailModel alloc] initWithDictionary:response[@"data"] error:&error];
            if (!error) {
                [_detailView initWithModel:_detailModel];
                if ([_detailModel.Status integerValue] != 2) {
                    _helpBtn.hidden = YES;
                }
                [_tableView reloadData];
                if (_detailModel.list.count > 7) {
                    _scrollView.contentSize = CGSizeMake(_detailModel.list.count * ((ScreenW - 30) / 7), 50);
                }else{
                    _scrollView.contentSize = CGSizeMake(ScreenW, 50);
                }
                [self creatImgList];
                [self buttonHiddenOrShow];
            }
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}

- (void)buttonHiddenOrShow{
    if (!_flag) {
        if ([[Utils getValueForKey:@"u_id"] integerValue] == [_detailModel.F_id integerValue]) {
            if ([_detailModel.F_review boolValue]) {
                _bgView.hidden = YES;
                _tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH - 64);
                UIView *headView = _tableView.tableHeaderView;
                CGRect frame = headView.frame;
                frame.size.height = 433;
                headView.frame = frame;
                [_tableView beginUpdates];
                _tableView.tableHeaderView = headView;
                [_tableView endUpdates];
            }else{
                _bgView.hidden = NO;
            }
        }else{
            if ([_detailModel.Ff_review boolValue]) {
                _bgView.hidden = YES;
                _tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH - 64);
                UIView *headView = _tableView.tableHeaderView;
                CGRect frame = headView.frame;
                frame.size.height = 433;
                headView.frame = frame;
                [_tableView beginUpdates];
                _tableView.tableHeaderView = headView;
                [_tableView endUpdates];
            }else{
                _bgView.hidden = NO;
            }
        }
    }else{
        if (_detailModel.list.count == 0 || [_detailModel.Status integerValue] == 3 || [_detailModel.Status integerValue] == 4 || [_detailModel.F_review integerValue] == 0) {
            _bgView.hidden = YES;
            _tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH - 64);
            UIView *headView = _tableView.tableHeaderView;
            CGRect frame = headView.frame;
            frame.size.height = 433;
            headView.frame = frame;
            [_tableView beginUpdates];
            _tableView.tableHeaderView = headView;
            [_tableView endUpdates];
        }else{
            _bgView.hidden = NO;
        }
    }
}


- (void)creatImgList{
    for (int i = 0; i < _detailModel.list.count; i++) {
        [_scrollView addSubview:({
            UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            btn.layer.cornerRadius = 20;
            btn.layer.masksToBounds = YES;
            btn.frame = CGRectMake(15 + i * ((ScreenW - 30) / 7), 5, 40, 40);
            [btn setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl([_detailModel.list[i] face])]]] forState:(UIControlStateNormal)];
            btn.tag = 100 + i;
            [btn addTarget:self action:@selector(showMessege:) forControlEvents:(UIControlEventTouchUpInside)];
            btn;
        })];
    }
}

- (void)showMessege:(UIButton *)btn{
    HelpDetailListModel *model = _detailModel.list[btn.tag - 100];
    _chooseID = model.Uid;
    [self.view addSubview:({
        _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _grayView.backgroundColor = [UIColor blackColor];
        _grayView.alpha = 0;
        _grayView;
    })];
    
    [self.view addSubview:({
        _memberView = [[[NSBundle mainBundle] loadNibNamed:@"memberInfo" owner:nil options:nil] firstObject];
        _memberView.frame = CGRectMake(0, 0, ScreenW * 0.8, 300);
        _memberView.center = CGPointMake(ScreenW/2, -ScreenH/2);;
        _memberView.alpha = 0;
        [_memberView configureWithName:model.name icon:imageUrl(model.face) telphone:@"110" gener:@"男" age:@"18" type:@"电子信息服务"];
        [_memberView.sureBtn setTitle:@"合作" forState:(UIControlStateNormal)];
        _memberView;
    })];
    
    [UIView animateWithDuration:0.5 animations:^{
        _memberView.center = CGPointMake(ScreenW/2, ScreenH/2 -30);
        _grayView.alpha = 0.6;
        _memberView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}


- (void)cooperation:(NSNotification *)notification{
    if (notification.object) {
        [UIView animateWithDuration:0.5 animations:^{
            _memberView.center = CGPointMake(ScreenW/2, -ScreenH/2 -30);
            _grayView.alpha = 0;
            _memberView.alpha = 0;
        } completion:^(BOOL finished) {
            [_grayView removeFromSuperview];
            [_memberView removeFromSuperview];
        }];
        return;
    }
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosIndex/choose" refreshCache:NO params:@{@"p_id":_ID ,@"choose_id":_chooseID} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:YES showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            [UIView animateWithDuration:0.5 animations:^{
                _memberView.center = CGPointMake(ScreenW/2, -ScreenH/2 -30);
                _grayView.alpha = 0;
                _memberView.alpha = 0;
            } completion:^(BOOL finished) {
                [_grayView removeFromSuperview];
                [_memberView removeFromSuperview];
                [self loadData];
                for (UIButton *btn in _scrollView.subviews) {
                    btn.enabled = NO;
                }
            }];
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];

}



- (void)setUI{
    
    [self.view addSubview:({
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 64 - 50) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kMainGray;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"CheckingDetailTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
        _tableView;
    })];
    
    [self.view addSubview:({
        _detailView = [[[NSBundle mainBundle] loadNibNamed:@"Helper_DetailV" owner:nil options:nil] firstObject];
        _detailView.frame = CGRectMake(0, 0, ScreenW, 432);
        _detailView;
    })];
    _tableView.tableHeaderView = _detailView;
    [_detailView.icon sd_setImageWithURL:[NSURL URLWithString:imageUrl(_img)] placeholderImage:[UIImage imageNamed:@"placeholder_person"]];
    
    [self.view addSubview:({
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - 64 - 50, ScreenW, 50)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView;
    })];
    
    if (!_flag) {
        [_bgView addSubview:({
            _agreeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            _agreeBtn.frame = CGRectMake(0, 0, ScreenW/2, 50);
            [_agreeBtn setTitle:@"同意" forState:(UIControlStateNormal)];
            [_agreeBtn setTitleColor:kMainColor forState:(UIControlStateNormal)];
            _agreeBtn.titleLabel.font = kFont(14);
            [_agreeBtn addTarget:self action:@selector(agree) forControlEvents:(UIControlEventTouchUpInside)];
            _agreeBtn;
        })];
        
        [_bgView addSubview:({
            _disAgreeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            _disAgreeBtn.frame = CGRectMake(ScreenW/2, 0, ScreenW/2, 50);
            [_disAgreeBtn setTitle:@"拒绝" forState:(UIControlStateNormal)];
            [_disAgreeBtn setTitleColor:kMainColor forState:(UIControlStateNormal)];
            _disAgreeBtn.titleLabel.font = kFont(14);
            [_disAgreeBtn addTarget:self action:@selector(disAgree) forControlEvents:(UIControlEventTouchUpInside)];
            _disAgreeBtn;
        })];
    }else{
        [_bgView addSubview:({
            _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 0, ScreenW, 50)];
            _scrollView;
        })];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([_detailModel.F_review integerValue] == 1) {
        if ([_detailModel.Ff_id boolValue]) {
            if ([_detailModel.Tid boolValue]) {
                _index = 4;
            }else{
                _index = 3;
            }
        }else{
            if ([_detailModel.Tid boolValue]) {
                _index = 3;
            }else{
                _index = 2;
            }
        }
    }else{
        _index = 2;
    }
    if (!_detailModel) {
        _index = 0;
    }
    return _index;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CheckingDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.topHeight.constant = 25;
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:imageUrl(_img)] placeholderImage:[UIImage imageNamed:@"placeholder_person"]];
        cell.username.text = _detailModel.U_name;
        cell.time.text = [Utils TransformTimestampWith:_detailModel.Addtime dateDormate:@"yyyy.MM.dd HH:mm"];
    }else if (indexPath.row == 1){
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:imageUrl(_detailModel.F_id_face)] placeholderImage:[UIImage imageNamed:@"placeholder_person"]];
        cell.username.text = _detailModel.F_id_name;
        if ([_detailModel.F_review integerValue] == 0) {
            cell.statusLabel.text = @"审批中";
            cell.statusLabel.textColor = [UIColor colorWithHex:0xff6d06];
            cell.statusImg.image = [UIImage imageNamed:@"owner_thking"];
            cell.line.hidden = YES;
            cell.time.textColor = [UIColor colorWithHex:0xff6d06];
            CGFloat time = [[NSDate new] timeIntervalSince1970] - [_detailModel.Addtime floatValue];
            cell.time.text = [self getIntervalTime:(NSInteger)time];
        }else if([_detailModel.F_review integerValue] == 1){
            cell.statusLabel.text = @"已同意";
            cell.statusLabel.textColor = [UIColor darkGrayColor];
            cell.statusImg.image = [UIImage imageNamed:@"owner_agree"];
            if ([_detailModel.Ff_id boolValue]) {
                cell.line.hidden = NO;
            }else{
                if ([_detailModel.Tid integerValue] == 0) {
                    cell.line.hidden = YES;
                }else{
                    cell.line.hidden = NO;
                }
            }
            [cell.contentView addSubview:({
                CGFloat height = [TXUtilsString AutoHeight:_detailModel.F_no font:14.0 andCGsize:CGSizeMake(ScreenW - 70, 1000)];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(62, 90, ScreenW  - 90, height)];
                label.font = kFont(14.0);
                label.textColor = [UIColor colorWithHex:0x666666];
                label.text = _detailModel.F_no;
                label;
            })];
            cell.time.textColor = [UIColor darkGrayColor];
            cell.time.text = [Utils TransformTimestampWith:_detailModel.F_time dateDormate:@"yyyy.MM.dd HH:mm"];
        }else{
            [cell.contentView addSubview:({
                CGFloat height = [TXUtilsString AutoHeight:_detailModel.F_no font:14.0 andCGsize:CGSizeMake(ScreenW - 70, 1000)];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(62, 90, ScreenW  - 90, height)];
                label.font = kFont(14.0);
                label.textColor = [UIColor colorWithHex:0x666666];
                label.text = _detailModel.F_no;
                label;
            })];
            cell.statusLabel.text = @"已拒绝";
            cell.statusLabel.textColor = [UIColor colorWithHex:0xff6d06];
            cell.statusImg.image = [UIImage imageNamed:@"owner_agree"];
            cell.line.hidden = YES;
            cell.time.textColor = [UIColor colorWithHex:0xff6d06];
            cell.time.text = [Utils TransformTimestampWith:_detailModel.F_time dateDormate:@"yyyy.MM.dd HH:mm"];
        }
    }
    if(indexPath.row == 2 && [_detailModel.Ff_id integerValue] != 0){
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:imageUrl(_detailModel.Ff_id_face)] placeholderImage:[UIImage imageNamed:@"placeholder_person"]];
        cell.username.text = _detailModel.Ff_id_name;
        if ([_detailModel.Ff_review integerValue] == 0) {
            cell.statusLabel.text = @"审批中";
            cell.statusLabel.textColor = [UIColor colorWithHex:0xff6d06];
            cell.statusImg.image = [UIImage imageNamed:@"owner_thking"];
            cell.line.hidden = YES;
            cell.time.textColor = [UIColor colorWithHex:0xff6d06];
            CGFloat time = [[NSDate new] timeIntervalSince1970] - [_detailModel.F_time floatValue];
            cell.time.text = [self getIntervalTime:(NSInteger)time];
        }else if([_detailModel.Ff_review integerValue] == 1){
            if ([_detailModel.Tid integerValue] == 0) {
                cell.line.hidden = YES;
            }else{
                cell.line.hidden = NO;
            }
            cell.statusLabel.text = @"已同意";
            [cell.contentView addSubview:({
                CGFloat height = [TXUtilsString AutoHeight:_detailModel.Ff_no font:14.0 andCGsize:CGSizeMake(ScreenW - 70, 1000)];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(62, 90, ScreenW  - 90, height)];
                label.font = kFont(14.0);
                label.textColor = [UIColor colorWithHex:0x666666];
                label.text = _detailModel.Ff_no;
                label;
            })];
            cell.statusLabel.textColor = [UIColor darkGrayColor];
            cell.statusImg.image = [UIImage imageNamed:@"owner_agree"];
            cell.time.textColor = [UIColor darkGrayColor];
            cell.time.text = [Utils TransformTimestampWith:_detailModel.Ff_time dateDormate:@"yyyy.MM.dd HH:mm"];
        }else{
            cell.line.hidden = YES;
            cell.statusLabel.text = @"已拒绝";
            [cell.contentView addSubview:({
                CGFloat height = [TXUtilsString AutoHeight:_detailModel.Ff_no font:14.0 andCGsize:CGSizeMake(ScreenW - 70, 1000)];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(62, 90, ScreenW  - 90, height)];
                label.font = kFont(14.0);
                label.textColor = [UIColor colorWithHex:0x666666];
                label.text = _detailModel.Ff_no;
                label;
            })];
            cell.statusLabel.textColor = [UIColor colorWithHex:0xff6d06];
            cell.statusImg.image = [UIImage imageNamed:@"owner_agree"];
            cell.time.textColor = [UIColor colorWithHex:0xff6d06];
            cell.time.text = [Utils TransformTimestampWith:_detailModel.Ff_time dateDormate:@"yyyy.MM.dd HH:mm"];
        }
    }
    if(indexPath.row == 3 || (indexPath.row == 2 && [_detailModel.Ff_id integerValue] == 0)){
        cell.username.text = _detailModel.Tid_name;
        cell.statusLabel.text = [Utils getStatus:[_detailModel.Status integerValue]];
        cell.line.hidden = YES;
        cell.statusLabel.textColor = [UIColor darkGrayColor];
        cell.statusImg.image = [UIImage imageNamed:@"owner_agree"];
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:imageUrl(_detailModel.Tid_face)] placeholderImage:[UIImage imageNamed:@"placeholder_person"]];
        if ([_detailModel.Status integerValue] == 4) {
            cell.time.hidden = NO;
            cell.comment.hidden = YES;
            cell.time.text = [Utils TransformTimestampWith:_detailModel.Finishtime dateDormate:@"yyyy.MM.dd HH:mm"];
            
            [cell.contentView addSubview:({
                CGFloat height = [TXUtilsString AutoHeight:_detailModel.Comment font:14.0 andCGsize:CGSizeMake(ScreenW - 70, 1000)];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(62, 90, ScreenW  - 90, height)];
                label.font = kFont(14.0);
                label.textColor = [UIColor colorWithHex:0x666666];
                label.text = _detailModel.Comment;
                label;
            })];
            
        }else if([_detailModel.Status integerValue] == 3){
            cell.time.hidden = YES;
            cell.comment.hidden = NO;
            [cell.comment addTarget:self action:@selector(commentting) forControlEvents:(UIControlEventTouchUpInside)];
        }
    }
    if (_index == indexPath.row + 1) {
        cell.bottomHeight.constant = 25;
    }else{
        cell.bottomHeight.constant = 8;
    }
    [cell cellConfigureModel:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 110;
    }else if (indexPath.row == 2){
        if ([_detailModel.Ff_id boolValue]) {
            if ([_detailModel.Ff_review integerValue] == 1) {
                CGFloat height = [TXUtilsString AutoHeight:_detailModel.F_no font:14.0 andCGsize:CGSizeMake(ScreenW - 90, 1000)];
                if (_index == 3) {
                    return 125 + height;
                }else{
                    return 105 + height;
                }
            }else{
                return 115;
            }
        }else{
            if ([_detailModel.Status integerValue] == 4) {
                CGFloat height = [TXUtilsString AutoHeight:_detailModel.Comment font:14.0 andCGsize:CGSizeMake(ScreenW - 90, 1000)];
                return 125 + height;
            }else{
                return 115;
            }
        }
    }else if (indexPath.row == 1){
        if ([_detailModel.F_review integerValue] == 1 || [_detailModel.F_review integerValue] == 2) {
            CGFloat height = [TXUtilsString AutoHeight:_detailModel.F_no font:14.0 andCGsize:CGSizeMake(ScreenW - 90, 1000)];
            if (_index == 2) {
                return 125 + height;
            }else{
                return 105 + height;
            }
        }else{
            return 115;
        }
    }else{
        if ([_detailModel.Status integerValue] == 4) {
            CGFloat height = [TXUtilsString AutoHeight:_detailModel.Comment font:14.0 andCGsize:CGSizeMake(ScreenW - 90, 1000)];
            return 125 + height;
        }else{
            return 115;
        }
    }
}



- (void)commentting{
    OwnerDecideViewController *decideVC = [[OwnerDecideViewController alloc] init];
    decideVC.tip = @"说点什么吧";
    decideVC.tid = _detailModel.Tid;
    decideVC.pid = _ID;
    [self.navigationController pushViewController:decideVC animated:YES];
}

- (void)agree{
    OwnerDecideViewController *decideVC = [[OwnerDecideViewController alloc] init];
    decideVC.tip = @"请输入同意理由";
    decideVC.pid = _ID;
    [self.navigationController pushViewController:decideVC animated:YES];
}

- (void)disAgree{
    OwnerDecideViewController *decideVC = [[OwnerDecideViewController alloc] init];
    decideVC.tip = @"请输入拒绝理由";
    decideVC.pid = _ID;
    [self.navigationController pushViewController:decideVC animated:YES];
}


- (NSString *)getIntervalTime:(NSInteger )time{
    NSInteger day;
    NSInteger hour;
    NSInteger min;
    day = time / 24 / 3600;
    hour = (time / 3600) % 24;
    min = (time / 60) % 60;
    if (day == 0) {
        if (hour == 0) {
            return [NSString stringWithFormat:@"已等待%ld分钟",(long)min];
        }else{
            return [NSString stringWithFormat:@"已等待%ld小时%ld分钟",(long)hour,min];
        }
    }else{
        return [NSString stringWithFormat:@"已等待%ld天%ld小时%ld分钟",(long)day,hour,min];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.5 animations:^{
        _memberView.center = CGPointMake(ScreenW/2, -ScreenH/2 -30);
        _grayView.alpha = 0;
        _memberView.alpha = 0;
    } completion:^(BOOL finished) {
        [_grayView removeFromSuperview];
        [_memberView removeFromSuperview];
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"srollDown" object:@{@"height":[NSNumber numberWithInt:scrollView.contentOffset.y]}];
}



@end
