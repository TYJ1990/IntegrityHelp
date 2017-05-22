//
//  FundCardModel.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/18.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class FundCardListModel;
@protocol FundCardListModel

@end

@interface FundCardModel : JSONModel

@property (nonatomic,strong) NSArray<FundCardListModel,Optional> *data;
@end


@interface FundCardListModel : JSONModel

@property (nonatomic,strong) NSString<Optional> *Addtime;
@property (nonatomic,strong) NSString<Optional> *Card_no;
@property (nonatomic,strong) NSString<Optional> *Id;
@property (nonatomic,strong) NSString<Optional> *Name;
@property (nonatomic,strong) NSString<Optional> *Uid;
@property (nonatomic,strong) NSString<Optional> *flag;

@end
