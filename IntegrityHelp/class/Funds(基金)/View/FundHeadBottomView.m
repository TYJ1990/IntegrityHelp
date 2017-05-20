//
//  FundHeadBottomView.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/17.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "FundHeadBottomView.h"

@implementation FundHeadBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initlizeSubviews];
    }
    return self;
}



- (void)initlizeSubviews{
    UIImageView *donationImg;
    [self addSubview:({
        donationImg = [[UIImageView alloc] init];
        donationImg.layer.cornerRadius = 25;
        donationImg.layer.masksToBounds = YES;
        donationImg.image = [UIImage imageNamed:@"donation"];
        donationImg;
    })];
    
    UILabel *donationTitle;
    [self addSubview:({
        donationTitle = [[UILabel alloc] init];
        donationTitle.font = kFont(14);
        donationTitle.textColor = kGray;
        donationTitle.text = @"爱心捐款";
        donationTitle;
    })];
    
    UILabel *donationTip;
    [self addSubview:({
        donationTip = [[UILabel alloc] init];
        donationTip.font = kFont(12);
        donationTip.textColor = kLightGray;
        donationTip.text = @"爱心捐赠，增加积分";
        donationTip;
    })];
    
    [self addSubview:({
        _donationBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _donationBtn;
    })];
    
    UIImageView *borrowImg;
    [self addSubview:({
        borrowImg = [[UIImageView alloc] init];
        borrowImg.layer.cornerRadius = 25;
        borrowImg.layer.masksToBounds = YES;
        borrowImg.image = [UIImage imageNamed:@"borrow"];
        borrowImg;
    })];
    
    UILabel *borrowTitle;
    [self addSubview:({
        borrowTitle = [[UILabel alloc] init];
        borrowTitle.font = kFont(14);
        borrowTitle.textColor = kGray;
        borrowTitle.text = @"我要借款";
        borrowTitle;
    })];
    
    UILabel *borrowTip;
    [self addSubview:({
        borrowTip = [[UILabel alloc] init];
        borrowTip.font = kFont(12);
        borrowTip.textColor = kLightGray;
        borrowTip.text = @"平台借款，按时还款";
        borrowTip;
    })];
    
    [self addSubview:({
        _borrowBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _borrowBtn;
    })];
  
    WS(weakSelf)
    [donationImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.leading.mas_equalTo(weakSelf.mas_leading).with.offset(15.0f);
        make.height.width.mas_equalTo(50.0f);
    }];
    
    [donationTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(donationImg.mas_top).with.offset(2);
        make.leading.mas_equalTo(donationImg.mas_trailing).with.offset(5);
    }];
    
    [donationTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(donationImg.mas_bottom).with.offset(-2);
        make.leading.mas_equalTo(donationImg.mas_trailing).with.offset(5);
    }];
    
    [_donationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.mas_equalTo(weakSelf);
        make.width.mas_equalTo(ScreenW/2);
    }];
    
    [borrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.leading.mas_equalTo(weakSelf.mas_centerX).with.offset(8);
        make.height.width.mas_equalTo(50.0f);
    }];
    
    [borrowTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(donationTitle.mas_centerY);
        make.leading.mas_equalTo(borrowImg.mas_trailing).with.offset(5);
    }];
    
    [borrowTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(donationTip.mas_centerY);
        make.leading.mas_equalTo(borrowImg.mas_trailing).with.offset(5);
    }];
    
    [_borrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.mas_equalTo(weakSelf);
        make.width.mas_equalTo(ScreenW/2);
    }];
}




@end
