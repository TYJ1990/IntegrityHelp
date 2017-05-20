//
//  OwnerMyCheckViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/2.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "OwnerMyCheckViewController.h"
#import "SearchTools.h"
#import "FiltrateView.h"
#import "OwnerCheckingModel.h"
#import "MyCheckTableViewCell.h"
#import "OwnerCheckingDetailViewController.h"
#import "HelpTypeModel.h"

@interface OwnerMyCheckViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) SearchTools *searchTool;
@property(nonatomic,strong) FiltrateView *filtrateView;
@property(nonatomic,copy) UITableView *tableView;
@property(nonatomic,strong) OwnerCheckingModel *checkingModel;
@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) HelpTypeModel *typeModel;
@property(nonatomic,strong) NSString *typeID;
@property(nonatomic,strong) NSString *typeID2;
@property(nonatomic,strong) NSString *keywords;
@property(nonatomic,strong) NSString *keywords2;
@property(nonatomic,strong) UIView *placeView;
@property(nonatomic,strong) UIView *conditionView;
@property(nonatomic,strong) UILabel *conditionLabel;
@property(nonatomic,strong) UIButton *closeBtn;
@property(nonatomic,assign) NSInteger pageNumber;

@end

@implementation OwnerMyCheckViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initnavi];
    if ([_type isEqualToString:@"checking"]) {
        [self loadDataFromSeverce];
    }else{
        [self loadDataFromSeverce2];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self loadData];
    [self loadDataFromSeverce];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPlaceView) name:@"show" object:nil];
}



- (void)initnavi{
    [self initNav:@"我的审核" color:[UIColor whiteColor] imgName:@"back_black"];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kDarkText,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
}


- (void)loadDataFromSeverce{
    
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosIndex/myFviewList" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"],@"ty":_typeID ? _typeID : @"",@"keywords":_keywords  ? _keywords : @"",@"page":[NSNumber numberWithInteger:_pageNumber],@"pagesize":@10} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            if (_pageNumber == 1) {
                _checkingModel = [[OwnerCheckingModel alloc] initWithDictionary:response error:&error];
                if (!error) {
                    [_searchTool.checking setTitle:[NSString stringWithFormat:@"待我审核（%ld）",_checkingModel.data.count] forState:(UIControlStateNormal)];
                    if (_checkingModel.data.count == 0) {
                        [self.view Message:@"暂无数据" HiddenAfterDelay:1];
                    }
                }
            }else{
                OwnerCheckingModel *model = [[OwnerCheckingModel alloc] initWithDictionary:response error:&error];
                [_checkingModel.data addObjectsFromArray:model.data];
            }
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            _tableView.hidden = NO;
            [_tableView reloadData];
        }
    } fail:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [self.view removeAnyView];
    }];
}

- (void)loadDataFromSeverce2{
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosIndex/myFviewListYes" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"],@"ty":_typeID2 ? _typeID2 : @"",@"keywords":_keywords2 ? _keywords2 : @"",@"page":[NSNumber numberWithInteger:_pageNumber],@"pagesize":@10} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            if (_pageNumber == 1) {
                _checkingModel = [[OwnerCheckingModel alloc] initWithDictionary:response error:&error];
                if (!error) {
                    [_searchTool.checking setTitle:[NSString stringWithFormat:@"待我审核（%ld）",_checkingModel.data.count] forState:(UIControlStateNormal)];
                    if (_checkingModel.data.count == 0) {
                        [self.view Message:@"暂无数据" HiddenAfterDelay:1];
                    }
                }
            }else{
                OwnerCheckingModel *model = [[OwnerCheckingModel alloc] initWithDictionary:response error:&error];
                [_checkingModel.data addObjectsFromArray:model.data];
            }
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            _tableView.hidden = NO;
            [_tableView reloadData];
        }
    } fail:^(NSError *error) {
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
        [self.view removeAnyView];
    }];
}


- (void)loadData{
//    [self.view loadingOnAnyView];
    [HYBNetworking getWithUrl:@"IosProject/projectType" refreshCache:NO params:nil success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            _typeModel = [[HelpTypeModel alloc] initWithDictionary:response error:&error];
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}



- (void)setUI{
    _type = @"checking";
    _pageNumber = 1;
    [self.view addSubview:({
        _searchTool = [[[NSBundle mainBundle] loadNibNamed:@"SearchTools" owner:nil options:nil] firstObject];
        _searchTool.backgroundColor = [UIColor cyanColor];
        [_searchTool.checking setTitle:@"待我审核（0）" forState:(UIControlStateNormal)];
        [_searchTool.checked setTitle:@"我已审核" forState:(UIControlStateNormal)];
        WS(weakSelf)
        _searchTool.finished = ^(NSInteger tag,NSString *keywords){
            [weakSelf.conditionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0.0f);
            }];
            weakSelf.conditionLabel.text = @"";
            weakSelf.closeBtn.hidden = YES;
            switch (tag) {
                case 100:{
                    weakSelf.typeID2 = @"";
                    weakSelf.keywords2 = @"";
                    weakSelf.filtrateView.hidden = YES;
                    weakSelf.tableView.hidden = YES;
                    [weakSelf loadDataFromSeverce2];
                    weakSelf.type = @"checked";
                }
                    break;
                case 200:{
                    weakSelf.typeID = @"";
                    weakSelf.keywords = @"";
                    weakSelf.tableView.hidden = YES;
                    weakSelf.filtrateView.hidden = YES;
                    [weakSelf loadDataFromSeverce];
                    weakSelf.type = @"checking";
                }
                    break;
                case 500:{
                    if ([weakSelf.type isEqualToString:@"checking"]) {
                        weakSelf.keywords = keywords;
                        [weakSelf loadDataFromSeverce];
                    }else{
                        weakSelf.keywords2 = keywords;
                        [weakSelf loadDataFromSeverce2];
                    }
                    weakSelf.placeView.hidden = YES;
                }
                    break;
                case 600:{
                    [weakSelf initFiltrateViews];
                }
                    break;
                default:
                    break;
            }
        };
        _searchTool;
    })];
    
    [self.view addSubview:({
        _conditionView = [[UIView alloc] init];
        _conditionView;
    })];
    
    [_conditionView addSubview:({
        _conditionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, ScreenW, 20)];
        _conditionLabel.textColor = [UIColor colorWithHex:0x333333];
        _conditionLabel.font = kFont(15);
        _conditionLabel;
    })];
    
    [_conditionView addSubview:({
        _closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_closeBtn addTarget:self action:@selector(closeSearch) forControlEvents:(UIControlEventTouchUpInside)];
        _closeBtn.frame = CGRectMake(ScreenW - 50, 0, 50, 30);
        [_closeBtn setImage:[UIImage imageNamed:@"owner_close2"] forState:(UIControlStateNormal)];
        _closeBtn.hidden = YES;
        _closeBtn;
    })];
    
    [_conditionView addSubview:({
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 29, ScreenW, 1)];
        line.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
        line;
    })];
    
    [self.view addSubview:({
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 135;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _pageNumber = 1;
            if ([self.type isEqualToString:@"checking"]) {
                [self loadDataFromSeverce];
            }else{
                [self loadDataFromSeverce2];
            }
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _pageNumber ++;
            if ([self.type isEqualToString:@"checking"]) {
                [self loadDataFromSeverce];
            }else{
                [self loadDataFromSeverce2];
            }
        }];
        [_tableView registerNib:[UINib nibWithNibName:@"MyCheckTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
        _tableView;
    })];
    [_tableView setTableFooterView:[UIView new]];
    
    WS(superView)
    [_searchTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(superView.view.mas_top).with.offset(0);
        make.leading.trailing.mas_equalTo(superView.view);
        make.height.mas_equalTo(102);
    }];
    
    [_conditionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.0f);
        make.top.mas_equalTo(_searchTool.mas_bottom);
        make.leading.trailing.mas_equalTo(superView.view);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_conditionView.mas_bottom).with.offset(1);
        make.leading.trailing.bottom.mas_equalTo(superView.view);
    }];
    
    [self.view addSubview:({
        _placeView = [[UIView alloc] initWithFrame:CGRectMake(0, 102, ScreenW, ScreenH - 102)];
        _placeView.backgroundColor = [UIColor colorWithHex:0xf9f9f9];
        _placeView.hidden = YES;
        _placeView;
    })];
}


- (void)showPlaceView{
    _placeView.hidden = NO;
}


- (void)closeSearch{
    [self.conditionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.0f);
    }];
    self.conditionLabel.text = @"";
    self.typeID2 = @"";
    self.keywords2 = @"";
    self.filtrateView.hidden = YES;
    self.tableView.hidden = YES;
    if ([self.type isEqualToString:@"checking"]) {
        [self loadDataFromSeverce];
    }else{
        [self loadDataFromSeverce2];
    }
    self.closeBtn.hidden = YES;
}



- (void)initFiltrateViews{
    if (!_filtrateView) {
        WS(weakSelf)
        [self.view addSubview:({
            _filtrateView = [[FiltrateView alloc] initWithFrame:CGRectZero statusArray:nil typeArray:_typeModel.data];
            _filtrateView.callBack = ^(NSString *status,NSString *type,NSString *name){
                if ([weakSelf.type isEqualToString:@"checking"]) {
                    weakSelf.typeID = type;
                    [weakSelf loadDataFromSeverce];
                }else{
                    weakSelf.typeID2 = type;
                    [weakSelf loadDataFromSeverce2];
                }
                [weakSelf.conditionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(30.0f);
                }];
                weakSelf.conditionLabel.text = [NSString stringWithFormat:@"筛选条件：%@ %@",status?status:@"",name?name:@""];
                weakSelf.closeBtn.hidden = NO;
            };
            _filtrateView;
        })];
        
        [_filtrateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_searchTool.mas_bottom).with.offset(-50);
            make.leading.trailing.mas_equalTo(weakSelf.view);
            make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        }];
    }else{
        [_filtrateView reloadDataWithStatusArray:nil typeArray:_typeModel.data];
        _filtrateView.hidden = NO;
    }
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _checkingModel.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCheckTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell cellConfigureModle:_checkingModel.data[indexPath.row]];
    if ([_type isEqualToString:@"checking"]) {
        cell.status.text = @"未审核";
    }else{
        cell.status.text = @"已审核";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OwnerCheckingDetailViewController *detailVC = [[OwnerCheckingDetailViewController alloc] init];
    detailVC.titleStr = [_checkingModel.data[indexPath.row] Title];
    detailVC.ID = [_checkingModel.data[indexPath.row] Id];
    detailVC.img = [_checkingModel.data[indexPath.row] Pic];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
