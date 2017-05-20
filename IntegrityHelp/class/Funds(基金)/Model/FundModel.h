//
//  FundModel.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/17.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class FundListModel;

@protocol FundListModel

@end


@interface FundModel : JSONModel
@property(nonatomic,strong) NSArray<FundListModel,Optional> *data;
@end


@interface FundListModel : JSONModel
@property(nonatomic,strong) NSString<Optional> *Addtime;
@property(nonatomic,strong) NSString<Optional> *Bank_id;
@property(nonatomic,strong) NSString<Optional> *Bank_name;
@property(nonatomic,strong) NSString<Optional> *Card_no;
@property(nonatomic,strong) NSString<Optional> *Content;
@property(nonatomic,strong) NSString<Optional> *Id;
@property(nonatomic,strong) NSString<Optional> *Isshow;
@property(nonatomic,strong) NSString<Optional> *Month;
@property(nonatomic,strong) NSString<Optional> *Num;
@property(nonatomic,strong) NSString<Optional> *Pic1;
@property(nonatomic,strong) NSString<Optional> *Pic2;
@property(nonatomic,strong) NSString<Optional> *Pic3;
@property(nonatomic,strong) NSString<Optional> *Rmonth;
@property(nonatomic,strong) NSString<Optional> *Title;
@property(nonatomic,strong) NSString<Optional> *U_name;
@property(nonatomic,strong) NSString<Optional> *Uid;

@end
