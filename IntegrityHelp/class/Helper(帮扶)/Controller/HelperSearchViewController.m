//
//  HelperSearchViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/27.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "HelperSearchViewController.h"
#import "HelpTypeModel.h"
#import "FiltrateCollectionViewCell.h"
#import "HelperModel.h"
#import "HelperSearchResultViewController.h"

@interface HelperSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) UISearchBar *searchBar;
@property(nonatomic,copy) UITableView *tableView;
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) HelpTypeModel *typeModel;
@property(nonatomic,strong) NSMutableArray *searchHistory;


@end

@implementation HelperSearchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initnavi];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadTypeData];
    _searchHistory = [Utils getInfoWithKey:@"search"];
}



- (void)initnavi{
    [self initNav:@"" color:kWhite imgName:@"back_black"];
    self.navigationItem.titleView = self.searchBar;
    self.view.backgroundColor = kMainGray;
}


- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    }
    return _searchBar;
}


- (void)setUI{
    
    [self.view addSubview:({
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kMainGray;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tabCell"];
        _tableView;
    })];
    
    WS(weakSelf);
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.view.mas_top);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
    }];
    
    NSInteger count;
    if (_typeModel.data.count > 3) {
        count = _typeModel.data.count % 3 == 0 ? _typeModel.data.count / 3 : _typeModel.data.count / 3 + 1;
    } else {
        count = 1;
    }
    [self.view addSubview:({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, count * 44.0 + 50) collectionViewLayout:layout];
        _collectionView.backgroundColor = kMainGray;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"FiltrateCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        _collectionView;
    })];
    _tableView.tableHeaderView = _collectionView;
}


- (void)loadTypeData{
    [self.view loadingOnAnyView];
    [HYBNetworking getWithUrl:@"IosProject/projectType" refreshCache:NO params:nil success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            _typeModel = [[HelpTypeModel alloc] initWithDictionary:response error:&error];
            if (!error) {
                [self setUI];
            }
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _typeModel.data.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(ScreenW, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ScreenW/3, 44);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FiltrateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.layer.borderColor = [UIColor colorWithHex:0xcccccc].CGColor;
    cell.layer.borderWidth = 0.3;
    cell.titleLabel.text = [_typeModel.data[indexPath.row] Name];
    cell.backgroundColor = kWhite;
    cell.titleLabel.textColor = kDarkGray;
    cell.titleLabel.font = kFont(14);
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headView =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    [headView addSubview:({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 70, 20)];
        label.text = @"分类搜索";
        label.textColor = kDarkGray;
        label.font = kFont(16);
        label;
    })];
    return headView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self searchResult:[_typeModel.data[indexPath.row] Id]];
}

- (void)searchResult:(NSString *)type{
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosProject/searchTypeProjectList" refreshCache:NO params:@{@"ty":type} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            HelperModel *model = [[HelperModel alloc] initWithDictionary:response error:&error];
            if (!error && model.data.count > 0) {
                HelperSearchResultViewController *resultVC = [[HelperSearchResultViewController alloc] init];
                resultVC.model = model;
                [self.navigationController pushViewController:resultVC animated:YES];
            }else if (!error && model.data.count == 0){
                [self.view Message:@"没有发现你要搜的内容哦" HiddenAfterDelay:1];
            }
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _searchHistory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tabCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"help_searchBlack"];
    cell.textLabel.text = _searchHistory[indexPath.row];
    cell.textLabel.textColor = kDarkGray;
    cell.textLabel.font = kFont(15);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 15, 70, 30)];
    label.font = kFont(16);
    label.textColor = kDarkGray;
    label.text = @"    历史搜索";
    return label;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
    view.backgroundColor = kWhite;
    [view addSubview:({
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(0, 0, ScreenW, 40);
        btn.titleLabel.font = kFont(13);
        [btn setTitleColor:kGray forState:(UIControlStateNormal)];
        [btn setTitle:@"清除历史记录"forState:(UIControlStateNormal)];
        btn.layer.borderColor = kMainGray.CGColor;
        btn.layer.borderWidth = 1;
        [btn addTarget:self action:@selector(removeHistory) forControlEvents:(UIControlEventTouchUpInside)];
        btn;
    })];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosProject/searchProjectList" refreshCache:NO params:@{@"content":cell.textLabel.text} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            HelperModel *model = [[HelperModel alloc] initWithDictionary:response error:&error];
            if (!error && model.data.count > 0) {
                HelperSearchResultViewController *resultVC = [[HelperSearchResultViewController alloc] init];
                resultVC.model = model;
                [self.navigationController pushViewController:resultVC animated:YES];
            }else if (!error && model.data.count == 0){
                [self.view Message:@"没有发现你要搜的内容哦" HiddenAfterDelay:1];
            }
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}



- (void)removeHistory{
    BaseAlertControler *alert = [BaseAlertControler new];
    WS(weakSelf)
    UIAlertController *alertVC = [alert alertmessage:@"确定" Title:@"确认清空历史记录？" andBlock:^{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"search"];
        weakSelf.searchHistory = [Utils getInfoWithKey:@"search"];
        [weakSelf.tableView reloadData];
    }];
    [self presentViewController:alertVC animated:YES completion:nil];
}





- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosProject/searchProjectList" refreshCache:NO params:@{@"content":searchBar.text} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            HelperModel *model = [[HelperModel alloc] initWithDictionary:response error:&error];
            if (!error && model.data.count > 0) {
                HelperSearchResultViewController *resultVC = [[HelperSearchResultViewController alloc] init];
                resultVC.model = model;
                [self.navigationController pushViewController:resultVC animated:YES];
            }else if (!error && model.data.count == 0){
                [self.view Message:@"没有发现你要搜的内容哦" HiddenAfterDelay:1];
            }
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
    
    [Utils conserveInfo:searchBar.text key:@"search" number:5];
    _searchHistory = [Utils getInfoWithKey:@"search"];
    [_tableView reloadData];
}


@end
