//
//  FiltrateView.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/3.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "FiltrateView.h"
#import "FiltrateCollectionViewCell.h"
#import "HelpTypeModel.h"


@interface FiltrateView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong) NSArray *statusArray;
@property(nonatomic,strong) NSArray *typeArray;
@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) NSString *status;
@property(nonatomic,assign) NSInteger index;
@property(nonatomic,strong) NSString *name;

@end

@implementation FiltrateView

- (instancetype)initWithFrame:(CGRect)frame statusArray:(NSArray *)statusArray typeArray:(NSArray *)typeArray{
    self = [super initWithFrame:frame];
    if (self) {
        _statusArray = statusArray;
        _typeArray = typeArray;
        [self initlizeSubViews];
        self.backgroundColor = [UIColor cyanColor];
    }
    return self;
}





- (void)initlizeSubViews{
    [self addSubview:({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10.0;
        layout.minimumInteritemSpacing = 20.0;
        layout.sectionInset = UIEdgeInsetsMake(10, 20, 15, 20);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = kWhite;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"FiltrateCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        _collectionView;
    })];
    
    [self addSubview:({
        UIButton *clickBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [clickBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        [clickBtn setTitleColor:kWhite forState:(UIControlStateNormal)];
        clickBtn.backgroundColor = kMainColor;
        [clickBtn addTarget:self action:@selector(click) forControlEvents:(UIControlEventTouchUpInside)];
        clickBtn.tag = 100;
        clickBtn;
    })];
}

- (void)layoutSubviews{
    UIButton *btn = [self viewWithTag:100];
    
    WS(weakSelf)
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.mas_equalTo(weakSelf);
        make.height.mas_equalTo(50);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(btn.mas_top);
        make.leading.top.trailing.mas_equalTo(weakSelf);
    }];
}




- (NSInteger )numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _statusArray ? 2 : 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _statusArray ? (section == 0 ? _statusArray.count : _typeArray.count) : _typeArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return section == 0 ? CGSizeMake(ScreenW, 40) : CGSizeMake(ScreenW, 30);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headView =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];

    for (UIView *view in headView.subviews) {
        [view removeFromSuperview];
    }
    headView.backgroundColor = kWhite;
    NSInteger height = indexPath.section == 0 ? 20 : 10;
    [headView addSubview:({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, height - 2, 16, 16)];
        view.backgroundColor = _statusArray ? indexPath.section == 0 ? kMainColor : RGB(255, 152, 25) : RGB(255, 152, 25);
        view.layer.cornerRadius = 8;
        view.layer.masksToBounds = YES;
        view;
    })];
    [headView addSubview:({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, height - 2, 100, 20)];
        label.text = _statusArray ? indexPath.section == 0 ? @"状态" : @"类型" : @"类型";
        label.textColor = [UIColor colorWithHex:0x333333];
        label.font = kFont(15);
        label;
    })];
    return headView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_statusArray) {
        if (indexPath.section == 0) {
            return CGSizeMake((ScreenW - 80) / 3,  50);
        }else{
            return CGSizeMake((ScreenW - 60) / 2,  50);
        }
    }else{
        return CGSizeMake((ScreenW - 60) / 2,  50);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FiltrateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = YES;
    
    if (_statusArray) {
        if (indexPath.section == 0) {
            cell.titleLabel.text = _statusArray[indexPath.row];
            if (indexPath.row == [_status integerValue] - 100) {
                cell.backgroundColor = kMainColor;
            }else{
                cell.backgroundColor = kMainGray;
            }
        }else{
            HelpTypeListModel *model = _typeArray[indexPath.row];
            cell.titleLabel.text = model.Name;
            if (indexPath.row == _index - 100) {
                cell.backgroundColor = RGB(255, 152, 25);
            }else{
                cell.backgroundColor = kMainGray;
            }
        }
    }else{
        HelpTypeListModel *model = _typeArray[indexPath.row];
        cell.titleLabel.text = model.Name;
        if (indexPath.row == _index - 100) {
            cell.backgroundColor = RGB(255, 152, 25);
        }else{
            cell.backgroundColor = kMainGray;
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FiltrateCollectionViewCell * cell = (FiltrateCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (_statusArray) {
        if (indexPath.section == 0) {
            cell.backgroundColor = kMainColor;
            _status = [NSString stringWithFormat:@"%ld",indexPath.row + 100];
        }else{
            HelpTypeListModel *model = _typeArray[indexPath.row];
            cell.backgroundColor = RGB(255, 152, 25);
            _type = model.Id;
            _index = indexPath.row + 100;
            _name = model.Name;
        }
    }else{
        cell.backgroundColor = RGB(255, 152, 25);
        HelpTypeListModel *model = _typeArray[indexPath.row];
        _type = model.Id;
        _index = indexPath.row + 100;
        _name = model.Name;
    }
    [_collectionView reloadData];
}



- (void)click{
    _callBack(_status,_type,_name);
    self.hidden = YES;
    _status = @"";
    _type = @"";
    _index = 0;
}


- (void)reloadDataWithStatusArray:(NSArray *)statusArray typeArray:(NSArray *)typeArray{
    _statusArray = statusArray;
    _typeArray = typeArray;
    [_collectionView reloadData];
}



@end
