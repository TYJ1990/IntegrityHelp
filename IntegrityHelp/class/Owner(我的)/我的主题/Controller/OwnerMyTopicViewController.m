//
//  OwnerMyTopicViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/3.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "OwnerMyTopicViewController.h"
#import "SearchTools.h"
#import "FiltrateView.h"
#import "OwnerCheckingModel.h"
#import "MyCheckTableViewCell.h"
#import "HelpTypeModel.h"
#import "OwnerCheckingDetailViewController.h"

@interface OwnerMyTopicViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) SearchTools *searchTool;
@property(nonatomic,copy) UITableView *tableView;
@property(nonatomic,strong) OwnerCheckingModel *checkingModel;
@property(nonatomic,strong) FiltrateView *filtrateView;
@property(nonatomic,strong) NSString *typeID;
@property(nonatomic,strong) NSString *keywords;
@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) HelpTypeModel *typeModel;
@property(nonatomic,strong) UIView *conditionView;
@property(nonatomic,strong) UIView *placeView;
@property(nonatomic,strong) UILabel *conditionLabel;
@property(nonatomic,strong) UIButton *closeBtn;
@property(nonatomic,assign) NSInteger pageNumber;

@end

@implementation OwnerMyTopicViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initnavi];
    [self loadDataFromSeverce];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _status = @"";
    [self setUI];
    [self loadDataFromSeverce];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPlaceView) name:@"show2" object:nil];
}


- (void)loadDataFromSeverce{
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosIndex/myProjectList" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"],@"ty":_typeID ? _typeID : @"",@"keywords":_keywords  ? _keywords : @"",@"status":_status ? _status : @"",@"page":[NSNumber numberWithInteger:_pageNumber],@"pagesize":@10} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            if (_pageNumber == 1) {
                _checkingModel = [[OwnerCheckingModel alloc] initWithDictionary:response error:&error];
            }else{
                OwnerCheckingModel *model = [[OwnerCheckingModel alloc] initWithDictionary:response error:&error];
                [_checkingModel.data addObjectsFromArray:model.data];
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



- (void)loadData{
    [self.view loadingOnAnyView];
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



- (void)initnavi{
    [self initNav:@"我的主题" color:[UIColor whiteColor] imgName:@"back_black"];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kDarkText,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
}


- (void)setUI{
    _pageNumber = 1;
    [self.view addSubview:({
        _searchTool = [[[NSBundle mainBundle] loadNibNamed:@"SearchTools" owner:nil options:nil] firstObject];
        _searchTool.backgroundColor = [UIColor cyanColor];
        
        WS(weakSelf)
        _searchTool.finished = ^(NSInteger tag,NSString *key){
            switch (tag) {
                case 500:{
                    weakSelf.keywords = key;
                    weakSelf.typeID = @"";
                    weakSelf.status = @"";
                    [weakSelf loadDataFromSeverce];
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
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
        line.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
        line;
    })];
    
    [self.view addSubview:({
        _conditionView = [[UIView alloc] init];
        _conditionView;
    })];
    
    [self.view addSubview:({
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 135;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _pageNumber = 1;
            [self loadDataFromSeverce];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _pageNumber ++;
            [self loadDataFromSeverce];
        }];
        [_tableView registerNib:[UINib nibWithNibName:@"MyCheckTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
        _tableView;
    })];
    [_tableView setTableFooterView:[UIView new]];
    
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
    
    WS(superView)
    [_searchTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(superView.view.mas_top).with.offset(-51);
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
        _placeView = [[UIView alloc] initWithFrame:CGRectMake(0, 51, ScreenW, ScreenH - 51)];
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
    self.typeID = @"";
    self.keywords = @"";
    self.status = @"";
    self.filtrateView.hidden = YES;
    [self loadDataFromSeverce];
    self.closeBtn.hidden = YES;
}


- (void)initFiltrateViews{
    if (!_filtrateView) {
        WS(weakSelf)
        [self.view addSubview:({
            _filtrateView = [[FiltrateView alloc] initWithFrame:CGRectZero statusArray:@[@"未审核",@"审核中",@"审核通过",@"合作中",@"合作完成"] typeArray:_typeModel.data];
            _filtrateView.callBack = ^(NSString *status,NSString *type,NSString *name){
                weakSelf.typeID = type;
                if ([TXUtilsString isBlankString:status]) {
                    weakSelf.status = @"";
                }else{
                    weakSelf.status = [NSString stringWithFormat:@"%ld",[status integerValue] - 100];
                }
                [weakSelf loadDataFromSeverce];
                
                weakSelf.conditionLabel.text = [NSString stringWithFormat:@"筛选条件：%@%@",status.length>0?name.length>0?[NSString stringWithFormat:@"%@、",[weakSelf traslteWithString:status]]:[weakSelf traslteWithString:status]:@"",name?name:@""];
                if (status.length>0 || name.length > 0) {
                    [weakSelf.conditionView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(30.0f);
                    }];
                    weakSelf.closeBtn.hidden = NO;
                }else{
                    [weakSelf.conditionView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(0.0f);
                    }];
                    weakSelf.closeBtn.hidden = YES;
                }
            };
            _filtrateView;
        })];
        
        [_filtrateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_searchTool.mas_bottom).with.offset(-50);
            make.leading.trailing.mas_equalTo(weakSelf.view);
            make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        }];
    }else{
        [_filtrateView reloadDataWithStatusArray:@[@"未审核",@"审核中",@"审核通过",@"合作中",@"合作完成"] typeArray:_typeModel.data];
        _filtrateView.hidden = NO;
    }
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _checkingModel.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCheckTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell cellConfigureModle:_checkingModel.data[indexPath.row]];
    cell.status.text = [Utils getStatus:[[_checkingModel.data[indexPath.row] Status] integerValue]];
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:imageUrl(_myImg)]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OwnerCheckingDetailViewController *detailVC = [[OwnerCheckingDetailViewController alloc] init];
    detailVC.titleStr = [_checkingModel.data[indexPath.row] Title];
    detailVC.ID = [_checkingModel.data[indexPath.row] Id];
    detailVC.img = _myImg;
    detailVC.flag = @"topic";
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (NSString *)traslteWithString:(NSString *)index{
    NSString *str = @"";;
    if ([index isEqualToString:@"100"]) {
        str = @"未审核";
    }else if ([index isEqualToString:@"101"]){
        str = @"审核中";
    }else if ([index isEqualToString:@"102"]){
        str = @"审核通过";
    }else if ([index isEqualToString:@"103"]){
        str = @"合作中";
    }else if ([index isEqualToString:@"104"]){
        str = @"合作完成";
    }
    return str;
}


@end
