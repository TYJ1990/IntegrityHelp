//
//  OwnerCheckingModel.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/3.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class OwnerCheckingListModel;

@protocol OwnerCheckingListModel

@end


@interface OwnerCheckingModel : JSONModel


@property(nonatomic,strong) NSMutableArray<OwnerCheckingListModel,Optional> *data;

@end


@interface OwnerCheckingListModel : JSONModel

@property(nonatomic,strong) NSString<Optional> *Addtime;
@property(nonatomic,strong) NSString<Optional> *Content;
@property(nonatomic,strong) NSString<Optional> *F_review;
@property(nonatomic,strong) NSString<Optional> *Id;
@property(nonatomic,strong) NSString<Optional> *T_name;
@property(nonatomic,strong) NSString<Optional> *Title;
@property(nonatomic,strong) NSString<Optional> *U_name;
@property(nonatomic,strong) NSString<Optional> *time;
@property(nonatomic,strong) NSString<Optional> *Pic;
@property(nonatomic,strong) NSNumber<Optional> *Status;

@end
